import 'package:family_habits/app.dart';
import 'package:family_habits/data/sample_family.dart';
import 'package:family_habits/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  DateTime clock() => DateTime(2026, 9, 30, 18);

  testWidgets('every supported locale renders the home screen', (tester) async {
    final store = sampleFamily(clock: clock);
    await tester.pumpWidget(FamilyHabitsApp(store: store));
    for (final locale in AppLocalizations.supportedLocales) {
      store.locale = locale;
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '$locale');
      final l10n = AppLocalizations.of(
        tester.element(find.byType(Scaffold).first),
      );
      expect(find.text(l10n.appTitle), findsWidgets, reason: '$locale');
    }
  });

  testWidgets('Hebrew and Arabic lay out right to left', (tester) async {
    final store = sampleFamily(clock: clock);
    await tester.pumpWidget(FamilyHabitsApp(store: store));
    for (final code in ['he', 'ar']) {
      store.locale = Locale(code);
      await tester.pumpAndSettle();
      final dir = Directionality.of(
        tester.element(find.byType(Scaffold).first),
      );
      expect(dir, TextDirection.rtl, reason: code);
    }
    store.locale = const Locale('en');
    await tester.pumpAndSettle();
    expect(
      Directionality.of(tester.element(find.byType(Scaffold).first)),
      TextDirection.ltr,
    );
  });

  testWidgets('a parent checks in a family habit for everyone', (tester) async {
    final store = sampleFamily(clock: clock);
    store.locale = const Locale('en');
    await tester.pumpWidget(FamilyHabitsApp(store: store));
    await tester.pumpAndSettle();

    // Noa is a child, so the family habit's checkbox is disabled.
    final dinner = find.widgetWithText(
      CheckboxListTile,
      'Family dinner, no phones',
    );
    expect(tester.widget<CheckboxListTile>(dinner).onChanged, isNull);

    await tester.tap(find.text('Mom · Parent'));
    await tester.pumpAndSettle();
    await tester.tap(dinner);
    await tester.pumpAndSettle();

    expect(tester.widget<CheckboxListTile>(dinner).value, isTrue);
    expect(
      find.text(
        'Mom checked in “Family dinner, no phones” for the whole family',
      ),
      findsOneWidget,
    );
    expect(
      store.checkIns.where(
        (c) => c.habitId == 'dinner' && c.checkedInBy == 'mom',
      ),
      hasLength(4),
    );
  });
}
