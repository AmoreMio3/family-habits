// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Family Habits';

  @override
  String get today => 'Today';

  @override
  String get familyWeek => 'Family week';

  @override
  String checkInsProgress(int done, int total) {
    return '$done of $total check-ins';
  }

  @override
  String get myHabits => 'My habits';

  @override
  String get familyHabits => 'Family habits';

  @override
  String get familyHabitTag => 'Family habit';

  @override
  String get checkInForFamily => 'Check in for the family';

  @override
  String familyCheckedIn(String name, String habit) {
    return '$name checked in “$habit” for the whole family';
  }

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
      zero: 'No streak yet',
    );
    return '$_temp0';
  }

  @override
  String weekTarget(int done, int target) {
    return '$done/$target this week';
  }

  @override
  String get categories => 'Categories';

  @override
  String get language => 'Language';

  @override
  String get phoneLanguage => 'Phone language';

  @override
  String get parent => 'Parent';

  @override
  String get child => 'Child';

  @override
  String get switchProfile => 'Switch profile';

  @override
  String get catQuitBadHabit => 'Quit a bad habit';

  @override
  String get catArt => 'Art';

  @override
  String get catMeditate => 'Meditate';

  @override
  String get catStudy => 'Study';

  @override
  String get catSport => 'Sport';

  @override
  String get catEntertainment => 'Entertainment';

  @override
  String get catFinance => 'Finance';

  @override
  String get catHealth => 'Health';

  @override
  String get catWork => 'Work';

  @override
  String get catNutrition => 'Nutrition';

  @override
  String get catHomeTasks => 'Home tasks';

  @override
  String get catOutdoor => 'Outdoor activities';

  @override
  String get catFamilyTime => 'Family quality time';

  @override
  String get catFamilyTable => 'Family dinner & gatherings';

  @override
  String get catSleep => 'Sleep';

  @override
  String get catSelfCare => 'Self-care & hygiene';
}

/// The translations for English, as used in the United Kingdom (`en_GB`).
class AppLocalizationsEnGb extends AppLocalizationsEn {
  AppLocalizationsEnGb() : super('en_GB');
}
