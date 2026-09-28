import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/account_service.dart';
import '../../data/family_store.dart';
import '../../data/in_memory_accounts.dart';
import '../home_screen.dart';
import 'family_setup_screen.dart';
import 'welcome_screen.dart';

/// Shows the screen that fits the account's state.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.accounts, required this.settings});

  final AccountService accounts;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AccountState>(
      stream: accounts.watch(),
      builder: (context, snapshot) => switch (snapshot.data) {
        null => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        SignedOut() => WelcomeScreen(accounts: accounts, settings: settings),
        NeedsFamily() => FamilySetupScreen(
          accounts: accounts,
          settings: settings,
        ),
        Ready(:final session) => _SessionHome(
          key: ValueKey('${session.uid}/${session.familyId}'),
          accounts: accounts,
          settings: settings,
          session: session,
        ),
      },
    );
  }
}

class _SessionHome extends StatefulWidget {
  const _SessionHome({
    super.key,
    required this.accounts,
    required this.settings,
    required this.session,
  });

  final AccountService accounts;
  final AppSettings settings;
  final Session session;

  @override
  State<_SessionHome> createState() => _SessionHomeState();
}

class _SessionHomeState extends State<_SessionHome> {
  late final FamilyStore store = FamilyStore(
    repository: widget.accounts.repositoryFor(widget.session),
    access: widget.session.isParent
        ? DeviceAccess.parent(myMemberId: widget.session.memberId)
        : DeviceAccess.device(memberIds: widget.session.memberIds),
    isDemo: widget.accounts is InMemoryAccountService,
  );

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HomeScreen(
    store: store,
    settings: widget.settings,
    accounts: widget.accounts,
  );
}
