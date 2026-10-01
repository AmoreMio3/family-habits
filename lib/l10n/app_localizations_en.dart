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

  @override
  String get welcomeTitle => 'Build good habits together';

  @override
  String get welcomeBody =>
      'Track your own habits, help your kids with theirs, and watch the family bar fill up.';

  @override
  String get imParent => 'I\'m a parent';

  @override
  String get joinWithCode => 'Join with a code';

  @override
  String get tryDemo => 'Try the demo family';

  @override
  String get signIn => 'Sign in';

  @override
  String get createAccount => 'Create account';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String passwordResetSent(String email) {
    return 'We sent a password reset link to $email.';
  }

  @override
  String get haveAccount => 'I already have an account';

  @override
  String get newHere => 'I\'m new here';

  @override
  String get errWrongPassword => 'The email or password is wrong.';

  @override
  String get errEmailInUse =>
      'An account with this email already exists. Sign in instead.';

  @override
  String get errWeakPassword => 'Use at least 6 characters for the password.';

  @override
  String get errInvalidEmail => 'Check the email address.';

  @override
  String get errCodeNotFound =>
      'This code doesn\'t exist. Check it with the parent who made it.';

  @override
  String get errCodeExpired =>
      'This code has expired. Ask a parent for a new one.';

  @override
  String get errCodeWrongKind =>
      'This code is for a different kind of join. Ask a parent for the right one.';

  @override
  String get errNeedsRecentLogin =>
      'For your safety, sign out, sign in again, then try again.';

  @override
  String get errNetwork =>
      'No internet connection. Try again when you\'re online.';

  @override
  String get errUnknown => 'Something went wrong. Try again.';

  @override
  String get setUpFamily => 'Set up your family';

  @override
  String get createFamily => 'Create a family';

  @override
  String get familyName => 'Family name';

  @override
  String get yourName => 'Your name in the family';

  @override
  String get joinFamily => 'Join my partner\'s family';

  @override
  String get inviteCode => 'Invite code';

  @override
  String get continueAction => 'Continue';

  @override
  String get enterCode => 'Enter the code shown on a parent\'s phone.';

  @override
  String get pairCode => 'Code';

  @override
  String get join => 'Join';

  @override
  String get family => 'Family';

  @override
  String get addChild => 'Add a child';

  @override
  String get inviteParent => 'Invite a parent';

  @override
  String get nickname => 'Name or nickname';

  @override
  String get ageBand => 'Age';

  @override
  String get ageUnder6 => 'Under 6';

  @override
  String get age6to9 => '6 to 9';

  @override
  String get age10to12 => '10 to 12';

  @override
  String get ageTeen => '13 to 17';

  @override
  String get ownDevice => 'Has their own phone or tablet';

  @override
  String get consentTitle => 'Parent consent';

  @override
  String get consentBody =>
      'I\'m this child\'s parent or guardian. I agree to Family Habits storing this child\'s nickname, age range and habit check-ins so our family can track habits together. I can delete this data at any time.';

  @override
  String get consentCheck => 'I agree';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get pairDevice => 'Connect a device';

  @override
  String get sharedDevice => 'Connect a shared family device';

  @override
  String get codeInstructions =>
      'On the other device, open Family Habits, tap “Join with a code” and enter this code. It works for 24 hours, once.';

  @override
  String get setPin => 'Set a PIN';

  @override
  String get removePin => 'Remove PIN';

  @override
  String get pinTitle => 'Enter PIN';

  @override
  String get pinWrong => 'Wrong PIN';

  @override
  String removeMemberConfirm(String name) {
    return 'Delete $name and all of their habits?';
  }

  @override
  String get weekStartsOn => 'Week starts on';

  @override
  String get weekStartAuto => 'Language default';

  @override
  String get signOut => 'Sign out';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteOwnerBody =>
      'This deletes your account and the whole family: every profile, habit and check-in. It can\'t be undone.';

  @override
  String get deleteParentBody =>
      'This deletes your account and your profile in this family. It can\'t be undone.';

  @override
  String get unpairDevice => 'Disconnect this device';

  @override
  String get unpairBody =>
      'This device leaves the family. A parent can connect it again with a new code.';

  @override
  String get demoBanner => 'Demo family. Changes aren\'t saved.';

  @override
  String get addHabit => 'Add habit';

  @override
  String get editHabit => 'Edit habit';

  @override
  String get habitName => 'Habit name';

  @override
  String get category => 'Category';

  @override
  String get subcategory => 'Subcategory';

  @override
  String get habitFor => 'For';

  @override
  String get wholeFamily => 'Whole family';

  @override
  String timesPerWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count times a week',
      one: 'Once a week',
    );
    return '$_temp0';
  }

  @override
  String deleteHabitConfirm(String habit) {
    return 'Delete “$habit” and its history?';
  }

  @override
  String get noHabitsYet => 'No habits yet.';

  @override
  String get members => 'Members';

  @override
  String get settings => 'Settings';

  @override
  String get everyDay => 'Every day';

  @override
  String get loadFailed =>
      'Couldn\'t load your family. Check your internet connection and try again.';

  @override
  String get tryAgain => 'Try again';
}

/// The translations for English, as used in the United Kingdom (`en_GB`).
class AppLocalizationsEnGb extends AppLocalizationsEn {
  AppLocalizationsEnGb() : super('en_GB');
}
