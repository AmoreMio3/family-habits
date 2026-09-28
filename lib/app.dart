import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/account_service.dart';
import 'l10n/app_localizations.dart';
import 'ui/auth/auth_gate.dart';

const brandGreen = Color(0xFF1D6F55);

/// Locales offered in the language picker, with their names in that language.
final languageNames = <Locale, String>{
  const Locale('en'): 'English (US)',
  const Locale('en', 'GB'): 'English (UK)',
  const Locale('es'): 'Español (España)',
  const Locale('es', '419'): 'Español (Latinoamérica)',
  const Locale('zh'): '简体中文',
  const Locale('zh', 'TW'): '繁體中文',
  const Locale('pt'): 'Português (Brasil)',
  const Locale('fr'): 'Français',
  const Locale('de'): 'Deutsch',
  const Locale('it'): 'Italiano',
  const Locale('he'): 'עברית',
  const Locale('hi'): 'हिन्दी',
  const Locale('ar'): 'العربية',
};

/// Settings for this device, independent of who is signed in.
class AppSettings extends ChangeNotifier {
  AppSettings({this._locale});

  Locale? _locale;

  /// Null means "follow the phone's language".
  Locale? get locale => _locale;

  set locale(Locale? value) {
    _locale = value;
    notifyListeners();
  }
}

class FamilyHabitsApp extends StatelessWidget {
  const FamilyHabitsApp({
    super.key,
    required this.accounts,
    required this.settings,
  });

  final AccountService accounts;
  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) => MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        locale: settings.locale,
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
        home: AuthGate(accounts: accounts, settings: settings),
      ),
    );
  }
}
