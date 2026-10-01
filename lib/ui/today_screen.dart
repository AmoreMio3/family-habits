import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../data/family_store.dart';
import '../l10n/app_localizations.dart';
import '../logic/progress.dart';
import '../logic/week.dart';
import '../models/family.dart';
import 'family_progress_card.dart';
import 'common.dart';
import 'habit_editor.dart';
import 'look.dart';
import 'pin_dialog.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key, required this.store});

  final FamilyStore store;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final look = Look.of(context);
    final locale = Localizations.localeOf(context);
    final weekStart = startOfWeek(store.today, store.weekStartFor(locale));
    final me = store.activeMember;
    if (me == null) return Center(child: Text(l10n.noHabitsYet));
    final mine = store.habitsOf(me.id);
    String doneOf(List<Habit> habits) =>
        '${habits.where(store.isDoneToday).length}/${habits.length}';

    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 96),
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.MMMMEEEEd(locale.toString()).format(store.today),
                style: TextStyle(color: look.muted, fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(l10n.hiName(me.nickname), style: look.heading(30)),
            ],
          ),
        ),
        _ProfileSwitcher(store: store),
        const SizedBox(height: 16),
        FamilyProgressCard(store: store, weekStart: weekStart),
        if (store.familyHabits.isNotEmpty) ...[
          SectionTitle(l10n.familyHabits, trailing: doneOf(store.familyHabits)),
          for (final habit in store.familyHabits)
            HabitCard(store: store, habit: habit, weekStart: weekStart),
        ],
        if (mine.isNotEmpty) ...[
          SectionTitle(l10n.myHabits, trailing: doneOf(mine)),
          for (final habit in mine)
            HabitCard(store: store, habit: habit, weekStart: weekStart),
        ],
        if (mine.isEmpty && store.familyHabits.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                l10n.noHabitsYet,
                style: TextStyle(color: look.muted),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProfileSwitcher extends StatelessWidget {
  const _ProfileSwitcher({required this.store});

  final FamilyStore store;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final look = Look.of(context);
    return Semantics(
      label: l10n.switchProfile,
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          for (final m in store.availableMembers)
            _ProfileButton(
              key: Key('profile-${m.id}'),
              name: m.nickname,
              role: m.isParent ? l10n.parent : l10n.child,
              color: memberColor(context, store, m.id),
              selected: m.id == store.activeMember?.id,
              look: look,
              onTap: () => _open(context, store, m),
            ),
        ],
      ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  const _ProfileButton({
    super.key,
    required this.name,
    required this.role,
    required this.color,
    required this.selected,
    required this.look,
    required this.onTap,
  });

  final String name;
  final String role;
  final Color color;
  final bool selected;
  final Look look;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '$name, $role',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? look.primary : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: MemberAvatar(name: name, color: color, size: 54),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? look.ink : look.muted,
                  fontSize: 14,
                ),
              ),
              Text(role, style: TextStyle(color: look.muted, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _open(
  BuildContext context,
  FamilyStore store,
  Member member,
) async {
  if (store.needsPin(member) && !await askPin(context, store, member)) return;
  store.switchTo(member.id);
}

/// One habit for today: tap anywhere to check it in.
class HabitCard extends StatelessWidget {
  const HabitCard({
    super.key,
    required this.store,
    required this.habit,
    required this.weekStart,
  });

  final FamilyStore store;
  final Habit habit;
  final DateTime weekStart;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final look = Look.of(context);
    final done = store.isDoneToday(habit);
    final cat = categoryLook(l10n, store, habit.category);
    final enabled = store.canCheckIn(habit);

    final Widget subtitle;
    if (habit.isFamily) {
      subtitle = _Meta(
        icon: Icons.groups_rounded,
        iconColor: look.familyColor,
        text: l10n.weekTarget(
          doneThisWeek(habit, store.checkIns, weekStart),
          habit.timesPerWeek,
        ),
      );
    } else {
      final days = streak(habit, store.checkIns, store.today);
      subtitle = Wrap(
        spacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            habit.definition ?? cat.label,
            style: TextStyle(color: look.muted, fontSize: 13),
          ),
          _Meta(
            icon: Icons.local_fire_department_rounded,
            iconColor: days > 0 ? look.streak : look.muted,
            text: l10n.streakDays(days),
          ),
        ],
      );
    }

    final bubble = IconBubble(icon: cat.icon, color: cat.color);
    return Semantics(
      checked: done,
      enabled: enabled,
      child: SoftCard(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 14, 12),
        color: done
            ? Color.alphaBlend(look.done.withValues(alpha: 0.10), look.card)
            : null,
        onTap: enabled ? () => _toggle(context) : null,
        child: Row(
          children: [
            if (store.canManage)
              IconButton(
                padding: EdgeInsets.zero,
                tooltip: l10n.editHabit,
                onPressed: () => showHabitEditor(context, store, habit: habit),
                icon: bubble,
              )
            else
              bubble,
            const SizedBox(width: 12),
            Expanded(
              child: Opacity(
                opacity: enabled || done ? 1 : 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: look.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    subtitle,
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            CheckCircle(done: done, enabled: enabled),
          ],
        ),
      ),
    );
  }

  Future<void> _toggle(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final name = store.activeMember?.nickname ?? '';
    final familyCheckIn = await store.toggleToday(habit);
    if (familyCheckIn) {
      // Stand-in for the push notification every member will get.
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.familyCheckedIn(name, habit.name))),
      );
    }
  }
}

class _Meta extends StatelessWidget {
  const _Meta({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  final IconData icon;
  final Color iconColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    final look = Look.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 3),
        Flexible(
          child: Text(text, style: TextStyle(color: look.muted, fontSize: 13)),
        ),
      ],
    );
  }
}

/// The big round check on a habit: empty ring, or a filled circle with a tick.
class CheckCircle extends StatelessWidget {
  const CheckCircle({super.key, required this.done, required this.enabled});

  final bool done;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final look = Look.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutBack,
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done ? look.done : Colors.transparent,
        border: Border.all(
          color: done ? look.done : look.muted.withValues(alpha: 0.45),
          width: 2.5,
        ),
      ),
      child: done
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 24)
          : enabled
          ? null
          : Icon(Icons.lock_outline_rounded, color: look.muted, size: 18),
    );
  }
}
