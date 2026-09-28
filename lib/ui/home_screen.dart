import 'package:flutter/material.dart';

import '../app.dart';
import '../data/family_store.dart';
import '../l10n/app_localizations.dart';
import 'categories_screen.dart';
import 'today_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.store});

  final FamilyStore store;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [_LanguageMenu(store: widget.store)],
      ),
      body: switch (_tab) {
        0 => TodayScreen(store: widget.store),
        _ => const CategoriesScreen(),
      },
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.today_outlined),
            label: l10n.today,
          ),
          NavigationDestination(
            icon: const Icon(Icons.category_outlined),
            label: l10n.categories,
          ),
        ],
      ),
    );
  }
}

// Menu value for "follow the phone's language". A null value would read as
// "menu dismissed".
const _phone = Locale('und');

class _LanguageMenu extends StatelessWidget {
  const _LanguageMenu({required this.store});

  final FamilyStore store;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.translate),
      tooltip: l10n.language,
      onSelected: (locale) => store.locale = locale == _phone ? null : locale,
      itemBuilder: (context) => [
        CheckedPopupMenuItem(
          value: _phone,
          checked: store.locale == null,
          child: Text(l10n.phoneLanguage),
        ),
        const PopupMenuDivider(),
        for (final entry in languageNames.entries)
          CheckedPopupMenuItem(
            value: entry.key,
            checked: store.locale == entry.key,
            child: Text(entry.value),
          ),
      ],
    );
  }
}
