import 'package:family_habits/app.dart';
import 'package:family_habits/data/in_memory_accounts.dart';
import 'package:family_habits/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InMemoryAccountService accounts;
  late AppSettings settings;

  setUp(() {
    accounts = InMemoryAccountService();
    settings = AppSettings(locale: const Locale('en'));
  });

  Future<void> start(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      FamilyHabitsApp(accounts: accounts, settings: settings),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openDemo(WidgetTester tester) async {
    await start(tester);
    await tester.tap(find.text('Try the demo family'));
    await tester.pumpAndSettle();
  }

  Future<void> enter(WidgetTester tester, String key, String text) async {
    await tester.enterText(find.byKey(Key(key)), text);
    await tester.pump();
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text).last);
    await tester.tap(find.text(text).last);
    await tester.pumpAndSettle();
  }

  testWidgets('every supported locale renders the welcome and home screens', (
    tester,
  ) async {
    await start(tester);
    for (final locale in AppLocalizations.supportedLocales) {
      settings.locale = locale;
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '$locale');
    }
    settings.locale = const Locale('en');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Try the demo family'));
    await tester.pumpAndSettle();
    for (final locale in AppLocalizations.supportedLocales) {
      settings.locale = locale;
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '$locale');
      for (final tab in [1, 2, 0]) {
        await tester.tap(find.byType(NavigationDestination).at(tab));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$locale tab $tab');
      }
    }
  });

  testWidgets('Hebrew and Arabic lay out right to left', (tester) async {
    await openDemo(tester);
    for (final code in ['he', 'ar']) {
      settings.locale = Locale(code);
      await tester.pumpAndSettle();
      expect(
        Directionality.of(tester.element(find.byType(Scaffold).first)),
        TextDirection.rtl,
        reason: code,
      );
    }
    settings.locale = const Locale('en');
    await tester.pumpAndSettle();
    expect(
      Directionality.of(tester.element(find.byType(Scaffold).first)),
      TextDirection.ltr,
    );
  });

  testWidgets(
    'a parent checks in a family habit for everyone; a child cannot',
    (tester) async {
      await openDemo(tester);
      final dinner = find.widgetWithText(
        CheckboxListTile,
        'Have a phone-free meal',
      );
      await tester.tap(dinner);
      await tester.pumpAndSettle();
      expect(tester.widget<CheckboxListTile>(dinner).value, isTrue);
      expect(
        find.text(
          'Dad checked in “Have a phone-free meal” for the whole family',
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('Noa · Child'));
      await tester.pumpAndSettle();
      expect(tester.widget<CheckboxListTile>(dinner).onChanged, isNull);
      expect(find.text('Add habit'), findsNothing);
    },
  );

  testWidgets('sign up, create a family, add a child and pair their device', (
    tester,
  ) async {
    await start(tester);
    await tapText(tester, "I'm a parent");
    await enter(tester, 'email', 'gilad@example.com');
    await enter(tester, 'password', 'secret1');
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Set up your family'), findsOneWidget);
    await enter(tester, 'familyName', 'The Levis');
    await enter(tester, 'nickname', 'Abba');
    await tapText(tester, 'Continue');
    expect(find.text('The Levis'), findsOneWidget);

    // Add a child: saving waits for consent.
    await tapText(tester, 'Family');
    await tapText(tester, 'Add a child');
    await enter(tester, 'memberNickname', 'Maya');
    final save = find.widgetWithText(TextButton, 'Save');
    expect(tester.widget<TextButton>(save).onPressed, isNull);
    await tester.tap(find.byKey(const Key('consent')));
    await tester.pumpAndSettle();
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(find.text('Maya'), findsOneWidget);

    // Give Maya a habit.
    await tapText(tester, 'Today');
    await tapText(tester, 'Add habit');
    await tester.tap(find.byKey(const Key('createOwnHabit')));
    await tester.pumpAndSettle();
    await enter(tester, 'habitName', 'Read 15 minutes');
    await tester.tap(find.byKey(const Key('habitOwner')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Maya').last);
    await tester.pumpAndSettle();
    await tapText(tester, 'Save');

    // Make a code for Maya's tablet.
    await tapText(tester, 'Family');
    await tapText(tester, 'Maya');
    await tapText(tester, 'Connect a device');
    final code = tester
        .widget<SelectableText>(find.byKey(const Key('pairingCode')))
        .data!;
    await tapText(tester, 'Continue');
    await tester.tap(find.byType(CloseButton));
    await tester.pumpAndSettle();
    await tapText(tester, 'Sign out');

    // The tablet joins with the code and only sees Maya.
    await tapText(tester, 'Join with a code');
    await enter(tester, 'code', code.toLowerCase());
    await tapText(tester, 'Join');
    expect(find.text('Maya · Child'), findsOneWidget);
    expect(find.text('Abba · Parent'), findsNothing);
    expect(find.text('Read 15 minutes'), findsOneWidget);

    // A code works once.
    await tapText(tester, 'Family');
    await tapText(tester, 'Disconnect this device');
    await tapText(tester, 'Delete');
    await tapText(tester, 'Join with a code');
    await enter(tester, 'code', code);
    await tapText(tester, 'Join');
    expect(
      find.text(
        "This code doesn't exist. Check it with the parent who made it.",
      ),
      findsOneWidget,
    );
  });

  testWidgets('a wrong password shows a clear message', (tester) async {
    await accounts.signUp('gilad@example.com', 'secret1');
    await accounts.signOut();
    await start(tester);
    await tapText(tester, "I'm a parent");
    await tapText(tester, 'I already have an account');
    await enter(tester, 'email', 'gilad@example.com');
    await enter(tester, 'password', 'wrong!!');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('The email or password is wrong.'), findsOneWidget);
  });

  testWidgets('a shared device asks for a PIN to open another profile', (
    tester,
  ) async {
    await openDemo(tester);
    // Give Itai a PIN.
    await tapText(tester, 'Family');
    await tapText(tester, 'Itai');
    await tapText(tester, 'Set a PIN');
    await enter(tester, 'pin', '4321');
    await tester.pumpAndSettle();
    await tapText(tester, 'Save');

    await tapText(tester, 'Connect a shared family device');
    final code = tester
        .widget<SelectableText>(find.byKey(const Key('pairingCode')))
        .data!;
    await tapText(tester, 'Continue');
    await tapText(tester, 'Sign out');
    await tapText(tester, 'Join with a code');
    await enter(tester, 'code', code);
    await tapText(tester, 'Join');

    expect(find.text('Itai · Child'), findsOneWidget);
    expect(find.text('Dad · Parent'), findsNothing);
    await tester.tap(find.text('Noa · Child'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Itai · Child'));
    await tester.pumpAndSettle();
    await enter(tester, 'pin', '1111');
    await tester.pumpAndSettle();
    expect(find.text('Wrong PIN'), findsOneWidget);
    await enter(tester, 'pin', '4321');
    await tester.pumpAndSettle();
    expect(find.text('Make the bed'), findsOneWidget);
  });
}
