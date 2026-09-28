// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Abitudini in famiglia';

  @override
  String get today => 'Oggi';

  @override
  String get familyWeek => 'Settimana della famiglia';

  @override
  String checkInsProgress(int done, int total) {
    return '$done su $total completate';
  }

  @override
  String get myHabits => 'Le mie abitudini';

  @override
  String get familyHabits => 'Abitudini di famiglia';

  @override
  String get familyHabitTag => 'Abitudine di famiglia';

  @override
  String get checkInForFamily => 'Segna per tutta la famiglia';

  @override
  String familyCheckedIn(String name, String habit) {
    return '$name ha segnato «$habit» per tutta la famiglia';
  }

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giorni',
      one: '1 giorno',
      zero: 'Ancora nessuna serie',
    );
    return '$_temp0';
  }

  @override
  String weekTarget(int done, int target) {
    return '$done/$target questa settimana';
  }

  @override
  String get categories => 'Categorie';

  @override
  String get language => 'Lingua';

  @override
  String get phoneLanguage => 'Lingua del telefono';

  @override
  String get parent => 'Genitore';

  @override
  String get child => 'Figlio o figlia';

  @override
  String get switchProfile => 'Cambia profilo';

  @override
  String get catQuitBadHabit => 'Smettere una cattiva abitudine';

  @override
  String get catArt => 'Arte';

  @override
  String get catMeditate => 'Meditazione';

  @override
  String get catStudy => 'Studio';

  @override
  String get catSport => 'Sport';

  @override
  String get catEntertainment => 'Intrattenimento';

  @override
  String get catFinance => 'Finanze';

  @override
  String get catHealth => 'Salute';

  @override
  String get catWork => 'Lavoro';

  @override
  String get catNutrition => 'Alimentazione';

  @override
  String get catHomeTasks => 'Faccende di casa';

  @override
  String get catOutdoor => 'Attività all’aperto';

  @override
  String get catFamilyTime => 'Tempo in famiglia';

  @override
  String get catFamilyTable => 'Pasti e ritrovi in famiglia';

  @override
  String get catSleep => 'Sonno';

  @override
  String get catSelfCare => 'Cura di sé e igiene';
}
