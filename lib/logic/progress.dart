import '../models/family.dart';
import 'week.dart';

/// Check-ins for [habit] in the week starting at [weekStart]. Several
/// check-ins on the same day count once.
int doneThisWeek(Habit habit, Iterable<CheckIn> checkIns, DateTime weekStart) {
  return checkIns
      .where((c) => c.habitId == habit.id && isInWeek(c.day, weekStart))
      .map((c) => dateOnly(c.day))
      .toSet()
      .length;
}

bool weeklyGoalMet(
  Habit habit,
  Iterable<CheckIn> checkIns,
  DateTime weekStart,
) => doneThisWeek(habit, checkIns, weekStart) >= habit.timesPerWeek;

/// Key used in [FamilyProgress.byOwner] for family habits.
const familyKey = 'family';

class FamilyProgress {
  const FamilyProgress({
    required this.done,
    required this.target,
    required this.byOwner,
  });

  final int done;
  final int target;

  /// Done check-ins per member id, plus [familyKey] for family habits.
  final Map<String, int> byOwner;

  double get fraction => target == 0 ? 0 : done / target;
}

/// The family bar: every member's habits plus the family habits, each
/// capped at its weekly target so one habit cannot overfill the bar.
FamilyProgress familyProgress(
  Iterable<Habit> habits,
  Iterable<CheckIn> checkIns,
  DateTime weekStart,
) {
  var done = 0;
  var target = 0;
  final byOwner = <String, int>{};
  for (final habit in habits) {
    final count = doneThisWeek(habit, checkIns, weekStart);
    final capped = count > habit.timesPerWeek ? habit.timesPerWeek : count;
    done += capped;
    target += habit.timesPerWeek;
    final key = switch (habit.owner) {
      PersonalOwner(:final memberId) => memberId,
      FamilyOwner() => familyKey,
    };
    byOwner[key] = (byOwner[key] ?? 0) + capped;
  }
  return FamilyProgress(done: done, target: target, byOwner: byOwner);
}

/// Consecutive days up to and including [today] with a check-in. A habit not
/// yet done today keeps yesterday's streak.
int streak(Habit habit, Iterable<CheckIn> checkIns, DateTime today) {
  final days = checkIns
      .where((c) => c.habitId == habit.id)
      .map((c) => dateOnly(c.day))
      .toSet();
  var day = dateOnly(today);
  if (!days.contains(day)) day = DateTime(day.year, day.month, day.day - 1);
  var count = 0;
  while (days.contains(day)) {
    count++;
    day = DateTime(day.year, day.month, day.day - 1);
  }
  return count;
}
