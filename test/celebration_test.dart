import 'package:family_habits/models/category.dart';
import 'package:family_habits/models/family.dart';
import 'package:family_habits/models/habit_library.dart';
import 'package:family_habits/ui/celebration.dart';
import 'package:family_habits/ui/habit_scenes.dart';
import 'package:flutter_test/flutter_test.dart';

Habit habit(
  String name,
  BuiltInCategory category, {
  String? templateId,
  bool family = false,
}) => Habit(
  id: name,
  name: name,
  owner: family ? const FamilyOwner() : const PersonalOwner('dad'),
  category: BuiltInRef(category),
  templateId: templateId,
);

void main() {
  test('each habit gets the animation that matches it', () {
    expect(
      celebrationFor(habit('Drink enough water', BuiltInCategory.health)),
      Celebration.water,
    );
    expect(
      celebrationFor(habit('לשתות מים', BuiltInCategory.nutrition)),
      Celebration.water,
    );
    // A renamed habit still matches through its template.
    expect(
      celebrationFor(
        habit('8 cups', BuiltInCategory.health, templateId: 'HEALTH_001'),
      ),
      Celebration.water,
    );
    expect(
      celebrationFor(habit('Water the plants', BuiltInCategory.homeTasks)),
      isNot(Celebration.water),
    );
    expect(
      celebrationFor(habit('Go to bed on time', BuiltInCategory.sleep)),
      Celebration.sleep,
    );
    expect(
      celebrationFor(habit('Read', BuiltInCategory.study)),
      Celebration.reading,
    );
    expect(
      celebrationFor(habit('Run', BuiltInCategory.sport)),
      Celebration.sport,
    );
    expect(
      celebrationFor(
        habit(
          'Have a phone-free meal',
          BuiltInCategory.familyMeals,
          family: true,
        ),
      ),
      Celebration.familyMeals,
    );
    expect(
      celebrationFor(habit('Brush teeth', BuiltInCategory.selfCare)),
      Celebration.selfCare,
    );
  });

  test('every built-in category has its own animation', () {
    final kinds = {
      for (final c in BuiltInCategory.values)
        celebrationFor(habit('Something', c)),
    };
    expect(kinds, hasLength(BuiltInCategory.values.length));
    expect(kinds, isNot(contains(Celebration.confetti)));
  });

  test("the family's own categories are matched by their words", () {
    Habit custom(String name, {bool family = false}) => Habit(
      id: name,
      name: name,
      owner: family ? const FamilyOwner() : const PersonalOwner('dad'),
      category: const CustomRef('music'),
    );
    expect(celebrationFor(custom('Nap after school')), Celebration.sleep);
    expect(
      celebrationFor(custom('Board games', family: true)),
      Celebration.familyTime,
    );
    expect(celebrationFor(custom('Practice violin')), Celebration.confetti);
  });

  test('every library habit has its own picture, except water', () {
    for (final t in habitTemplates) {
      expect(habitScenes.containsKey(t.id), t.id != 'HEALTH_001', reason: t.id);
    }
    expect(
      habitScenes.keys.toSet(),
      habitTemplates.map((t) => t.id).toSet()..remove('HEALTH_001'),
    );
  });

  test('habits people quit are crossed out', () {
    for (final t in habitTemplates) {
      if (t.category == BuiltInCategory.breakHabit) {
        expect(habitScenes[t.id]!.motion, Motion.ban, reason: t.id);
      }
    }
    expect(
      sceneFor(
        habit(
          'No smoking',
          BuiltInCategory.breakHabit,
          templateId: 'BREAK_003',
        ),
      ),
      const Scene('🚬', Motion.ban, '💨'),
    );
  });

  test("the family's own habits get a picture from their words", () {
    Habit custom(String name) => Habit(
      id: name,
      name: name,
      owner: const PersonalOwner('dad'),
      category: const CustomRef('music'),
    );
    expect(sceneFor(custom('Practice violin'))!.emoji, '🎻');
    final picked = Habit(
      id: 'p',
      name: 'Practice violin',
      owner: const FamilyOwner(),
      category: const BuiltInRef(BuiltInCategory.breakHabit),
      emoji: '🦄',
    );
    expect(sceneFor(picked)!.emoji, '🦄');
    expect(sceneFor(picked)!.motion, Motion.ban);
    expect(sceneFor(custom('לנגן בפסנתר'))!.emoji, '🎹');
    expect(sceneFor(custom('Stop smoking'))!.motion, Motion.ban);
    // "No" in front of a habit crosses its picture out.
    expect(sceneFor(custom('No chocolate after dinner'))!.motion, Motion.ban);
    expect(sceneFor(custom('בלי ממתקים'))!.motion, Motion.ban);
    expect(sceneFor(custom('Walk the dog'))!.motion, isNot(Motion.ban));
    // "bread" is not reading, and "team" is not tea.
    expect(sceneFor(custom('Bake bread'))!.emoji, '🧑‍🍳');
    expect(sceneFor(custom('Something new')), isNull);
  });
}
