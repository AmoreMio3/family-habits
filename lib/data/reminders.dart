import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../l10n/app_localizations.dart';

/// When this phone reminds its user to check off their habits.
enum ReminderPlan { off, morning, evening, twice }

/// Notification texts in the app's language, passed in when reminders are
/// set because the notification is shown later, outside the app.
class ReminderTexts {
  const ReminderTexts({
    required this.title,
    required this.morning,
    required this.evening,
  });

  ReminderTexts.of(AppLocalizations l10n)
    : title = l10n.appTitle,
      morning = l10n.reminderMorningBody,
      evening = l10n.reminderEveningBody;

  final String title;
  final String morning;
  final String evening;
}

/// Shows daily notifications. Swapped for a fake in tests.
abstract class ReminderScheduler {
  /// Asks for permission to show notifications. Returns whether they are
  /// allowed.
  Future<bool> requestPermission();

  /// Shows [body] every day at [time], replacing any reminder with [id].
  Future<void> scheduleDaily({
    required int id,
    required TimeOfDay time,
    required String title,
    required String body,
  });

  Future<void> cancelAll();
}

/// The daily reminder settings of this phone. They are kept on the phone,
/// not in the family's shared data, because the notification is shown here.
class ReminderSettings extends ChangeNotifier {
  ReminderSettings({ReminderScheduler? scheduler})
    : _scheduler = scheduler ?? PhoneReminderScheduler();

  static const defaultMorning = TimeOfDay(hour: 8, minute: 0);
  static const defaultEvening = TimeOfDay(hour: 20, minute: 0);

  static const _morningId = 1;
  static const _eveningId = 2;

  final ReminderScheduler _scheduler;

  ReminderPlan _plan = ReminderPlan.off;
  TimeOfDay _morning = defaultMorning;
  TimeOfDay _evening = defaultEvening;

  ReminderPlan get plan => _plan;
  TimeOfDay get morning => _morning;
  TimeOfDay get evening => _evening;

  bool get remindsMorning =>
      _plan == ReminderPlan.morning || _plan == ReminderPlan.twice;
  bool get remindsEvening =>
      _plan == ReminderPlan.evening || _plan == ReminderPlan.twice;

  /// Reads the saved settings. Keeps the defaults if they can't be read.
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _plan =
          ReminderPlan.values.asNameMap()[prefs.getString(_planKey)] ??
          ReminderPlan.off;
      _morning = _time(prefs.getInt(_morningKey)) ?? defaultMorning;
      _evening = _time(prefs.getInt(_eveningKey)) ?? defaultEvening;
      notifyListeners();
    } on Object catch (e) {
      debugPrint('Reminder settings not loaded: $e');
    }
  }

  /// Changes the settings and sets the phone's reminders to match. Returns
  /// false, and leaves reminders off, when the phone blocks notifications.
  Future<bool> update(
    ReminderTexts texts, {
    ReminderPlan? plan,
    TimeOfDay? morning,
    TimeOfDay? evening,
  }) async {
    final turningOn =
        _plan == ReminderPlan.off && (plan ?? _plan) != ReminderPlan.off;
    var allowed = true;
    if (turningOn) allowed = await _scheduler.requestPermission();
    _plan = allowed ? plan ?? _plan : ReminderPlan.off;
    _morning = morning ?? _morning;
    _evening = evening ?? _evening;
    notifyListeners();
    await _save();
    await _apply(texts);
    return allowed;
  }

  /// Sets the phone's reminders again, for example after the language
  /// changed. Does nothing when reminders are off.
  Future<void> refresh(ReminderTexts texts) async {
    if (_plan != ReminderPlan.off) await _apply(texts);
  }

  Future<void> _apply(ReminderTexts texts) async {
    try {
      await _scheduler.cancelAll();
      if (remindsMorning) {
        await _scheduler.scheduleDaily(
          id: _morningId,
          time: _morning,
          title: texts.title,
          body: texts.morning,
        );
      }
      if (remindsEvening) {
        await _scheduler.scheduleDaily(
          id: _eveningId,
          time: _evening,
          title: texts.title,
          body: texts.evening,
        );
      }
    } on Object catch (e) {
      debugPrint('Reminders not set: $e');
    }
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_planKey, _plan.name);
      await prefs.setInt(_morningKey, _minutes(_morning));
      await prefs.setInt(_eveningKey, _minutes(_evening));
    } on Object catch (e) {
      debugPrint('Reminder settings not saved: $e');
    }
  }

  static const _planKey = 'reminders.plan';
  static const _morningKey = 'reminders.morning';
  static const _eveningKey = 'reminders.evening';

  static int _minutes(TimeOfDay t) => t.hour * 60 + t.minute;

  static TimeOfDay? _time(int? minutes) => minutes == null
      ? null
      : TimeOfDay(hour: minutes ~/ 60 % 24, minute: minutes % 60);
}

/// Gives the reminder settings to every screen, including pushed ones.
class RemindersScope extends InheritedNotifier<ReminderSettings> {
  const RemindersScope({
    super.key,
    required ReminderSettings reminders,
    required super.child,
  }) : super(notifier: reminders);

  static ReminderSettings of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RemindersScope>()!.notifier!;
}

/// Real notifications on Android and iPhone. Does nothing elsewhere, such as
/// in the web preview.
class PhoneReminderScheduler implements ReminderScheduler {
  final _plugin = FlutterLocalNotificationsPlugin();
  Future<bool>? _ready;

  static bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<bool> _init() => _ready ??= () async {
    if (!_supported) return false;
    tzdata.initializeTimeZones();
    try {
      final zone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(zone.identifier));
    } on Object catch (e) {
      debugPrint('Time zone unknown, reminders use UTC: $e');
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    return true;
  }();

  @override
  Future<bool> requestPermission() async {
    if (!await _init()) return true;
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    return await ios?.requestPermissions(alert: true, sound: true) ?? false;
  }

  @override
  Future<void> scheduleDaily({
    required int id,
    required TimeOfDay time,
    required String title,
    required String body,
  }) async {
    if (!await _init()) return;
    final now = tz.TZDateTime.now(tz.local);
    var at = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (!at.isAfter(now)) at = at.add(const Duration(days: 1));
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: at,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminders',
          'Daily reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      // Inexact alarms need no extra permission; Android may deliver the
      // reminder a few minutes late to save battery.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Future<void> cancelAll() async {
    if (!await _init()) return;
    await _plugin.cancelAll();
  }
}
