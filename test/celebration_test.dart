import 'package:family_habits/models/category.dart';
import 'package:family_habits/models/family.dart';
import 'package:family_habits/ui/celebration.dart';
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
}
