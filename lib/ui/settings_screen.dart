import 'package:flutter/material.dart';

import '../app.dart';
import '../data/account_service.dart';
import '../data/family_store.dart';
import '../data/reminders.dart';
import '../l10n/app_localizations.dart';
import 'common.dart';
import 'look.dart';
import 'reminders_screen.dart';

Future<void> showSettings(
  BuildContext context, {
  required FamilyStore store,
  required AppSettings settings,
  required AccountService accounts,
}) => Navigator.of(context).push(
  MaterialPageRoute<void>(
    builder: (_) =>
        SettingsScreen(store: store, settings: settings, accounts: accounts),
  ),
);

/// This phone's settings and the account: reminders, language, signing out.
/// The family's own settings are on the Family tab.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.store,
    required this.settings,
    required this.accounts,
  });

  final FamilyStore store;
  final AppSettings settings;
  final AccountService accounts;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final look = Look.of(context);
    Widget group(List<Widget> tiles) => SoftCard(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(children: tiles),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListenableBuilder(
        listenable: Listenable.merge([settings, RemindersScope.of(context)]),
        builder: (context, _) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          children: [
            group([
              ListTile(
                key: const Key('remindersButton'),
                leading: Icon(
                  Icons.notifications_none_rounded,
                  color: look.primary,
                ),
                title: Text(l10n.reminders),
                subtitle: Text(
                  reminderSummary(context, RemindersScope.of(context)),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => showReminders(context),
              ),
              ListTile(
                key: const Key('languageButton'),
                leading: Icon(Icons.translate, color: look.primary),
                title: Text(l10n.language),
                subtitle: Text(
                  settings.locale == null
                      ? l10n.phoneLanguage
                      : languageNames[settings.locale] ?? '',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _pickLanguage(context),
              ),
            ]),
            SectionTitle(l10n.account),
            if (store.access.isParent)
              group([
                ListTile(
                  leading: const Icon(Icons.logout_rounded),
                  title: Text(l10n.signOut),
                  onTap: () => _signOut(context),
                ),
                ListTile(
                  leading: Icon(
                    Icons.delete_forever_rounded,
                    color: theme.colorScheme.error,
                  ),
                  title: Text(
                    l10n.deleteAccount,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  onTap: () => _confirmDelete(
                    context,
                    title: l10n.deleteAccount,
                    body: _isOwner
                        ? l10n.deleteOwnerBody
                        : l10n.deleteParentBody,
                  ),
                ),
              ])
            else
              group([
                ListTile(
                  leading: Icon(Icons.link_off, color: theme.colorScheme.error),
                  title: Text(
                    l10n.unpairDevice,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  onTap: () => _confirmDelete(
                    context,
                    title: l10n.unpairDevice,
                    body: l10n.unpairBody,
                  ),
                ),
              ]),
          ],
        ),
      ),
    );
  }

  bool get _isOwner {
    final me = store.access.myMemberId == null
        ? null
        : store.member(store.access.myMemberId!);
    return me != null && me.uid != null && me.uid == store.info.ownerUid;
  }

  Future<void> _pickLanguage(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    // "Same as phone" can't be null: null means the dialog was dismissed.
    const phone = Locale('und');
    final picked = await showDialog<Locale>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.language),
        children: [
          for (final (locale, name) in [
            (phone, l10n.phoneLanguage),
            for (final e in languageNames.entries) (e.key, e.value),
          ])
            ListTile(
              title: Text(name),
              trailing: (settings.locale ?? phone) == locale
                  ? const Icon(Icons.check_rounded)
                  : null,
              onTap: () => Navigator.pop(context, locale),
            ),
        ],
      ),
    );
    if (picked != null) settings.locale = picked == phone ? null : picked;
  }

  Future<void> _signOut(BuildContext context) async {
    Navigator.of(context).popUntil((route) => route.isFirst);
    await accounts.signOut();
  }

  Future<void> _confirmDelete(
    BuildContext context, {
    required String title,
    required String body,
  }) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      navigator.popUntil((route) => route.isFirst);
      await accounts.deleteAccount();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(accountErrorText(l10n, e))),
      );
    }
  }
}
