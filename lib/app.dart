import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/family_store.dart';
import 'l10n/app_localizations.dart';
import 'ui/home_screen.dart';

const brandGreen = Color(0xFF1D6F55);

/// Locales offered in the language picker, with their names in that language.
final languageNames = <Locale, String>{
  Locale('en'): 'English (US)',
  Locale('en', 'GB'): 'English (UK)',
  Locale('es'): 'Español (España)',
  Locale('es', '419'): 'Español (Latinoamérica)',
  Locale('zh'): '简体中文',
  Locale('zh', 'TW'): '繁體中文',
  Locale('pt'): 'Português (Brasil)',
  Locale('fr'): 'Français',
  Locale('de'): 'Deutsch',
  Locale('it'): 'Italiano',
  Locale('he'): 'עברית',
  Locale('hi'): 'हिन्दी',
  Locale('ar'): 'العربية',
};

class FamilyHabitsApp extends StatelessWidget {
  const FamilyHabitsApp({super.key, required this.store});

  final FamilyStore store;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) => MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        locale: store.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(colorSchemeSeed: brandGreen, useMaterial3: true),
        darkTheme: ThemeData(
          colorSchemeSeed: brandGreen,
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        home: HomeScreen(store: store),
      ),
    );
  }
}
