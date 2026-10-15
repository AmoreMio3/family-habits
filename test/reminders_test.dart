import 'package:family_habits/app.dart';
import 'package:family_habits/data/in_memory_accounts.dart';
import 'package:family_habits/data/reminders.dart';
import 'package:family_habits/data/sample_family.dart';
import 'package:family_habits/l10n/app_localizations.dart';
import 'package:family_habits/ui/home_screen.dart';
import 'package:family_habits/ui/reminders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeScheduler implements ReminderScheduler {
  bool allow = true;
  final scheduled = <int, (TimeOfDay, String)>{};

  @override
  Future<bool> requestPermission() async => allow;

  @override
  Future<void> scheduleDaily({
    required int id,
    required TimeOfDay time,
    required String title,
    required String body,
  }) async => scheduled[id] = (time, body);

  @override
  Future<void> cancelAll() async => scheduled.clear();
}

const texts = ReminderTexts(title: 'T', morning: 'Morning', evening: 'Evening');

void main() {
  late FakeScheduler scheduler;
  late ReminderSettings reminders;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    scheduler = FakeScheduler();
    reminders = ReminderSettings(scheduler: scheduler);
  });

  test('off by default, 8:00 and 20:00 when turned on', () async {
    expect(reminders.plan, ReminderPlan.off);
    await reminders.update(texts, plan: ReminderPlan.twice);
    expect(scheduler.scheduled.values.toList(), [
      (const TimeOfDay(hour: 8, minute: 0), 'Morning'),
      (const TimeOfDay(hour: 20, minute: 0), 'Evening'),
    ]);
    await reminders.update(texts, plan: ReminderPlan.evening);
    expect(scheduler.scheduled.values.single.$2, 'Evening');
    await reminders.update(texts, plan: ReminderPlan.off);
    expect(scheduler.scheduled, isEmpty);
  });

  test('a custom time is kept and saved on the phone', () async {
    await reminders.update(
      texts,
      plan: ReminderPlan.morning,
      morning: const TimeOfDay(hour: 6, minute: 45),
    );
    expect(scheduler.scheduled.values.single.$1.hour, 6);

    final again = ReminderSettings(scheduler: FakeScheduler());
    await again.load();
    expect(again.plan, ReminderPlan.morning);
    expect(again.morning, const TimeOfDay(hour: 6, minute: 45));
    expect(again.evening, ReminderSettings.defaultEvening);
  });

  test('stays off when the phone blocks notifications', () async {
    scheduler.allow = false;
    expect(await reminders.update(texts, plan: ReminderPlan.twice), isFalse);
    expect(reminders.plan, ReminderPlan.off);
    expect(scheduler.scheduled, isEmpty);
  });

  testWidgets('set a reminder from the add-habit screen', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final store = sampleFamily();
    addTearDown(store.dispose);
    final settings = AppSettings(reminders: reminders);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) =>
            RemindersScope(reminders: settings.reminders, child: child!),
        home: HomeScreen(
          store: store,
          settings: settings,
          accounts: InMemoryAccountService(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add habit'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('createOwnHabit')));
    await tester.pumpAndSettle();
    expect(find.text('No reminder'), findsOneWidget);

    await tester.tap(find.byKey(const Key('habitReminders')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Twice a day'));
    await tester.pumpAndSettle();
    expect(find.text('Morning reminder'), findsOneWidget);
    expect(find.text('Evening reminder'), findsOneWidget);
    expect(scheduler.scheduled.values.map((e) => e.$2), [
      'Good morning! Your habits for today are waiting.',
      'How did today go? Check off your habits.',
    ]);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Every day at 8:00 AM and 8:00 PM'), findsOneWidget);
  });

  testWidgets('a blocked phone shows how to turn notifications on', (
    tester,
  ) async {
    scheduler.allow = false;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) =>
            RemindersScope(reminders: reminders, child: child!),
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const RemindersScreen()),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Every morning'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Notifications are off'), findsOneWidget);
    expect(reminders.plan, ReminderPlan.off);
  });
}
