import 'package:family_habits/app.dart';
import 'package:family_habits/data/in_memory_accounts.dart';
import 'package:family_habits/data/sample_family.dart';
import 'package:family_habits/l10n/app_localizations.dart';
import 'package:family_habits/models/category.dart';
import 'package:family_habits/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<dynamic> pumpHome(WidgetTester tester, {Locale? locale}) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final store = sampleFamily();
    addTearDown(store.dispose);
    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: HomeScreen(
          store: store,
          settings: AppSettings(),
          accounts: InMemoryAccountService(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(locale == null ? 'Add habit' : 'הוספת הרגל'));
    await tester.pumpAndSettle();
    return store;
  }

  Future<void> save(WidgetTester tester) async {
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
  }

  testWidgets('search "park", pick a habit, and it shows on Today', (
    tester,
  ) async {
    final store = await pumpHome(tester);
    await tester.enterText(find.byKey(const Key('habitSearch')), 'park');
    await tester.pumpAndSettle();
    expect(find.text('Go for a walk'), findsOneWidget);

    await tester.tap(find.text('Visit a park'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('habitDefinition')),
      'At least 30 minutes outside',
    );
    await save(tester);

    expect(find.byKey(const Key('habitSearch')), findsNothing);
    final habit = store.habits.firstWhere((h) => h.name == 'Visit a park');
    expect(habit.templateId, 'OUTDOOR_003');
    expect(habit.category, const BuiltInRef(BuiltInCategory.outdoor));
    final row = find.textContaining('At least 30 minutes outside');
    await tester.scrollUntilVisible(row, 300);
    expect(row, findsOneWidget);
  });

  testWidgets('a search with no match offers to create it', (tester) async {
    final store = await pumpHome(tester);
    await tester.enterText(
      find.byKey(const Key('habitSearch')),
      'Feed the fish',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('createFromSearch')));
    await tester.pumpAndSettle();
    await save(tester);
    expect(store.habits.any((h) => h.name == 'Feed the fish'), isTrue);
  });

  testWidgets('categories come in order and end with "Create my own"', (
    tester,
  ) async {
    await pumpHome(tester);
    expect(find.text('Create my own habit'), findsOneWidget);
    expect(find.text('Create my own category'), findsOneWidget);
    final health = tester.getTopLeft(find.text('Health')).dy;
    final breakHabit = tester.getTopLeft(find.text('Break a habit')).dy;
    expect(health, lessThan(breakHabit));

    await tester.tap(find.text('Break a habit'));
    await tester.pumpAndSettle();
    expect(find.text('No sweets'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('createOwnInCategory')),
      300,
    );
    expect(find.byKey(const Key('createOwnInCategory')), findsOneWidget);
  });

  testWidgets('a parent creates a family category and adds a habit from it', (
    tester,
  ) async {
    final store = await pumpHome(tester);
    await tester.tap(find.byKey(const Key('createOwnCategory')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('categoryName')),
      'Music school',
    );
    await tester.enterText(
      find.byKey(const Key('categoryNewHabit')),
      'Practice violin',
    );
    await tester.tap(find.byKey(const Key('categoryAddHabit')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('saveCategory')));
    await tester.pumpAndSettle();

    // The new category opens with its habit.
    await tester.tap(find.text('Practice violin'));
    await tester.pumpAndSettle();
    await save(tester);
    final habit = store.habits.firstWhere((h) => h.name == 'Practice violin');
    expect(habit.category, isA<CustomRef>());
    final row = find.textContaining('Music school');
    await tester.scrollUntilVisible(row, 300);
    expect(row, findsOneWidget);
  });

  testWidgets('Hebrew shows translated habits and search', (tester) async {
    await pumpHome(tester, locale: const Locale('he'));
    await tester.enterText(find.byKey(const Key('habitSearch')), 'פארק');
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
