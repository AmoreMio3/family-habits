import 'package:flutter/material.dart';

import '../data/family_store.dart';
import '../l10n/app_localizations.dart';
import '../logic/progress.dart';
import '../logic/week.dart';
import '../models/family.dart';
import 'family_progress_card.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key, required this.store});

  final FamilyStore store;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final weekStart = startOfWeek(store.today, firstDayOfWeek(locale));
    final me = store.activeMember;

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
        for (final habit in store.habitsOf(me.id))
          _HabitTile(store: store, habit: habit, weekStart: weekStart),
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
          for (final m in store.members)
            ChoiceChip(
              avatar: CircleAvatar(child: Text(m.nickname.characters.first)),
              label: Text(
                '${m.nickname} · ${m.isParent ? l10n.parent : l10n.child}',
              ),
              selected: m.id == store.activeMember.id,
              showCheckmark: false,
              onSelected: (_) => store.switchTo(m.id),
            ),
        ],
      ),
    );
  }
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
    final enabled = store.canCheckIn(habit);
    final subtitle = habit.isFamily
        ? l10n.weekTarget(
            doneThisWeek(habit, store.checkIns, weekStart),
            habit.timesPerWeek,
          )
        : '${habit.category.label(l10n)} · ${l10n.streakDays(streak(habit, store.checkIns, store.today))}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: CheckboxListTile(
        value: done,
        onChanged: enabled ? (_) => _toggle(context) : null,
        controlAffinity: ListTileControlAffinity.leading,
        secondary: Icon(habit.category.icon, color: habit.category.color),
        title: Text(habit.name),
        subtitle: Text(subtitle),
      ),
    );
  }

  void _toggle(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final familyCheckIn = store.toggleToday(habit);
    if (familyCheckIn) {
      // Stand-in for the push notification every member will get.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.familyCheckedIn(store.activeMember.nickname, habit.name),
          ),
        ),
      );
    }
  }
}
