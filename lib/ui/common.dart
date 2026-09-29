import 'package:flutter/material.dart';

import '../app.dart';
import '../data/account_service.dart';
import '../l10n/app_localizations.dart';
import '../data/family_store.dart';
import '../models/category.dart';
import '../models/family.dart';

String accountErrorText(AppLocalizations l10n, Object error) {
  final code = error is AccountException ? error.error : AccountError.unknown;
  return switch (code) {
    AccountError.wrongPassword => l10n.errWrongPassword,
    AccountError.emailInUse => l10n.errEmailInUse,
    AccountError.weakPassword => l10n.errWeakPassword,
    AccountError.invalidEmail => l10n.errInvalidEmail,
    AccountError.codeNotFound => l10n.errCodeNotFound,
    AccountError.codeExpired => l10n.errCodeExpired,
    AccountError.codeWrongKind => l10n.errCodeWrongKind,
    AccountError.needsRecentLogin => l10n.errNeedsRecentLogin,
    AccountError.network => l10n.errNetwork,
    AccountError.unknown => l10n.errUnknown,
  };
}

String ageBandLabel(AppLocalizations l10n, AgeBand band) => switch (band) {
  AgeBand.under6 => l10n.ageUnder6,
  AgeBand.age6to9 => l10n.age6to9,
  AgeBand.age10to12 => l10n.age10to12,
  AgeBand.teen => l10n.ageTeen,
  AgeBand.adult => l10n.parent,
};

// Menu value for "follow the phone's language". A null value would read as
// "menu dismissed".
const _phone = Locale('und');

class LanguageMenu extends StatelessWidget {
  const LanguageMenu({super.key, required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.translate),
      tooltip: l10n.language,
      onSelected: (locale) =>
          settings.locale = locale == _phone ? null : locale,
      itemBuilder: (context) => [
        CheckedPopupMenuItem(
          value: _phone,
          checked: settings.locale == null,
          child: Text(l10n.phoneLanguage),
        ),
        const PopupMenuDivider(),
        for (final entry in languageNames.entries)
          CheckedPopupMenuItem(
            value: entry.key,
            checked: settings.locale == entry.key,
            child: Text(entry.value),
          ),
      ],
    );
  }
}

/// Runs [action], showing a spinner on the button and the error under it.
mixin BusyAction<T extends StatefulWidget> on State<T> {
  bool busy = false;
  String? errorText;

  Future<bool> run(Future<void> Function() action) async {
    setState(() {
      busy = true;
      errorText = null;
    });
    try {
      await action();
      return true;
    } catch (e) {
      if (mounted) {
        setState(
          () => errorText = accountErrorText(AppLocalizations.of(context), e),
        );
      }
      return false;
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }
}

class ErrorLine extends StatelessWidget {
  const ErrorLine(this.text, {super.key});

  final String? text;

  @override
  Widget build(BuildContext context) {
    if (text == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        text!,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}

class BusyButton extends StatelessWidget {
  const BusyButton({
    super.key,
    required this.label,
    required this.busy,
    required this.onPressed,
  });

  final String label;
  final bool busy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: busy ? null : onPressed,
    child: busy
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label),
  );
}

/// A centred, width-limited column for sign-in style forms.
class FormPage extends StatelessWidget {
  const FormPage({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    ),
  );
}

/// A habit category's name, icon and color, built-in or the family's own.
/// A deleted family category shows as "Other".
({String label, IconData icon, Color color}) categoryLook(
  AppLocalizations l10n,
  FamilyStore store,
  CategoryRef ref,
) => switch (ref) {
  BuiltInRef(:final category) => (
    label: category.label(l10n),
    icon: category.icon,
    color: category.color,
  ),
  CustomRef(:final customId) => (
    label: store.customCategory(customId)?.name ?? l10n.otherCategory,
    icon: CustomCategory.icon,
    color: CustomCategory.color,
  ),
};
