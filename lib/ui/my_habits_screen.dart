import 'package:flutter/material.dart';

import '../data/family_store.dart';
import '../l10n/app_localizations.dart';
import '../models/family.dart';
import 'celebration.dart';
import 'common.dart';
import 'habit_editor.dart';
import 'look.dart';
import 'progress_screen.dart';
import 'today_screen.dart';

/// Every habit of the active person on one line each, with the week's days:
/// the planned days are marked and the done ones ticked.
class MyHabitsScreen extends StatefulWidget {
  const MyHabitsScreen({super.key, required this.store});

  final FamilyStore store;

  @override
  State<MyHabitsScreen> createState() => _MyHabitsScreenState();
}

class _MyHabitsScreenState extends State<MyHabitsScreen> {
  Period _week = const Period(Span.week);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final look = Look.of(context);
    final store = widget.store;
    final me = store.activeMember;
    if (me == null) return Center(child: Text(l10n.noHabitsYet));
    final firstWeekday = store.weekStartFor(Localizations.localeOf(context));
    final start = _week.start(store.today, firstWeekday);
    final days = [
      for (var i = 0; i < 7; i++)
        DateTime(start.year, start.month, start.day + i),
    ];
    final mine = store.habitsOf(me.id);
    final family = store.familyHabits;

    Widget section(String title, List<Habit> habits) => SoftCard(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 8, 8),
      child: Column(
        children: [
          _DaysHeader(title: title, days: days, today: store.today),
          for (final habit in habits)
            _HabitWeekRow(store: store, habit: habit, days: days),
        ],
      ),
    );

    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 96),
      children: [
        ProfileSwitcher(store: store),
        const SizedBox(height: 12),
        PeriodPicker(
          period: _week,
          firstWeekday: firstWeekday,
          today: store.today,
          showSpan: false,
          onChanged: (p) => setState(() => _week = p),
        ),
        if (mine.isNotEmpty) section(l10n.myHabits, mine),
        if (family.isNotEmpty) section(l10n.familyHabits, family),
        if (mine.isEmpty && family.isEmpty)
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

const _dayWidth = 30.0;

class _DaysHeader extends StatelessWidget {
  const _DaysHeader({
    required this.title,
    required this.days,
    required this.today,
  });

  final String title;
  final List<DateTime> days;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final look = Look.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(child: Text(title, style: look.heading(17))),
          for (final day in days)
            SizedBox(
              width: _dayWidth,
              child: Column(
                children: [
                  Text(
                    weekdayLetter(context, day.weekday),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: day == today
                          ? FontWeight.w800
                          : FontWeight.w500,
                      color: day == today ? look.primary : look.muted,
                    ),
                  ),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      fontSize: 10,
                      color: day == today ? look.primary : look.muted,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _HabitWeekRow extends StatelessWidget {
  const _HabitWeekRow({
    required this.store,
    required this.habit,
    required this.days,
  });

  final FamilyStore store;
  final Habit habit;
  final List<DateTime> days;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final look = Look.of(context);
    final checked = {
      for (final c in store.checkIns)
        if (c.habitId == habit.id) c.day,
    };
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: store.canManage
          ? () => showHabitEditor(context, store, habit: habit)
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            HabitBubble(
              habit: habit,
              look: categoryLook(l10n, store, habit.category),
              size: 32,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                habit.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: look.ink,
                  height: 1.2,
                ),
              ),
            ),
            for (final day in days)
              SizedBox(
                width: _dayWidth,
                child: Center(
                  child: _DayDot(
                    planned: habit.isScheduledOn(day),
                    done: checked.contains(day),
                    today: day == store.today,
                    future: day.isAfter(store.today),
                    onTap: day == store.today && store.canCheckIn(habit)
                        ? () => _toggle(context)
                        : null,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggle(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final name = store.activeMember?.nickname ?? '';
    if (!store.isDoneToday(habit)) celebrateHabit(context, habit, habit.name);
    if (await store.toggleToday(habit)) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.familyCheckedIn(name, habit.name))),
      );
    }
  }
}

/// A day of a habit's week: ticked when done, a ring when planned, a small
/// dot when the habit isn't planned that day.
class _DayDot extends StatelessWidget {
  const _DayDot({
    required this.planned,
    required this.done,
    required this.today,
    required this.future,
    this.onTap,
  });

  final bool planned;
  final bool done;
  final bool today;
  final bool future;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final look = Look.of(context);
    const size = 24.0;
    final Widget dot;
    if (done) {
      dot = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: look.done, shape: BoxShape.circle),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
      );
    } else if (planned) {
      dot = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: future ? null : look.tint(look.primary),
          border: Border.all(
            color: today
                ? look.primary
                : look.primary.withValues(alpha: future ? 0.45 : 0.7),
            width: today ? 2.5 : 1.8,
          ),
        ),
      );
    } else {
      dot = Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: look.muted.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
      );
    }
    if (onTap == null) return dot;
    return Semantics(
      button: true,
      checked: done,
      child: InkResponse(onTap: onTap, radius: 18, child: dot),
    );
  }
}
