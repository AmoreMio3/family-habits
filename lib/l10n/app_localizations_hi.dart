// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'पारिवारिक आदतें';

  @override
  String get today => 'आज';

  @override
  String get familyWeek => 'परिवार का सप्ताह';

  @override
  String checkInsProgress(int done, int total) {
    return '$total में से $done चेक-इन';
  }

  @override
  String get myHabits => 'मेरी आदतें';

  @override
  String get familyHabits => 'परिवार की आदतें';

  @override
  String get familyHabitTag => 'परिवार की आदत';

  @override
  String get checkInForFamily => 'पूरे परिवार के लिए चेक-इन करें';

  @override
  String familyCheckedIn(String name, String habit) {
    return '$name ने पूरे परिवार के लिए “$habit” चेक-इन किया';
  }

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन',
      one: '1 दिन',
      zero: 'अभी कोई सिलसिला नहीं',
    );
    return '$_temp0';
  }

  @override
  String weekTarget(int done, int target) {
    return 'इस सप्ताह $done/$target';
  }

  @override
  String get categories => 'श्रेणियाँ';

  @override
  String get language => 'भाषा';

  @override
  String get phoneLanguage => 'फ़ोन की भाषा';

  @override
  String get parent => 'माता-पिता';

  @override
  String get child => 'बच्चा';

  @override
  String get switchProfile => 'प्रोफ़ाइल बदलें';

  @override
  String get catQuitBadHabit => 'बुरी आदत छोड़ें';

  @override
  String get catArt => 'कला';

  @override
  String get catMeditate => 'ध्यान';

  @override
  String get catStudy => 'पढ़ाई';

  @override
  String get catSport => 'खेल';

  @override
  String get catEntertainment => 'मनोरंजन';

  @override
  String get catFinance => 'वित्त';

  @override
  String get catHealth => 'स्वास्थ्य';

  @override
  String get catWork => 'काम';

  @override
  String get catNutrition => 'पोषण';

  @override
  String get catHomeTasks => 'घर के काम';

  @override
  String get catOutdoor => 'बाहरी गतिविधियाँ';

  @override
  String get catFamilyTime => 'परिवार के साथ समय';

  @override
  String get catFamilyTable => 'पारिवारिक भोजन और मिलन';

  @override
  String get catSleep => 'नींद';

  @override
  String get catSelfCare => 'व्यक्तिगत देखभाल और स्वच्छता';
}
