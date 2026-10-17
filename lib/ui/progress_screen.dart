import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../data/family_store.dart';
import '../l10n/app_localizations.dart';
import '../logic/progress.dart';
import '../logic/week.dart';
import '../models/family.dart';
import 'common.dart';
import 'family_progress_card.dart';
import 'look.dart';
import 'today_screen.dart';

enum Span { week, month }

/// The week or month being looked at: 0 is this one, -1 the one before.
class Period {
  const Period(this.span, [this.offset = 0]);

  final Span span;
  final int offset;

  /// How far back the app keeps check-ins (60 days).
  int get oldest => span == Span.week ? -8 : -1;

  Period moved(int by) => Period(span, offset + by);

  DateTime start(DateTime today, int firstWeekday) => switch (span) {
    Span.week => () {
      final s = startOfWeek(today, firstWeekday);
      return DateTime(s.year, s.month, s.day + 7 * offset);
    }(),
    Span.month => DateTime(today.year, today.month + offset),
  };

  DateTime end(DateTime today, int firstWeekday) {
    final s = start(today, firstWeekday);
    return switch (span) {
      Span.week => DateTime(s.year, s.month, s.day + 6),
      Span.month => endOfMonth(s),
    };
  }

  /// Progress counts the whole week, as a goal, but a month only up to today.
  PeriodProgress progress(
    FamilyStore store,
    Iterable<Habit> habits,
    int firstWeekday,
  ) {
    final from = start(store.today, firstWeekday);
    var to = end(store.today, firstWeekday);
    if (span == Span.month && to.isAfter(store.today)) to = store.today;
    return periodProgress(habits, store.checkIns, from, to);
  }
}

/// Week or month, with arrows to look back.
class PeriodPicker extends StatelessWidget {
  const PeriodPicker({
    super.key,
    required this.period,
    required this.firstWeekday,
    required this.today,
    required this.onChanged,
    this.showSpan = true,
  });

