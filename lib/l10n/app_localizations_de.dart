// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Familiengewohnheiten';

  @override
  String get today => 'Heute';

  @override
  String get familyWeek => 'Familienwoche';

  @override
  String checkInsProgress(int done, int total) {
    return '$done von $total erledigt';
  }

  @override
  String get myHabits => 'Meine Gewohnheiten';

  @override
  String get familyHabits => 'Familiengewohnheiten';

  @override
  String get familyHabitTag => 'Familiengewohnheit';

  @override
  String get checkInForFamily => 'Für die ganze Familie abhaken';

  @override
  String familyCheckedIn(String name, String habit) {
    return '$name hat „$habit“ für die ganze Familie abgehakt';
  }

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '1 Tag',
      zero: 'Noch keine Serie',
    );
    return '$_temp0';
  }

  @override
  String weekTarget(int done, int target) {
    return '$done/$target diese Woche';
  }

  @override
  String get categories => 'Kategorien';

  @override
  String get language => 'Sprache';

  @override
  String get phoneLanguage => 'Sprache des Telefons';

  @override
  String get parent => 'Elternteil';

  @override
  String get child => 'Kind';

  @override
  String get switchProfile => 'Profil wechseln';

  @override
  String get catQuitBadHabit => 'Schlechte Gewohnheit ablegen';

  @override
  String get catArt => 'Kunst';

  @override
  String get catMeditate => 'Meditation';

  @override
  String get catStudy => 'Lernen';

  @override
  String get catSport => 'Sport';

  @override
  String get catEntertainment => 'Unterhaltung';

  @override
  String get catFinance => 'Finanzen';

  @override
  String get catHealth => 'Gesundheit';

  @override
  String get catWork => 'Arbeit';

  @override
  String get catNutrition => 'Ernährung';

  @override
  String get catHomeTasks => 'Haushalt';

  @override
  String get catOutdoor => 'Aktivitäten im Freien';

  @override
  String get catFamilyTime => 'Familienzeit';

  @override
  String get catFamilyTable => 'Familienessen und Treffen';

  @override
  String get catSleep => 'Schlaf';

  @override
  String get catSelfCare => 'Körperpflege und Hygiene';
}
