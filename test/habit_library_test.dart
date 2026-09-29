import 'dart:ui';

import 'package:family_habits/logic/habit_search.dart';
import 'package:family_habits/models/category.dart';
import 'package:family_habits/models/habit_library.dart';
import 'package:family_habits/models/habit_library_l10n.dart';
import 'package:flutter_test/flutter_test.dart';

List<String> search(String q, {String lang = 'en', bool forChild = false}) => [
  for (final r in searchHabits(
    q,
    locale: Locale(lang),
    categoryLabel: (c) => c.name,
    forChild: forChild,
    custom: const [
      CustomCategory(
        id: 'music',
        name: 'Music school',
        habits: ['Practice violin'],
      ),
    ],
  ))
    r.name,
];

void main() {
  group('library', () {
    test('categories come in the V1 order, grouped', () {
      expect(BuiltInCategory.values.map((c) => c.name), [
        'health', 'breakHabit', 'nutrition', 'sleep', 'sport', 'selfCare', //
        'mindfulness', 'familyTime', 'familyCare', 'familyMeals', //
        'homeTasks', 'study', 'work', 'finance', 'outdoor', 'art', 'hobbies',
      ]);
      expect(BuiltInCategory.familyCare.number, 9);
      expect(BuiltInCategory.familyCare.group, CategoryGroup.family);
    });

    test('old category ids still load', () {
      expect(
        BuiltInCategory.fromId('quitBadHabit'),
        BuiltInCategory.breakHabit,
      );
      expect(BuiltInCategory.fromId('meditate'), BuiltInCategory.mindfulness);
      expect(BuiltInCategory.fromId('entertainment'), BuiltInCategory.hobbies);
      expect(
        BuiltInCategory.fromId('familyTable'),
        BuiltInCategory.familyMeals,
      );
      expect(CategoryRef.parse('custom:abc'), const CustomRef('abc'));
    });

    test('every category has habits, ids are unique, names are short', () {
      final ids = habitTemplates.map((t) => t.id).toSet();
      expect(ids.length, habitTemplates.length);
      for (final c in BuiltInCategory.values) {
        expect(templatesIn(c), isNotEmpty, reason: c.name);
      }
      for (final t in habitTemplates) {
        // The spec asks for 2 to 6 words; two of its own names have 7.
        final words = t.name.split(' ').length;
        expect(words, inInclusiveRange(1, 7), reason: t.name);
        expect(t.name.toLowerCase(), isNot(contains('procrastinat')));
      }
    });

    test('water is one habit shown in Health and Nutrition', () {
      final water = habitTemplatesById['HEALTH_001']!;
      expect(water.name, 'Drink enough water');
      expect(templatesIn(BuiltInCategory.nutrition), contains(water));
    });

    test('names are translated, with English as the fallback', () {
      final water = habitTemplatesById['HEALTH_001']!;
      expect(habitTemplateName(water, const Locale('he')), isNot(water.name));
      expect(habitTemplateName(water, const Locale('en', 'GB')), water.name);
    });
  });

  group('search', () {
    test('finds habits from everyday words', () {
      expect(search('park'), containsAll(['Visit a park', 'Go for a walk']));
      expect(search('book'), contains('Read a bedtime story'));
      expect(search('diet').first, 'Eat mindfully');
      expect(search('book').first, 'Read a bedtime story');
      expect(search('hik').first, 'Go hiking');
      expect(search('smoking').first, 'No smoking or vaping');
    });

    test('every word must match', () {
      expect(search('read story'), ['Read a bedtime story']);
      expect(search('zzzz'), isEmpty);
    });

    test('includes the family categories', () {
      expect(search('violin').first, 'Practice violin');
    });

    test('leaves out parent-only habits for a child', () {
      expect(search('homework'), contains('Help my child with homework'));
      expect(
        search('homework', forChild: true),
        isNot(contains('Help my child with homework')),
      );
      expect(search('homework', forChild: true), contains('Do homework'));
    });

    test('works in Hebrew, including a leading prefix letter', () {
      final park = search('פארק', lang: 'he');
      expect(park, isNotEmpty);
      expect(search('הפארק', lang: 'he'), park);
      // "ספר" is "book"; it shouldn't bring up school habits first.
      expect(search('ספר', lang: 'he').first, isNot(contains('בית')));
    });
  });
}
