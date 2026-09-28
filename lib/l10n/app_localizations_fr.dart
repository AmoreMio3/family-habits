// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Habitudes en famille';

  @override
  String get today => 'Aujourd’hui';

  @override
  String get familyWeek => 'Semaine de la famille';

  @override
  String checkInsProgress(int done, int total) {
    return '$done sur $total validations';
  }

  @override
  String get myHabits => 'Mes habitudes';

  @override
  String get familyHabits => 'Habitudes familiales';

  @override
  String get familyHabitTag => 'Habitude familiale';

  @override
  String get checkInForFamily => 'Valider pour toute la famille';

  @override
  String familyCheckedIn(String name, String habit) {
    return '$name a validé « $habit » pour toute la famille';
  }

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
      zero: 'Pas encore de série',
    );
    return '$_temp0';
  }

  @override
  String weekTarget(int done, int target) {
    return '$done/$target cette semaine';
  }

  @override
  String get categories => 'Catégories';

  @override
  String get language => 'Langue';

  @override
  String get phoneLanguage => 'Langue du téléphone';

  @override
  String get parent => 'Parent';

  @override
  String get child => 'Enfant';

  @override
  String get switchProfile => 'Changer de profil';

  @override
  String get catQuitBadHabit => 'Arrêter une mauvaise habitude';

  @override
  String get catArt => 'Art';

  @override
  String get catMeditate => 'Méditation';

  @override
  String get catStudy => 'Études';

  @override
  String get catSport => 'Sport';

  @override
  String get catEntertainment => 'Divertissement';

  @override
  String get catFinance => 'Finances';

  @override
  String get catHealth => 'Santé';

  @override
  String get catWork => 'Travail';

  @override
  String get catNutrition => 'Nutrition';

  @override
  String get catHomeTasks => 'Tâches ménagères';

  @override
  String get catOutdoor => 'Activités de plein air';

  @override
  String get catFamilyTime => 'Temps en famille';

  @override
  String get catFamilyTable => 'Repas et réunions de famille';

  @override
  String get catSleep => 'Sommeil';

  @override
  String get catSelfCare => 'Soins personnels et hygiène';
}
