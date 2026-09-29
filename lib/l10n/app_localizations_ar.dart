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
  String get catArt => 'الفن والإبداع';

  @override
  String get catStudy => 'الدراسة';

  @override
  String get catSport => 'الرياضة';

  @override
  String get catFinance => 'المال';

  @override
  String get catHealth => 'الصحة';

  @override
  String get catWork => 'العمل';

  @override
  String get catNutrition => 'التغذية';

  @override
  String get catHomeTasks => 'مهام المنزل';

  @override
  String get catOutdoor => 'أنشطة خارجية';

  @override
  String get catFamilyTime => 'وقت العائلة';

  @override
  String get catSleep => 'النوم';

  @override
  String get catSelfCare => 'العناية الشخصية والنظافة';

  @override
  String get welcomeTitle => 'لنبنِ عادات جيدة معًا';

  @override
  String get welcomeBody =>
      'تابع عاداتك، وساعد أطفالك في عاداتهم، وشاهد شريط العائلة وهو يمتلئ.';

  @override
  String get imParent => 'أنا ولي أمر';

  @override
  String get joinWithCode => 'الانضمام برمز';

  @override
  String get tryDemo => 'تجربة العائلة النموذجية';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String passwordResetSent(String email) {
    return 'أرسلنا رابط إعادة تعيين كلمة المرور إلى $email.';
  }

  @override
  String get haveAccount => 'لدي حساب بالفعل';

  @override
  String get newHere => 'أنا جديد هنا';

  @override
  String get errWrongPassword => 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get errEmailInUse =>
      'يوجد حساب بهذا البريد الإلكتروني. سجّل الدخول بدلًا من ذلك.';

  @override
  String get errWeakPassword => 'استخدم 6 أحرف على الأقل في كلمة المرور.';

  @override
  String get errInvalidEmail => 'تحقق من عنوان البريد الإلكتروني.';

  @override
  String get errCodeNotFound =>
      'هذا الرمز غير موجود. تحقق منه مع ولي الأمر الذي أنشأه.';

  @override
  String get errCodeExpired =>
      'انتهت صلاحية هذا الرمز. اطلب رمزًا جديدًا من ولي الأمر.';

  @override
  String get errCodeWrongKind =>
      'هذا الرمز لنوع آخر من الانضمام. اطلب الرمز الصحيح من ولي الأمر.';

  @override
  String get errNeedsRecentLogin =>
      'لأمانك، سجّل الخروج ثم الدخول مرة أخرى، وحاول من جديد.';

  @override
  String get errNetwork =>
      'لا يوجد اتصال بالإنترنت. حاول مرة أخرى عند الاتصال.';

  @override
  String get errUnknown => 'حدث خطأ ما. حاول مرة أخرى.';

  @override
  String get setUpFamily => 'إعداد عائلتك';

  @override
  String get createFamily => 'إنشاء عائلة';

  @override
  String get familyName => 'اسم العائلة';

  @override
  String get yourName => 'اسمك في العائلة';

  @override
  String get joinFamily => 'الانضمام إلى عائلة شريك حياتي';

  @override
  String get inviteCode => 'رمز الدعوة';

  @override
  String get continueAction => 'متابعة';

  @override
  String get enterCode => 'أدخل الرمز الظاهر على هاتف ولي الأمر.';

  @override
  String get pairCode => 'الرمز';

  @override
  String get join => 'انضمام';

  @override
  String get family => 'العائلة';

  @override
  String get addChild => 'إضافة طفل';

  @override
  String get inviteParent => 'دعوة ولي أمر آخر';

  @override
  String get nickname => 'الاسم أو اللقب';

  @override
  String get ageBand => 'العمر';

  @override
  String get ageUnder6 => 'أقل من 6';

  @override
  String get age6to9 => 'من 6 إلى 9';

  @override
  String get age10to12 => 'من 10 إلى 12';

  @override
  String get ageTeen => 'من 13 إلى 17';

  @override
  String get ownDevice => 'لديه هاتف أو جهاز لوحي خاص';

  @override
  String get consentTitle => 'موافقة ولي الأمر';

  @override
  String get consentBody =>
      'أنا والد هذا الطفل أو وصيّه. أوافق على أن يحفظ Family Habits لقب الطفل وفئته العمرية وتسجيلات عاداته حتى تتابع عائلتنا العادات معًا. يمكنني حذف هذه البيانات في أي وقت.';

  @override
  String get consentCheck => 'أوافق';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get pairDevice => 'ربط جهاز';

  @override
  String get sharedDevice => 'ربط جهاز عائلي مشترك';

  @override
  String get codeInstructions =>
      'على الجهاز الآخر، افتح Family Habits، واضغط «الانضمام برمز» وأدخل هذا الرمز. يعمل مرة واحدة خلال 24 ساعة.';

  @override
  String get setPin => 'تعيين رمز PIN';

  @override
  String get removePin => 'إزالة رمز PIN';

  @override
  String get pinTitle => 'أدخل رمز PIN';

  @override
  String get pinWrong => 'رمز PIN غير صحيح';

  @override
  String removeMemberConfirm(String name) {
    return 'هل تريد حذف $name وجميع عاداته؟';
  }

  @override
  String get weekStartsOn => 'يبدأ الأسبوع يوم';

  @override
  String get weekStartAuto => 'حسب اللغة';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get deleteOwnerBody =>
      'سيؤدي هذا إلى حذف حسابك والعائلة كلها: كل ملف شخصي وعادة وتسجيل. لا يمكن التراجع عن ذلك.';

  @override
  String get deleteParentBody =>
      'سيؤدي هذا إلى حذف حسابك وملفك الشخصي في هذه العائلة. لا يمكن التراجع عن ذلك.';

  @override
  String get unpairDevice => 'فصل هذا الجهاز';

  @override
  String get unpairBody =>
      'سيغادر هذا الجهاز العائلة. يمكن لولي الأمر ربطه مرة أخرى برمز جديد.';

  @override
  String get demoBanner => 'عائلة نموذجية. لا يتم حفظ التغييرات.';

  @override
  String get addHabit => 'إضافة عادة';

  @override
  String get editHabit => 'تعديل العادة';

  @override
  String get habitName => 'اسم العادة';

  @override
  String get category => 'الفئة';

  @override
  String get habitFor => 'لمن';

  @override
  String get wholeFamily => 'العائلة كلها';

  @override
  String timesPerWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مرة في الأسبوع',
      many: '$count مرة في الأسبوع',
      few: '$count مرات في الأسبوع',
      two: 'مرتان في الأسبوع',
      one: 'مرة في الأسبوع',
    );
    return '$_temp0';
  }

  @override
  String deleteHabitConfirm(String habit) {
    return 'هل تريد حذف «$habit» وسجله؟';
  }

  @override
  String get noHabitsYet => 'لا توجد عادات بعد.';

  @override
  String get members => 'الأعضاء';

  @override
  String get settings => 'الإعدادات';

  @override
  String get everyDay => 'كل يوم';

  @override
  String get catBreakHabit => 'ترك عادة';

  @override
  String get catMindfulness => 'اليقظة الذهنية';

  @override
  String get catFamilyCare => 'رعاية الأسرة والأبناء';

  @override
  String get catFamilyMeals => 'الوجبات واللقاءات العائلية';

  @override
  String get catHobbies => 'الهوايات والمرح';

  @override
  String get groupSelf => 'أعتني بنفسي';

  @override
  String get groupFamily => 'أعتني بعائلتي';

  @override
  String get groupDaily => 'مسؤولياتي';

  @override
  String get groupLeisure => 'أستمتع بحياتي';

  @override
  String get createMyOwnHabit => 'إنشاء عادة خاصة بي';

  @override
  String get createMyOwnCategory => 'إنشاء فئة خاصة بي';

  @override
  String createNamedHabit(String name) {
    return 'إنشاء «$name» كعادة خاصة بي';
  }

  @override
  String get searchHabitsHint => 'ابحث، مثلًا «حديقة» أو «كتاب»';

  @override
  String get noMatchingHabits =>
      'لا توجد عادة جاهزة مطابقة. يمكنك إنشاء عادتك.';

  @override
  String get ourCategories => 'فئات عائلتنا';

  @override
  String get personalDefinition => 'ما الذي يُعدّ إنجازًا؟ (اختياري)';

  @override
  String get personalDefinitionHint => 'مثلًا: شربت ما يكفي من الماء اليوم';

  @override
  String get categoryName => 'اسم الفئة';

  @override
  String get categoryHabits => 'العادات في هذه الفئة';

  @override
  String get addHabitToCategory => 'إضافة عادة';

  @override
  String get editCategory => 'تعديل الفئة';

  @override
  String get deleteCategory => 'حذف الفئة';

  @override
  String deleteCategoryConfirm(String name) {
    return 'حذف «$name»؟ ستبقى العادات الموجودة فيها.';
  }

  @override
  String get otherCategory => 'أخرى';
}
