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

  @override
  String get welcomeTitle => 'मिलकर अच्छी आदतें बनाएँ';

  @override
  String get welcomeBody =>
      'अपनी आदतें ट्रैक करें, बच्चों की आदतों में उनकी मदद करें, और परिवार की पट्टी भरते देखें।';

  @override
  String get imParent => 'मैं माता-पिता हूँ';

  @override
  String get joinWithCode => 'कोड से जुड़ें';

  @override
  String get tryDemo => 'नमूना परिवार आज़माएँ';

  @override
  String get signIn => 'साइन इन करें';

  @override
  String get createAccount => 'खाता बनाएँ';

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String passwordResetSent(String email) {
    return 'हमने पासवर्ड रीसेट करने का लिंक $email पर भेज दिया है।';
  }

  @override
  String get haveAccount => 'मेरा खाता पहले से है';

  @override
  String get newHere => 'मैं नया हूँ';

  @override
  String get errWrongPassword => 'ईमेल या पासवर्ड गलत है।';

  @override
  String get errEmailInUse =>
      'इस ईमेल से पहले से एक खाता है। उसमें साइन इन करें।';

  @override
  String get errWeakPassword => 'पासवर्ड में कम से कम 6 अक्षर रखें।';

  @override
  String get errInvalidEmail => 'ईमेल पता जाँच लें।';

  @override
  String get errCodeNotFound =>
      'यह कोड मौजूद नहीं है। जिसने बनाया है, उनसे जाँच लें।';

  @override
  String get errCodeExpired =>
      'इस कोड की समय-सीमा खत्म हो गई है। माता-पिता से नया कोड माँगें।';

  @override
  String get errCodeWrongKind =>
      'यह कोड किसी दूसरी तरह से जुड़ने के लिए है। सही कोड माँगें।';

  @override
  String get errNeedsRecentLogin =>
      'सुरक्षा के लिए साइन आउट करें, फिर से साइन इन करें और दोबारा कोशिश करें।';

  @override
  String get errNetwork =>
      'इंटरनेट कनेक्शन नहीं है। ऑनलाइन होने पर फिर कोशिश करें।';

  @override
  String get errUnknown => 'कुछ गड़बड़ हो गई। फिर से कोशिश करें।';

  @override
  String get setUpFamily => 'अपना परिवार सेट करें';

  @override
  String get createFamily => 'परिवार बनाएँ';

  @override
  String get familyName => 'परिवार का नाम';

  @override
  String get yourName => 'परिवार में आपका नाम';

  @override
  String get joinFamily => 'अपने जीवनसाथी के परिवार से जुड़ें';

  @override
  String get inviteCode => 'आमंत्रण कोड';

  @override
  String get continueAction => 'आगे बढ़ें';

  @override
  String get enterCode => 'माता-पिता के फ़ोन पर दिखा कोड डालें।';

  @override
  String get pairCode => 'कोड';

  @override
  String get join => 'जुड़ें';

  @override
  String get family => 'परिवार';

  @override
  String get addChild => 'बच्चा जोड़ें';

  @override
  String get inviteParent => 'दूसरे माता-पिता को आमंत्रित करें';

  @override
  String get nickname => 'नाम या उपनाम';

  @override
  String get ageBand => 'उम्र';

  @override
  String get ageUnder6 => '6 से कम';

  @override
  String get age6to9 => '6 से 9';

  @override
  String get age10to12 => '10 से 12';

  @override
  String get ageTeen => '13 से 17';

  @override
  String get ownDevice => 'उसका अपना फ़ोन या टैबलेट है';

  @override
  String get consentTitle => 'माता-पिता की सहमति';

  @override
  String get consentBody =>
      'मैं इस बच्चे का माता-पिता या अभिभावक हूँ। मैं सहमत हूँ कि Family Habits बच्चे का उपनाम, उम्र वर्ग और आदतों के चेक-इन सहेजे, ताकि हमारा परिवार मिलकर आदतें ट्रैक कर सके। मैं यह जानकारी कभी भी मिटा सकता/सकती हूँ।';

  @override
  String get consentCheck => 'मैं सहमत हूँ';

  @override
  String get save => 'सहेजें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get delete => 'मिटाएँ';

  @override
  String get pairDevice => 'डिवाइस जोड़ें';

  @override
  String get sharedDevice => 'परिवार का साझा डिवाइस जोड़ें';

  @override
  String get codeInstructions =>
      'दूसरे डिवाइस पर Family Habits खोलें, “कोड से जुड़ें” पर टैप करें और यह कोड डालें। यह 24 घंटे तक, एक बार काम करता है।';

  @override
  String get setPin => 'पिन सेट करें';

  @override
  String get removePin => 'पिन हटाएँ';

  @override
  String get pinTitle => 'पिन डालें';

  @override
  String get pinWrong => 'गलत पिन';

  @override
  String removeMemberConfirm(String name) {
    return '$name और उनकी सभी आदतें मिटाएँ?';
  }

  @override
  String get weekStartsOn => 'सप्ताह शुरू होता है';

  @override
  String get weekStartAuto => 'भाषा के अनुसार';

  @override
  String get signOut => 'साइन आउट करें';

  @override
  String get deleteAccount => 'खाता मिटाएँ';

  @override
  String get deleteOwnerBody =>
      'इससे आपका खाता और पूरा परिवार मिट जाएगा: हर प्रोफ़ाइल, आदत और चेक-इन। इसे वापस नहीं लाया जा सकता।';

  @override
  String get deleteParentBody =>
      'इससे आपका खाता और इस परिवार में आपकी प्रोफ़ाइल मिट जाएगी। इसे वापस नहीं लाया जा सकता।';

  @override
  String get unpairDevice => 'यह डिवाइस डिस्कनेक्ट करें';

  @override
  String get unpairBody =>
      'यह डिवाइस परिवार से हट जाएगा। माता-पिता नए कोड से इसे फिर जोड़ सकते हैं।';

  @override
  String get demoBanner => 'नमूना परिवार। बदलाव सहेजे नहीं जाते।';

  @override
  String get addHabit => 'आदत जोड़ें';

  @override
  String get editHabit => 'आदत बदलें';

  @override
  String get habitName => 'आदत का नाम';

  @override
  String get category => 'श्रेणी';

  @override
  String get subcategory => 'उप-श्रेणी';

  @override
  String get habitFor => 'किसके लिए';

  @override
  String get wholeFamily => 'पूरा परिवार';

  @override
  String timesPerWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'हफ़्ते में $count बार',
      one: 'हफ़्ते में एक बार',
    );
    return '$_temp0';
  }

  @override
  String deleteHabitConfirm(String habit) {
    return '“$habit” और उसका इतिहास मिटाएँ?';
  }

  @override
  String get noHabitsYet => 'अभी कोई आदत नहीं है।';

  @override
  String get members => 'सदस्य';

  @override
  String get settings => 'सेटिंग';

  @override
  String get everyDay => 'हर दिन';

  @override
  String get loadFailed =>
      'आपका परिवार लोड नहीं हो सका। अपना इंटरनेट कनेक्शन जाँचें और फिर से कोशिश करें।';

  @override
  String get tryAgain => 'फिर से कोशिश करें';
}
