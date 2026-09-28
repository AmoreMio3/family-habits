import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('en', 'GB'),
    Locale('es'),
    Locale('es', '419'),
    Locale('fr'),
    Locale('he'),
    Locale('hi'),
    Locale('it'),
    Locale('pt'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// App name shown in the app bar and launcher.
  ///
  /// In en, this message translates to:
  /// **'Family Habits'**
  String get appTitle;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @familyWeek.
  ///
  /// In en, this message translates to:
  /// **'Family week'**
  String get familyWeek;

  /// No description provided for @checkInsProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} check-ins'**
  String checkInsProgress(int done, int total);

  /// No description provided for @myHabits.
  ///
  /// In en, this message translates to:
  /// **'My habits'**
  String get myHabits;

  /// No description provided for @familyHabits.
  ///
  /// In en, this message translates to:
  /// **'Family habits'**
  String get familyHabits;

  /// No description provided for @familyHabitTag.
  ///
  /// In en, this message translates to:
  /// **'Family habit'**
  String get familyHabitTag;

  /// No description provided for @checkInForFamily.
  ///
  /// In en, this message translates to:
  /// **'Check in for the family'**
  String get checkInForFamily;

  /// No description provided for @familyCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'{name} checked in “{habit}” for the whole family'**
  String familyCheckedIn(String name, String habit);

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No streak yet} =1{1 day} other{{count} days}}'**
  String streakDays(int count);

  /// No description provided for @weekTarget.
  ///
  /// In en, this message translates to:
  /// **'{done}/{target} this week'**
  String weekTarget(int done, int target);

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @phoneLanguage.
  ///
  /// In en, this message translates to:
  /// **'Phone language'**
  String get phoneLanguage;

  /// No description provided for @parent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get parent;

  /// No description provided for @child.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get child;

  /// No description provided for @switchProfile.
  ///
  /// In en, this message translates to:
  /// **'Switch profile'**
  String get switchProfile;

  /// No description provided for @catQuitBadHabit.
  ///
  /// In en, this message translates to:
  /// **'Quit a bad habit'**
  String get catQuitBadHabit;

  /// No description provided for @catArt.
  ///
  /// In en, this message translates to:
  /// **'Art'**
  String get catArt;

  /// No description provided for @catMeditate.
  ///
  /// In en, this message translates to:
  /// **'Meditate'**
  String get catMeditate;

  /// No description provided for @catStudy.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get catStudy;

  /// No description provided for @catSport.
  ///
  /// In en, this message translates to:
  /// **'Sport'**
  String get catSport;

  /// No description provided for @catEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get catEntertainment;

  /// No description provided for @catFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get catFinance;

  /// No description provided for @catHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get catHealth;

  /// No description provided for @catWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get catWork;

  /// No description provided for @catNutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get catNutrition;

  /// No description provided for @catHomeTasks.
  ///
  /// In en, this message translates to:
  /// **'Home tasks'**
  String get catHomeTasks;

  /// No description provided for @catOutdoor.
  ///
  /// In en, this message translates to:
  /// **'Outdoor activities'**
  String get catOutdoor;

  /// No description provided for @catFamilyTime.
  ///
  /// In en, this message translates to:
  /// **'Family quality time'**
  String get catFamilyTime;

  /// No description provided for @catFamilyTable.
  ///
  /// In en, this message translates to:
  /// **'Family dinner & gatherings'**
  String get catFamilyTable;

  /// No description provided for @catSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get catSleep;

  /// No description provided for @catSelfCare.
  ///
  /// In en, this message translates to:
  /// **'Self-care & hygiene'**
  String get catSelfCare;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'he',
    'hi',
    'it',
    'pt',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.countryCode) {
          case 'GB':
            return AppLocalizationsEnGb();
        }
        break;
      }
    case 'es':
      {
        switch (locale.countryCode) {
          case '419':
            return AppLocalizationsEs419();
        }
        break;
      }
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
