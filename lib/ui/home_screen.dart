import 'package:flutter/material.dart';

import '../app.dart';
import '../data/account_service.dart';
import '../data/family_store.dart';
import '../data/reminders.dart';
import '../l10n/app_localizations.dart';
import 'categories_screen.dart';
import 'family_screen.dart';
import 'habit_picker.dart';
import 'look.dart';
import 'main_menu.dart';
import 'my_habits_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';
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
  Locale? _reminderLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Set the reminders again so their text follows the app's language.
    final locale = Localizations.localeOf(context);
    if (locale != _reminderLocale) {
      _reminderLocale = locale;
      widget.settings.reminders.refresh(
        ReminderTexts.of(AppLocalizations.of(context)),
      );
    }
  }

  void _select(int tab) => setState(() => _tab = tab);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final store = widget.store;
    return ListenableBuilder(
      listenable: Listenable.merge([store, widget.settings]),
      builder: (context, _) {
        final title = store.hasData ? store.info.name : l10n.appTitle;
        final top = widget.settings.menuPlace == MenuPlace.top;
        final items = [
          MenuItem(
            icon: Icons.wb_sunny_outlined,
            selectedIcon: Icons.wb_sunny_rounded,
            label: l10n.myDay,
          ),
          MenuItem(
            icon: Icons.checklist_rounded,
            selectedIcon: Icons.checklist_rounded,
            label: l10n.myHabits,
          ),
          MenuItem(
            icon: Icons.insights_outlined,
            selectedIcon: Icons.insights_rounded,
            label: l10n.myProgress,
          ),
          MenuItem(
            icon: Icons.diversity_3_outlined,
            selectedIcon: Icons.diversity_3_rounded,
            label: l10n.family,
          ),
          MenuItem(
            icon: Icons.lightbulb_outline_rounded,
            selectedIcon: Icons.lightbulb_rounded,
            label: l10n.habitIdeas,
          ),
        ];
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [
              IconButton(
                key: const Key('settingsButton'),
                tooltip: l10n.settings,
                icon: const Icon(Icons.settings_rounded),
                onPressed: store.hasData
                    ? () => showSettings(
                        context,
                        store: store,
                        settings: widget.settings,
                        accounts: widget.accounts,
                      )
                    : null,
              ),
            ],
          ),
          body: Column(
            children: [
              if (top)
                TopMenu(items: items, selected: _tab, onSelected: _select),
              if (store.isDemo) _DemoBanner(text: l10n.demoBanner),
              Expanded(
                child: !store.hasData
                    ? store.error == null
                          ? const Center(child: CircularProgressIndicator())
                          : _LoadError(store: store, accounts: widget.accounts)
                    : switch (_tab) {
                        0 => TodayScreen(store: store),
                        1 => MyHabitsScreen(store: store),
                        2 => MyProgressScreen(store: store),
                        3 => FamilyScreen(store: store),
                        _ => CategoriesScreen(store: store),
                      },
              ),
            ],
          ),
          floatingActionButton: _tab <= 1 && store.hasData && store.canManage
              ? FloatingActionButton.extended(
                  onPressed: () => showHabitPicker(context, store),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(
                    store.childInView == null
                        ? l10n.addHabit
                        : l10n.addHabitFor(store.childInView!.nickname),
                  ),
                )
              : null,
          bottomNavigationBar: top
              ? null
              : BottomMenu(items: items, selected: _tab, onSelected: _select),
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
