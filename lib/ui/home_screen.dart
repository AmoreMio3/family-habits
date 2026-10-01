import 'package:flutter/material.dart';

import '../app.dart';
import '../data/account_service.dart';
import '../data/family_store.dart';
import '../l10n/app_localizations.dart';
import 'categories_screen.dart';
import 'common.dart';
import 'family_screen.dart';
import 'habit_picker.dart';
import 'look.dart';
import 'today_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.store,
    required this.settings,
    required this.accounts,
  });

  final FamilyStore store;
  final AppSettings settings;
  final AccountService accounts;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final store = widget.store;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final title = store.hasData ? store.info.name : l10n.appTitle;
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [LanguageMenu(settings: widget.settings)],
          ),
          body: Column(
            children: [
              if (store.isDemo) _DemoBanner(text: l10n.demoBanner),
              Expanded(
                child: !store.hasData
                    ? store.error == null
                          ? const Center(child: CircularProgressIndicator())
                          : _LoadError(store: store, accounts: widget.accounts)
                    : switch (_tab) {
                        0 => TodayScreen(store: store),
                        1 => FamilyScreen(
                          store: store,
                          accounts: widget.accounts,
                        ),
                        _ => CategoriesScreen(store: store),
                      },
              ),
            ],
          ),
          floatingActionButton: _tab == 0 && store.hasData && store.canManage
              ? FloatingActionButton.extended(
                  onPressed: () => showHabitPicker(context, store),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(l10n.addHabit),
                )
              : null,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _tab,
            onDestinationSelected: (i) => setState(() => _tab = i),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.wb_sunny_outlined),
                selectedIcon: const Icon(Icons.wb_sunny_rounded),
                label: l10n.today,
              ),
              NavigationDestination(
                icon: const Icon(Icons.diversity_3_outlined),
                selectedIcon: const Icon(Icons.diversity_3_rounded),
                label: l10n.family,
              ),
              NavigationDestination(
                icon: const Icon(Icons.category_outlined),
                selectedIcon: const Icon(Icons.category_rounded),
                label: l10n.categories,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DemoBanner extends StatelessWidget {
  const _DemoBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final look = Look.of(context);
    return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: look.tint(look.streak),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome_rounded, size: 18, color: look.streak),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: TextStyle(color: look.ink, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

/// Shown when the family can't be loaded, instead of an empty screen.
class _LoadError extends StatelessWidget {
  const _LoadError({required this.store, required this.accounts});

  final FamilyStore store;
  final AccountService accounts;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.loadFailed, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('retry'),
              onPressed: store.retry,
              child: Text(l10n.tryAgain),
            ),
            TextButton(onPressed: accounts.signOut, child: Text(l10n.signOut)),
          ],
        ),
      ),
    );
  }
}
