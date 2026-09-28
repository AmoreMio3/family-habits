import 'package:flutter/material.dart';

import '../app.dart';
import '../data/account_service.dart';
import '../data/family_store.dart';
import '../l10n/app_localizations.dart';
import 'categories_screen.dart';
import 'common.dart';
import 'family_screen.dart';
import 'habit_editor.dart';
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
        final title = store.isLoading ? l10n.appTitle : store.info.name;
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [LanguageMenu(settings: widget.settings)],
          ),
          body: Column(
            children: [
              if (store.isDemo) _DemoBanner(text: l10n.demoBanner),
              Expanded(
                child: store.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : switch (_tab) {
                        0 => TodayScreen(store: store),
                        1 => FamilyScreen(
                          store: store,
                          accounts: widget.accounts,
                        ),
                        _ => const CategoriesScreen(),
                      },
              ),
            ],
          ),
          floatingActionButton: _tab == 0 && !store.isLoading && store.canManage
              ? FloatingActionButton.extended(
                  onPressed: () => showHabitEditor(context, store),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addHabit),
                )
              : null,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _tab,
            onDestinationSelected: (i) => setState(() => _tab = i),
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.today_outlined),
                label: l10n.today,
              ),
              NavigationDestination(
                icon: const Icon(Icons.diversity_3_outlined),
                label: l10n.family,
              ),
              NavigationDestination(
                icon: const Icon(Icons.category_outlined),
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
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 18,
              color: scheme.onTertiaryContainer,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: scheme.onTertiaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
