import 'package:family_habits/logic/progress.dart';
import 'package:family_habits/models/category.dart';
import 'package:family_habits/models/family.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final weekStart = DateTime(2026, 9, 27);
  DateTime day(int offset) => DateTime(2026, 9, 27 + offset);

  const dinner = Habit(
    id: 'dinner',
    name: 'Family dinner',
    owner: FamilyOwner(),
    category: BuiltInCategory.familyTable,
    timesPerWeek: 4,
  );
  const read = Habit(
    id: 'read',
    name: 'Read',
    owner: PersonalOwner('noa'),
    category: BuiltInCategory.study,
    timesPerWeek: 2,
  );

  CheckIn c(String habit, int offset) =>
      CheckIn(habitId: habit, day: day(offset), checkedInBy: 'mom');

  test('same-day check-ins count once', () {
    expect(
      doneThisWeek(dinner, [c('dinner', 0), c('dinner', 0)], weekStart),
      1,
    );
  });

  test('check-ins outside the week are ignored', () {
    expect(
      doneThisWeek(dinner, [
        c('dinner', -1),
        c('dinner', 7),
        c('dinner', 3),
      ], weekStart),
      1,
    );
  });

  test('weekly goal is met at the target', () {
    final four = [for (var i = 0; i < 4; i++) c('dinner', i)];
    expect(weeklyGoalMet(dinner, four.take(3), weekStart), isFalse);
    expect(weeklyGoalMet(dinner, four, weekStart), isTrue);
  });

  test('family bar caps each habit at its target and splits by owner', () {
    final checkIns = [
      for (var i = 0; i < 5; i++) c('read', i), // 5 done, target 2
      c('dinner', 1),
    ];
    final p = familyProgress([dinner, read], checkIns, weekStart);
    expect(p.target, 6);
    expect(p.done, 3);
    expect(p.byOwner, {'noa': 2, familyKey: 1});
    expect(p.fraction, closeTo(0.5, 1e-9));
  });

  test('one parent check-in counts the family habit for everyone', () {
    final p = familyProgress([dinner], [c('dinner', 2)], weekStart);
    expect(p.byOwner[familyKey], 1);
  });

  group('streak', () {
    test('counts back from today', () {
      expect(
        streak(read, [c('read', 3), c('read', 2), c('read', 1)], day(3)),
        3,
      );
    });

    test('an open today keeps yesterday\'s streak', () {
      expect(streak(read, [c('read', 1), c('read', 2)], day(3)), 2);
    });

    test('a gap ends the streak', () {
      expect(streak(read, [c('read', 3), c('read', 1)], day(3)), 1);
    });
  });
}
