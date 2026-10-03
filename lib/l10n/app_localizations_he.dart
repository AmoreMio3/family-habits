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
  String get catArt => 'אמנות ויצירה';

  @override
  String get catStudy => 'לימודים';

  @override
  String get catSport => 'ספורט';

  @override
  String get catFinance => 'כספים';

  @override
  String get catHealth => 'בריאות';

  @override
  String get catWork => 'עבודה';

  @override
  String get catNutrition => 'תזונה';

  @override
  String get catHomeTasks => 'משימות בית';

  @override
  String get catOutdoor => 'פעילות בחוץ';

  @override
  String get catFamilyTime => 'זמן איכות משפחתי';

  @override
  String get catSleep => 'שינה';

  @override
  String get catSelfCare => 'טיפוח והיגיינה';

  @override
  String get welcomeTitle => 'בונים הרגלים טובים ביחד';

  @override
  String get welcomeBody =>
      'עוקבים אחרי ההרגלים שלכם, עוזרים לילדים עם שלהם, ורואים את פס המשפחה מתמלא.';

  @override
  String get imParent => 'אני הורה';

  @override
  String get joinWithCode => 'הצטרפות עם קוד';

  @override
  String get tryDemo => 'לנסות את משפחת הדוגמה';

  @override
  String get signIn => 'כניסה';

  @override
  String get createAccount => 'יצירת חשבון';

  @override
  String get email => 'אימייל';

  @override
  String get password => 'סיסמה';

  @override
  String get forgotPassword => 'שכחת סיסמה?';

  @override
  String passwordResetSent(String email) {
    return 'שלחנו קישור לאיפוס הסיסמה אל $email.';
  }

  @override
  String get haveAccount => 'כבר יש לי חשבון';

  @override
  String get newHere => 'אני חדש כאן';

  @override
  String get errWrongPassword => 'האימייל או הסיסמה שגויים.';

  @override
  String get errEmailInUse =>
      'כבר קיים חשבון עם האימייל הזה. אפשר להיכנס אליו.';

  @override
  String get errWeakPassword => 'הסיסמה צריכה לכלול לפחות 6 תווים.';

  @override
  String get errInvalidEmail => 'כדאי לבדוק את כתובת האימייל.';

  @override
  String get errCodeNotFound =>
      'הקוד הזה לא קיים. כדאי לבדוק אותו מול ההורה שיצר אותו.';

  @override
  String get errCodeExpired => 'תוקף הקוד פג. אפשר לבקש קוד חדש מהורה.';

  @override
  String get errCodeWrongKind =>
      'הקוד הזה מיועד לסוג הצטרפות אחר. אפשר לבקש מהורה את הקוד הנכון.';

  @override
  String get errNeedsRecentLogin =>
      'לביטחונך, צריך לצאת, להיכנס שוב ולנסות שוב.';

  @override
  String get errNetwork => 'אין חיבור לאינטרנט. אפשר לנסות שוב כשיהיה חיבור.';

  @override
  String get errUnknown => 'משהו השתבש. כדאי לנסות שוב.';

  @override
  String get setUpFamily => 'הגדרת המשפחה';

  @override
  String get createFamily => 'יצירת משפחה';

  @override
  String get familyName => 'שם המשפחה';

  @override
  String get yourName => 'השם שלך במשפחה';

  @override
  String get joinFamily => 'הצטרפות למשפחה של בן או בת הזוג';

  @override
  String get inviteCode => 'קוד הזמנה';

  @override
  String get continueAction => 'המשך';

  @override
  String get enterCode => 'מקלידים את הקוד שמוצג בטלפון של אחד ההורים.';

  @override
  String get pairCode => 'קוד';

  @override
  String get join => 'הצטרפות';

  @override
  String get family => 'משפחה';

  @override
  String get addChild => 'הוספת ילד או ילדה';

  @override
  String get inviteParent => 'הזמנת הורה נוסף';

  @override
  String get nickname => 'שם או כינוי';

  @override
  String get ageBand => 'גיל';

  @override
  String get ageUnder6 => 'מתחת ל-6';

  @override
  String get age6to9 => '6 עד 9';

  @override
  String get age10to12 => '10 עד 12';

  @override
  String get ageTeen => '13 עד 17';

  @override
  String get ownDevice => 'יש טלפון או טאבלט משלו';

  @override
  String get consentTitle => 'הסכמת הורה';

  @override
  String get consentBody =>
      'אני ההורה או האפוטרופוס של הילד או הילדה. אני מסכים או מסכימה ש-Family Habits תשמור את הכינוי, טווח הגיל וסימוני ההרגלים, כדי שהמשפחה שלנו תוכל לעקוב אחרי הרגלים ביחד. אפשר למחוק את המידע הזה בכל עת.';

  @override
  String get consentCheck => 'אני מסכים/ה';

  @override
  String get save => 'שמירה';

  @override
  String get cancel => 'ביטול';

  @override
  String get delete => 'מחיקה';

  @override
  String get pairDevice => 'חיבור מכשיר';

  @override
  String get sharedDevice => 'חיבור מכשיר משפחתי משותף';

  @override
  String get codeInstructions =>
      'במכשיר השני פותחים את Family Habits, מקישים על „הצטרפות עם קוד” ומזינים את הקוד הזה. הוא עובד פעם אחת, במשך 24 שעות.';

  @override
  String get setPin => 'הגדרת קוד PIN';

  @override
  String get removePin => 'הסרת קוד PIN';

  @override
  String get pinTitle => 'הזנת קוד PIN';

  @override
  String get pinWrong => 'קוד PIN שגוי';

  @override
  String removeMemberConfirm(String name) {
    return 'למחוק את $name ואת כל ההרגלים?';
  }

  @override
  String get weekStartsOn => 'השבוע מתחיל ביום';

  @override
  String get weekStartAuto => 'לפי השפה';

  @override
  String get signOut => 'יציאה';

  @override
  String get deleteAccount => 'מחיקת החשבון';

  @override
  String get deleteOwnerBody =>
      'הפעולה תמחק את החשבון ואת כל המשפחה: כל פרופיל, הרגל וסימון. אי אפשר לבטל אותה.';

  @override
  String get deleteParentBody =>
      'הפעולה תמחק את החשבון ואת הפרופיל שלך במשפחה הזו. אי אפשר לבטל אותה.';

  @override
  String get unpairDevice => 'ניתוק המכשיר הזה';

  @override
  String get unpairBody =>
      'המכשיר הזה ייצא מהמשפחה. הורה יכול לחבר אותו מחדש עם קוד חדש.';

  @override
  String get demoBanner => 'משפחת דוגמה. השינויים לא נשמרים.';

  @override
  String get addHabit => 'הוספת הרגל';

  @override
  String get editHabit => 'עריכת הרגל';

  @override
  String get habitName => 'שם ההרגל';

  @override
  String get category => 'קטגוריה';

  @override
  String get habitFor => 'בשביל';

  @override
  String get wholeFamily => 'כל המשפחה';

  @override
  String timesPerWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count פעמים בשבוע',
      two: 'פעמיים בשבוע',
      one: 'פעם בשבוע',
    );
    return '$_temp0';
  }

  @override
  String deleteHabitConfirm(String habit) {
    return 'למחוק את „$habit” ואת ההיסטוריה שלו?';
  }

  @override
  String get noHabitsYet => 'עדיין אין הרגלים.';

  @override
  String get members => 'בני המשפחה';

  @override
  String get settings => 'הגדרות';

  @override
  String get everyDay => 'כל יום';

  @override
  String get catBreakHabit => 'להיגמל מהרגל';

  @override
  String get catMindfulness => 'מיינדפולנס';

  @override
  String get catFamilyCare => 'דאגה למשפחה והורות';

  @override
  String get catFamilyMeals => 'ארוחות ומפגשים משפחתיים';

  @override
  String get catHobbies => 'תחביבים והנאה';

  @override
  String get groupSelf => 'לדאוג לעצמי';

  @override
  String get groupFamily => 'לדאוג למשפחה שלי';

  @override
  String get groupDaily => 'האחריות שלי';

  @override
  String get groupLeisure => 'ליהנות מהחיים';

  @override
  String get createMyOwnHabit => 'ליצור הרגל משלי';

  @override
  String get createMyOwnCategory => 'ליצור קטגוריה משלי';

  @override
  String createNamedHabit(String name) {
    return 'ליצור את „$name” כהרגל משלי';
  }

  @override
  String get searchHabitsHint => 'חיפוש, למשל „פארק” או „ספר”';

  @override
  String get noMatchingHabits => 'אין הרגל מוכן שמתאים. אפשר ליצור הרגל משלך.';

  @override
  String get ourCategories => 'הקטגוריות של המשפחה שלנו';

  @override
  String get personalDefinition => 'מה נחשב כבוצע? (לא חובה)';

  @override
  String get personalDefinitionHint => 'למשל: שתיתי מספיק מים היום';

  @override
  String get categoryName => 'שם הקטגוריה';

  @override
  String get categoryHabits => 'הרגלים בקטגוריה';

  @override
  String get addHabitToCategory => 'הוספת הרגל';

  @override
  String get editCategory => 'עריכת קטגוריה';

  @override
  String get deleteCategory => 'מחיקת קטגוריה';

  @override
  String deleteCategoryConfirm(String name) {
    return 'למחוק את „$name”? הרגלים שכבר נמצאים בה יישמרו.';
  }

  @override
  String get otherCategory => 'אחר';

  @override
  String get loadFailed =>
      'לא הצלחנו לטעון את המשפחה. כדאי לבדוק את החיבור לאינטרנט ולנסות שוב.';

  @override
  String get tryAgain => 'לנסות שוב';

  @override
  String hiName(String name) {
    return 'היי, $name!';
  }
}
