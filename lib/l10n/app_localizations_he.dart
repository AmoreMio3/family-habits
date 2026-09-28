// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'הרגלים במשפחה';

  @override
  String get today => 'היום';

  @override
  String get familyWeek => 'השבוע של המשפחה';

  @override
  String checkInsProgress(int done, int total) {
    return '$done מתוך $total סימונים';
  }

  @override
  String get myHabits => 'ההרגלים שלי';

  @override
  String get familyHabits => 'הרגלי משפחה';

  @override
  String get familyHabitTag => 'הרגל משפחתי';

  @override
  String get checkInForFamily => 'סימון לכל המשפחה';

  @override
  String familyCheckedIn(String name, String habit) {
    return '„$habit” סומן לכל המשפחה על ידי $name';
  }

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ימים',
      two: 'יומיים',
      one: 'יום אחד',
      zero: 'עדיין אין רצף',
    );
    return '$_temp0';
  }

  @override
  String weekTarget(int done, int target) {
    return '$done/$target השבוע';
  }

  @override
  String get categories => 'קטגוריות';

  @override
  String get language => 'שפה';

  @override
  String get phoneLanguage => 'שפת הטלפון';

  @override
  String get parent => 'הורה';

  @override
  String get child => 'ילד או ילדה';

  @override
  String get switchProfile => 'החלפת פרופיל';

  @override
  String get catQuitBadHabit => 'גמילה מהרגל רע';

  @override
  String get catArt => 'אמנות';

  @override
  String get catMeditate => 'מדיטציה';

  @override
  String get catStudy => 'לימודים';

  @override
  String get catSport => 'ספורט';

  @override
  String get catEntertainment => 'בידור';

  @override
  String get catFinance => 'כספים';

  @override
  String get catHealth => 'בריאות';

  @override
  String get catWork => 'עבודה';

  @override
  String get catNutrition => 'תזונה';

  @override
  String get catHomeTasks => 'מטלות בית';

  @override
  String get catOutdoor => 'פעילות בחוץ';

  @override
  String get catFamilyTime => 'זמן משפחתי איכותי';

  @override
  String get catFamilyTable => 'ארוחות ומפגשים משפחתיים';

  @override
  String get catSleep => 'שינה';

  @override
  String get catSelfCare => 'טיפוח והיגיינה';
}
