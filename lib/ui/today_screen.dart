import 'package:flutter/material.dart';

import '../data/family_store.dart';
import '../l10n/app_localizations.dart';
import '../logic/progress.dart';
import '../logic/week.dart';
import '../models/family.dart';
import 'family_progress_card.dart';
import 'common.dart';
import 'habit_editor.dart';
import 'pin_dialog.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key, required this.store});

  final FamilyStore store;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final weekStart = startOfWeek(store.today, store.weekStartFor(locale));
    final me = store.activeMember;
    if (me == null) return Center(child: Text(l10n.noHabitsYet));
    final mine = store.habitsOf(me.id);

    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
      children: [
        _ProfileSwitcher(store: store),
        const SizedBox(height: 12),
        FamilyProgressCard(store: store, weekStart: weekStart),
        const SizedBox(height: 20),
        _SectionTitle(l10n.familyHabits),
        for (final habit in store.familyHabits)
          _HabitTile(store: store, habit: habit, weekStart: weekStart),
        const SizedBox(height: 20),
        _SectionTitle(l10n.myHabits),
        for (final habit in mine)
          _HabitTile(store: store, habit: habit, weekStart: weekStart),
        if (mine.isEmpty && store.familyHabits.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text(l10n.noHabitsYet)),
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
    return Semantics(
      label: l10n.switchProfile,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final m in store.availableMembers)
            ChoiceChip(
              avatar: CircleAvatar(child: Text(m.nickname.characters.first)),
              label: Text(
                '${m.nickname} · ${m.isParent ? l10n.parent : l10n.child}',
              ),
              selected: m.id == store.activeMember?.id,
              showCheckmark: false,
              onSelected: (_) => _open(context, store, m),
            ),
        ],
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(bottom: 4),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );
}

class _HabitTile extends StatelessWidget {
  const _HabitTile({
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
    final done = store.isDoneToday(habit);
    final look = categoryLook(l10n, store, habit.category);
    final enabled = store.canCheckIn(habit);
    final subtitle = habit.isFamily
        ? l10n.weekTarget(
            doneThisWeek(habit, store.checkIns, weekStart),
            habit.timesPerWeek,
          )
        : '${habit.definition ?? look.label} · ${l10n.streakDays(streak(habit, store.checkIns, store.today))}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: CheckboxListTile(
        value: done,
        onChanged: enabled ? (_) => _toggle(context) : null,
        controlAffinity: ListTileControlAffinity.leading,
        secondary: store.canManage
            ? IconButton(
                icon: Icon(look.icon, color: look.color),
                tooltip: l10n.editHabit,
                onPressed: () => showHabitEditor(context, store, habit: habit),
              )
            : Icon(look.icon, color: look.color),
        title: Text(habit.name),
        subtitle: Text(subtitle),
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
