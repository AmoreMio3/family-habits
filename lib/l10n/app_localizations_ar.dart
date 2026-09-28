// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'عادات العائلة';

  @override
  String get today => 'اليوم';

  @override
  String get familyWeek => 'أسبوع العائلة';

  @override
  String checkInsProgress(int done, int total) {
    return 'تم تسجيل $done من $total';
  }

  @override
  String get myHabits => 'عاداتي';

  @override
  String get familyHabits => 'عادات العائلة';

  @override
  String get familyHabitTag => 'عادة عائلية';

  @override
  String get checkInForFamily => 'تسجيل للعائلة كلها';

  @override
  String familyCheckedIn(String name, String habit) {
    return 'تم تسجيل «$habit» للعائلة كلها بواسطة $name';
  }

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count يوم',
      many: '$count يومًا',
      few: '$count أيام',
      two: 'يومان',
      one: 'يوم واحد',
      zero: 'لا توجد سلسلة بعد',
    );
    return '$_temp0';
  }

  @override
  String weekTarget(int done, int target) {
    return '$done/$target هذا الأسبوع';
  }

  @override
  String get categories => 'الفئات';

  @override
  String get language => 'اللغة';

  @override
  String get phoneLanguage => 'لغة الهاتف';

  @override
  String get parent => 'ولي الأمر';

  @override
  String get child => 'الطفل';

  @override
  String get switchProfile => 'تبديل الملف الشخصي';

  @override
  String get catQuitBadHabit => 'الإقلاع عن عادة سيئة';

  @override
  String get catArt => 'الفن';

  @override
  String get catMeditate => 'التأمل';

  @override
  String get catStudy => 'الدراسة';

  @override
  String get catSport => 'الرياضة';

  @override
  String get catEntertainment => 'الترفيه';

  @override
  String get catFinance => 'المال';

  @override
  String get catHealth => 'الصحة';

  @override
  String get catWork => 'العمل';

  @override
  String get catNutrition => 'التغذية';

  @override
  String get catHomeTasks => 'أعمال المنزل';

  @override
  String get catOutdoor => 'أنشطة في الهواء الطلق';

  @override
  String get catFamilyTime => 'وقت العائلة';

  @override
  String get catFamilyTable => 'وجبات ولقاءات عائلية';

  @override
  String get catSleep => 'النوم';

  @override
  String get catSelfCare => 'العناية الشخصية والنظافة';
}