  final Period period;
  final bool showSpan;
  final int firstWeekday;
  final DateTime today;
  final ValueChanged<Period> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final look = Look.of(context);
    final locale = Localizations.localeOf(context).toString();
    final start = period.start(today, firstWeekday);
    final end = period.end(today, firstWeekday);
    final label = switch (period.span) {
      Span.week when period.offset == 0 => l10n.thisWeek,
      Span.week =>
        '${DateFormat.MMMd(locale).format(start)} – ${DateFormat.MMMd(locale).format(end)}',
      Span.month when period.offset == 0 => l10n.thisMonth,
      Span.month => DateFormat.yMMMM(locale).format(start),
    };
    return Column(
      children: [
        if (showSpan) ...[
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<Span>(
              key: const Key('periodSpan'),
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: Span.week, label: Text(l10n.weekTab)),
                ButtonSegment(value: Span.month, label: Text(l10n.monthTab)),
              ],
              selected: {period.span},
              onSelectionChanged: (s) => onChanged(Period(s.first)),
            ),
          ),
          const SizedBox(height: 6),
        ],
        Row(
          children: [
            IconButton(
              key: const Key('previousPeriod'),
              tooltip: l10n.previous,
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed: period.offset > period.oldest
                  ? () => onChanged(period.moved(-1))
                  : null,
            ),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: look.ink,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            IconButton(
              key: const Key('nextPeriod'),
              tooltip: l10n.next,
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: period.offset < 0
                  ? () => onChanged(period.moved(1))
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}

/// A big percentage ring with "x of y check-ins".
class ProgressSummaryCard extends StatelessWidget {
  const ProgressSummaryCard({
    super.key,
    required this.title,
    required this.progress,
  });

  final String title;
  final PeriodProgress progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final look = Look.of(context);
    final percent = (progress.fraction * 100).round();
    return Container(
      decoration: BoxDecoration(
        gradient: look.hero,
        borderRadius: BorderRadius.circular(look.radius + 4),
        border: look.borderWidth > 0
            ? Border.all(color: look.border, width: look.borderWidth)
            : null,
        boxShadow: look.shadows,
      ),
      padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: look.heading(22, color: look.heroInk)),
                const SizedBox(height: 4),
                Text(
                  l10n.checkInsProgress(progress.done, progress.target),
                  style: TextStyle(
                    color: look.heroInk.withValues(alpha: 0.85),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: progress.fraction,
                    strokeWidth: 8,
                    strokeCap: StrokeCap.round,
                    color: look.heroInk,
                    backgroundColor: look.heroInk.withValues(alpha: 0.25),
                  ),
                ),
                Text('$percent%', style: look.heading(19, color: look.heroInk)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One bar per day of the week, as tall as the share of planned habits done.
class WeekBars extends StatelessWidget {
  const WeekBars({
    super.key,
    required this.store,
    required this.habits,
    required this.weekStart,
  });

  final FamilyStore store;
  final List<Habit> habits;
  final DateTime weekStart;

  @override
  Widget build(BuildContext context) {
    final look = Look.of(context);
    final days = [
      for (var i = 0; i < 7; i++)
        DateTime(weekStart.year, weekStart.month, weekStart.day + i),
    ];
    return SoftCard(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
      child: Row(
        children: [
          for (final day in days)
            Expanded(
              child: _DayBar(
                label: weekdayName(context, day.weekday),
                progress: periodProgress(habits, store.checkIns, day, day),
                future: day.isAfter(store.today),
                today: day == store.today,
                look: look,
              ),
            ),
        ],
      ),
    );
  }
}

class _DayBar extends StatelessWidget {
  const _DayBar({
    required this.label,
    required this.progress,
    required this.future,
    required this.today,
    required this.look,
  });

  final String label;
  final PeriodProgress progress;
  final bool future;
  final bool today;
  final Look look;

  @override
  Widget build(BuildContext context) {
    const height = 96.0;
    final fill = future ? 0.0 : progress.fraction;
    return Column(
      children: [
        Text(
          progress.target == 0 || future ? '' : '${progress.done}',
          style: TextStyle(color: look.muted, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Container(
          width: 22,
          height: height,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: look.muted.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(99),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 22,
            height: math.max(fill * height, fill > 0 ? 22 : 0),
            decoration: BoxDecoration(
              color: fill >= 1 ? look.done : look.primary,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: TextStyle(
            color: today ? look.primary : look.muted,
            fontWeight: today ? FontWeight.w700 : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

/// The month as a calendar, each day colored by how much was done.
class MonthCalendar extends StatelessWidget {
  const MonthCalendar({
    super.key,
    required this.store,
    required this.habits,
    required this.month,
    required this.firstWeekday,
  });

  final FamilyStore store;
  final List<Habit> habits;
  final DateTime month;
  final int firstWeekday;

  @override
  Widget build(BuildContext context) {
    final look = Look.of(context);
    final first = startOfMonth(month);
    final last = endOfMonth(month);
    final lead = (first.weekday - firstWeekday) % 7;
    final cells = <DateTime?>[
      for (var i = 0; i < lead; i++) null,
      for (var d = 1; d <= last.day; d++) DateTime(month.year, month.month, d),
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }
    return SoftCard(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
      child: Column(
        children: [
          Row(
            children: [
              for (final d in weekdaysFrom(firstWeekday))
                Expanded(
                  child: Text(
                    weekdayName(context, d),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(color: look.muted, fontSize: 11),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          for (var row = 0; row < cells.length ~/ 7; row++)
            Row(
              children: [
                for (final day in cells.sublist(row * 7, row * 7 + 7))
                  Expanded(
                    child: day == null
                        ? const SizedBox(height: 40)
                        : _DayCell(
                            day: day,
                            progress: periodProgress(
                              habits,
                              store.checkIns,
                              day,
                              day,
                            ),
                            future: day.isAfter(store.today),
                            today: day == store.today,
                            look: look,
                          ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.progress,
    required this.future,
    required this.today,
    required this.look,
  });

  final DateTime day;
  final PeriodProgress progress;
  final bool future;
  final bool today;
  final Look look;

  @override
  Widget build(BuildContext context) {
    final planned = progress.target > 0 && !future;
    final full = planned && progress.done >= progress.target;
    final color = !planned
        ? Colors.transparent
        : full
        ? look.done
        : look.done.withValues(alpha: 0.12 + 0.45 * progress.fraction);
    return Container(
      height: 36,
      margin: const EdgeInsets.all(2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: today ? Border.all(color: look.primary, width: 2) : null,
      ),
      child: Text(
        '${day.day}',
        style: TextStyle(
          fontSize: 13,
          fontWeight: today ? FontWeight.w700 : FontWeight.w500,
          color: full
              ? Colors.white
              : future
              ? look.muted.withValues(alpha: 0.6)
              : look.ink,
        ),
      ),
    );
  }
}

/// A habit or a person, with a bar and "3/5".
class ProgressRow extends StatelessWidget {
  const ProgressRow({
    super.key,
    required this.leading,
    required this.label,
    required this.progress,
    this.color,
  });

  final Widget leading;
  final String label;
  final PeriodProgress progress;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final look = Look.of(context);
    final full = progress.target > 0 && progress.done >= progress.target;
    return SoftCard(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 14, 10),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: look.ink,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: progress.fraction,
                    minHeight: 8,
                    color: full ? look.done : color ?? look.primary,
                    backgroundColor: look.muted.withValues(alpha: 0.14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${progress.done}/${progress.target}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: full ? look.done : look.ink,
            ),
          ),
        ],
      ),
    );
  }
}

/// The active person's own habits over a week or a month.
class MyProgressScreen extends StatefulWidget {
  const MyProgressScreen({super.key, required this.store});

  final FamilyStore store;

  @override
  State<MyProgressScreen> createState() => _MyProgressScreenState();
}

class _MyProgressScreenState extends State<MyProgressScreen> {
  Period _period = const Period(Span.week);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final look = Look.of(context);
    final store = widget.store;
    final me = store.activeMember;
    if (me == null) return Center(child: Text(l10n.noHabitsYet));
    final firstWeekday = store.weekStartFor(Localizations.localeOf(context));
    final habits = store.habitsOf(me.id);
    final start = _period.start(store.today, firstWeekday);
    final isWeek = _period.span == Span.week;

    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 32),
      children: [
        ProfileSwitcher(store: store),
        const SizedBox(height: 12),
        PeriodPicker(
          period: _period,
          firstWeekday: firstWeekday,
          today: store.today,
          onChanged: (p) => setState(() => _period = p),
        ),
        const SizedBox(height: 8),
        ProgressSummaryCard(
          title: isWeek ? l10n.myWeek : l10n.myMonth,
          progress: _period.progress(store, habits, firstWeekday),
        ),
        const SizedBox(height: 8),
        if (isWeek)
          WeekBars(store: store, habits: habits, weekStart: start)
        else
          MonthCalendar(
            store: store,
            habits: habits,
            month: start,
            firstWeekday: firstWeekday,
          ),
        if (habits.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                l10n.noHabitsYet,
                style: TextStyle(color: look.muted),
              ),
            ),
          )
        else ...[
          SectionTitle(l10n.byHabit),
          for (final habit in habits)
            ProgressRow(
              leading: HabitBubble(
                habit: habit,
                look: categoryLook(l10n, store, habit.category),
                size: 36,
              ),
              label: habit.name,
              progress: _period.progress(store, [habit], firstWeekday),
            ),
        ],
      ],
    );
  }
}

/// Everyone's habits together over a week or a month, and who did what.
class FamilyProgressSection extends StatefulWidget {
  const FamilyProgressSection({super.key, required this.store});

  final FamilyStore store;

  @override
  State<FamilyProgressSection> createState() => _FamilyProgressSectionState();
}

class _FamilyProgressSectionState extends State<FamilyProgressSection> {
  Period _period = const Period(Span.week);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final look = Look.of(context);
    final store = widget.store;
    final firstWeekday = store.weekStartFor(Localizations.localeOf(context));
    final start = _period.start(store.today, firstWeekday);
    final isWeek = _period.span == Span.week;
    final habits = store.habits;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PeriodPicker(
          period: _period,
          firstWeekday: firstWeekday,
          today: store.today,
          onChanged: (p) => setState(() => _period = p),
        ),
        const SizedBox(height: 8),
        if (isWeek)
          FamilyProgressCard(store: store, weekStart: start)
        else
          ProgressSummaryCard(
            title: l10n.familyMonth,
            progress: _period.progress(store, habits, firstWeekday),
          ),
        const SizedBox(height: 8),
        if (isWeek)
          WeekBars(store: store, habits: habits, weekStart: start)
        else ...[
          MonthCalendar(
            store: store,
            habits: habits,
            month: start,
            firstWeekday: firstWeekday,
          ),
          SectionTitle(l10n.byPerson),
          if (store.familyHabits.isNotEmpty)
            ProgressRow(
              leading: IconBubble(
                icon: Icons.groups_rounded,
                color: look.familyColor,
                size: 36,
              ),
              label: l10n.familyHabits,
              color: look.familyColor,
              progress: _period.progress(
                store,
                store.familyHabits,
                firstWeekday,
              ),
            ),
          for (final m in store.sortedMembers)
            if (store.habitsOf(m.id).isNotEmpty)
              ProgressRow(
                leading: MemberAvatar(
                  name: m.nickname,
                  color: memberColor(context, store, m.id),
                  size: 36,
                ),
                label: m.nickname,
                color: memberColor(context, store, m.id),
                progress: _period.progress(
                  store,
                  store.habitsOf(m.id),
                  firstWeekday,
                ),
              ),
        ],
      ],
    );
  }
}
