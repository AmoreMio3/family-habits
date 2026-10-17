import 'package:family_habits/app.dart';
import 'package:family_habits/data/in_memory_accounts.dart';
import 'package:family_habits/l10n/app_localizations.dart';
import 'package:family_habits/ui/main_menu.dart';
import 'package:family_habits/ui/today_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A profile button on Today, found by the member's name.
Finder profileButton(String name) => find.ancestor(
  of: find.text(name),
  matching: find.byWidgetPredicate(
    (w) =>
        w.key is ValueKey<String> &&
        (w.key! as ValueKey<String>).value.startsWith('profile-'),
  ),
);

/// The page's own vertical list, not the sideways menu at the top.
final mainList = find
    .byWidgetPredicate(
      (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
    )
    .last;

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

  Future<void> openSettings(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('settingsButton')));
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    final target = find.text(text).last;
    // Centred, so it isn't left under the bottom bar.
    if (Scrollable.maybeOf(tester.element(target)) != null) {
      await Scrollable.ensureVisible(tester.element(target), alignment: 0.5);
      await tester.pumpAndSettle();
    }
    await tester.tap(target);
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
      for (final tab in [1, 2, 3, 4, 0]) {
        await tester.tap(find.byKey(Key('menu-$tab')));
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
      final dinner = find.descendant(
        of: find.widgetWithText(HabitCard, 'Have a phone-free meal'),
        matching: find.byType(CheckCircle),
      );
      await tester.tap(dinner);
      await tester.pump(const Duration(milliseconds: 300));
      // The check-off animation shows the habit's name, then goes away.
      expect(find.text('Have a phone-free meal'), findsNWidgets(2));
      await tester.pumpAndSettle();
      expect(find.text('Have a phone-free meal'), findsOneWidget);
      expect(tester.widget<CheckCircle>(dinner).done, isTrue);
      expect(
        find.text(
          'Dad checked in “Have a phone-free meal” for the whole family',
        ),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('profile-noa')));
      await tester.pumpAndSettle();
      expect(tester.widget<CheckCircle>(dinner).enabled, isFalse);
      expect(find.text('Add habit'), findsNothing);
      expect(find.text('Add a habit for Noa'), findsOneWidget);
    },
  );

  testWidgets('a parent opens a child\'s day and adds a habit for them only', (
    tester,
  ) async {
    await openDemo(tester);
    expect(find.byKey(const Key('childDayHint')), findsNothing);

    await tester.tap(find.byKey(const Key('profile-noa')));
    await tester.pumpAndSettle();
    expect(
      find.text(
        "You're looking at Noa's day. Habits you add here are for Noa only.",
      ),
      findsOneWidget,
    );

    await tapText(tester, 'Add a habit for Noa');
    await enter(tester, 'habitSearch', 'Feed the fish');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('createFromSearch')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final fish = find.widgetWithText(HabitCard, 'Feed the fish');
    await tester.scrollUntilVisible(fish, 300, scrollable: mainList);
    expect(fish, findsOneWidget);

    final dad = find.byKey(const Key('profile-dad'));
    await tester.scrollUntilVisible(dad, -300, scrollable: mainList);
    await tester.tap(dad);
    await tester.pumpAndSettle();
    expect(find.text('Feed the fish'), findsNothing);
  });

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
    await tapText(tester, 'My day');
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
    await openSettings(tester);
    await tapText(tester, 'Sign out');

    // The tablet joins with the code and only sees Maya.
    await tapText(tester, 'Join with a code');
    await enter(tester, 'code', code.toLowerCase());
    await tapText(tester, 'Join');
    expect(profileButton('Maya'), findsOneWidget);
    expect(profileButton('Abba'), findsNothing);
    expect(find.text('Read 15 minutes'), findsOneWidget);

    // A code works once.
    await tapText(tester, 'Family');
    await openSettings(tester);
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
    await openSettings(tester);
    await tapText(tester, 'Sign out');
    await tapText(tester, 'Join with a code');
    await enter(tester, 'code', code);
    await tapText(tester, 'Join');

    expect(find.byKey(const Key('profile-itai')), findsOneWidget);
    expect(find.byKey(const Key('profile-dad')), findsNothing);
    await tester.tap(find.byKey(const Key('profile-noa')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('profile-itai')));
    await tester.pumpAndSettle();
    await enter(tester, 'pin', '1111');
    await tester.pumpAndSettle();
    expect(find.text('Wrong PIN'), findsOneWidget);
    await enter(tester, 'pin', '4321');
    await tester.pumpAndSettle();
    expect(find.text('Make the bed'), findsOneWidget);
  });

  testWidgets('the five tabs and the settings gear', (tester) async {
    await openDemo(tester);
    final labels = [
      'My day',
      'My habits',
      'My progress',
      'Family',
      'Habit ideas',
    ];
    for (var i = 0; i < labels.length; i++) {
      expect(
        find.descendant(
          of: find.byKey(Key('menu-$i')),
          matching: find.text(labels[i]),
        ),
        findsOneWidget,
        reason: labels[i],
      );
    }
    Future<void> tapMenu(int i) async {
      await tester.tap(find.byKey(Key('menu-$i')));
      await tester.pumpAndSettle();
    }

    // My habits: one line per habit with the week's days.
    await tapMenu(1);
    expect(find.text('This week'), findsOneWidget);
    expect(find.text('Run'), findsOneWidget);

    // My progress: week, then month, and back a month.
    await tapMenu(2);
    expect(find.text('My week'), findsOneWidget);
    await tapText(tester, 'Month');
    expect(find.text('My month'), findsOneWidget);
    expect(find.text('By habit'), findsOneWidget);
    await tester.tap(find.byKey(const Key('previousPeriod')));
    await tester.pumpAndSettle();
    expect(find.text('This month'), findsNothing);
    expect(
      tester
          .widget<IconButton>(find.byKey(const Key('previousPeriod')))
          .onPressed,
      isNull,
    );

    // Family: progress first, then the family's settings.
    await tapMenu(3);
    expect(find.text('Family progress'), findsOneWidget);
    expect(find.text('Family settings'), findsOneWidget);
    await tapText(tester, 'Month');
    expect(find.text('Family month'), findsOneWidget);
    expect(find.text('By person'), findsOneWidget);

    // The gear opens reminders, language and the account.
    await openSettings(tester);
    expect(find.text('Reminders'), findsOneWidget);
    await tapText(tester, 'Language');
    await tapText(tester, 'עברית');
    expect(find.text('הגדרות'), findsWidgets);
    expect(settings.locale, const Locale('he'));

    // The menu can move to the bottom of the screen.
    await tester.tap(find.text('למטה'));
    await tester.pumpAndSettle();
    expect(settings.menuPlace, MenuPlace.bottom);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(BottomMenu), findsOneWidget);
    expect(find.byType(TopMenu), findsNothing);
  });
}
