import 'package:flutter/material.dart';

import '../data/reminders.dart';
import '../l10n/app_localizations.dart';
import 'look.dart';

Future<void> showReminders(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const RemindersScreen()));

/// Daily reminder to check off habits: none, morning, evening or both, at a
/// time the user picks.
class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final look = Look.of(context);
    final reminders = RemindersScope.of(context);
    final texts = ReminderTexts.of(l10n);

    Future<void> change({
      ReminderPlan? plan,
      TimeOfDay? morning,
      TimeOfDay? evening,
    }) async {
      final messenger = ScaffoldMessenger.of(context);
      final allowed = await reminders.update(
        texts,
        plan: plan,
        morning: morning,
        evening: evening,
      );
      if (!allowed) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.remindersBlocked)));
      }
    }

    Future<void> pickTime(TimeOfDay current, bool isMorning) async {
      final picked = await showTimePicker(
        context: context,
        initialTime: current,
      );
      if (picked == null) return;
      await change(
        morning: isMorning ? picked : null,
        evening: isMorning ? null : picked,
      );
    }

    Widget timeTile(Key key, String label, TimeOfDay time, bool isMorning) =>
        ListTile(
          key: key,
          leading: Icon(
            isMorning ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
            color: look.primary,
          ),
          title: Text(label),
          trailing: Text(
            MaterialLocalizations.of(context).formatTimeOfDay(
              time,
              alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(
                context,
              ),
            ),
            style: look.heading(20).copyWith(color: look.primary),
          ),
          onTap: () => pickTime(time, isMorning),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reminders)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Text(
              l10n.remindersIntro,
              style: TextStyle(color: look.muted),
            ),
          ),
          RadioGroup<ReminderPlan>(
            groupValue: reminders.plan,
            onChanged: (plan) => change(plan: plan),
            child: Column(
              children: [
                for (final (plan, label) in [
                  (ReminderPlan.off, l10n.reminderOff),
                  (ReminderPlan.morning, l10n.reminderMorning),
                  (ReminderPlan.evening, l10n.reminderEvening),
                  (ReminderPlan.twice, l10n.reminderTwice),
                ])
                  RadioListTile<ReminderPlan>(
                    key: Key('reminder-${plan.name}'),
                    value: plan,
                    title: Text(label),
                  ),
              ],
            ),
          ),
          if (reminders.plan != ReminderPlan.off) const Divider(height: 24),
          if (reminders.remindsMorning)
            timeTile(
              const Key('morningTime'),
              l10n.morningTime,
              reminders.morning,
              true,
            ),
          if (reminders.remindsEvening)
            timeTile(
              const Key('eveningTime'),
              l10n.eveningTime,
              reminders.evening,
              false,
            ),
        ],
      ),
    );
  }
}
