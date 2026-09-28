import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/account_service.dart';
import '../../data/in_memory_accounts.dart';
import '../../l10n/app_localizations.dart';
import '../common.dart';
import 'join_code_screen.dart';
import 'sign_in_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    required this.accounts,
    required this.settings,
  });

  final AccountService accounts;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final accounts = this.accounts;
    return Scaffold(
      appBar: AppBar(actions: [LanguageMenu(settings: settings)]),
      body: FormPage(
        children: [
          Icon(Icons.diversity_3, size: 64, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            l10n.appTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.welcomeTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.welcomeBody,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => SignInScreen(accounts: accounts),
              ),
            ),
            child: Text(l10n.imParent),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => JoinCodeScreen(accounts: accounts),
              ),
            ),
            child: Text(l10n.joinWithCode),
          ),
          if (accounts is InMemoryAccountService) ...[
            const SizedBox(height: 12),
            TextButton(onPressed: accounts.openDemo, child: Text(l10n.tryDemo)),
          ],
        ],
      ),
    );
  }
}
