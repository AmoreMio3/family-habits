// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Familiengewohnheiten';

  @override
  String get today => 'Heute';

  @override
  String get familyWeek => 'Familienwoche';

  @override
  String checkInsProgress(int done, int total) {
    return '$done von $total erledigt';
  }

  @override
  String get myHabits => 'Meine Gewohnheiten';

  @override
  String get familyHabits => 'Familiengewohnheiten';

  @override
  String get familyHabitTag => 'Familiengewohnheit';

  @override
  String get checkInForFamily => 'Für die ganze Familie abhaken';

  @override
  String familyCheckedIn(String name, String habit) {
    return '$name hat „$habit“ für die ganze Familie abgehakt';
  }

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '1 Tag',
      zero: 'Noch keine Serie',
    );
    return '$_temp0';
  }

  @override
  String weekTarget(int done, int target) {
    return '$done/$target diese Woche';
  }

  @override
  String get categories => 'Kategorien';

  @override
  String get language => 'Sprache';

  @override
  String get phoneLanguage => 'Sprache des Telefons';

  @override
  String get parent => 'Elternteil';

  @override
  String get child => 'Kind';

  @override
  String get switchProfile => 'Profil wechseln';

  @override
  String get catArt => 'Kunst & Kreativität';

  @override
  String get catStudy => 'Lernen';

  @override
  String get catSport => 'Sport';

  @override
  String get catFinance => 'Finanzen';

  @override
  String get catHealth => 'Gesundheit';

  @override
  String get catWork => 'Arbeit';

  @override
  String get catNutrition => 'Ernährung';

  @override
  String get catHomeTasks => 'Haushalt';

  @override
  String get catOutdoor => 'Draußen aktiv';

  @override
  String get catFamilyTime => 'Familienzeit';

  @override
  String get catSleep => 'Schlaf';

  @override
  String get catSelfCare => 'Körperpflege & Hygiene';

  @override
  String get welcomeTitle => 'Gemeinsam gute Gewohnheiten aufbauen';

  @override
  String get welcomeBody =>
      'Verfolge deine Gewohnheiten, hilf deinen Kindern bei ihren und sieh zu, wie sich der Familienbalken füllt.';

  @override
  String get imParent => 'Ich bin ein Elternteil';

  @override
  String get joinWithCode => 'Mit einem Code beitreten';

  @override
  String get tryDemo => 'Beispielfamilie ausprobieren';

  @override
  String get signIn => 'Anmelden';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String passwordResetSent(String email) {
    return 'Wir haben einen Link zum Zurücksetzen an $email gesendet.';
  }

  @override
  String get haveAccount => 'Ich habe schon ein Konto';

  @override
  String get newHere => 'Ich bin neu hier';

  @override
  String get errWrongPassword => 'E-Mail oder Passwort ist falsch.';

  @override
  String get errEmailInUse =>
      'Mit dieser E-Mail gibt es schon ein Konto. Melde dich stattdessen an.';

  @override
  String get errWeakPassword => 'Das Passwort braucht mindestens 6 Zeichen.';

  @override
  String get errInvalidEmail => 'Prüfe die E-Mail-Adresse.';

  @override
  String get errCodeNotFound =>
      'Diesen Code gibt es nicht. Prüfe ihn mit dem Elternteil, der ihn erstellt hat.';

  @override
  String get errCodeExpired =>
      'Dieser Code ist abgelaufen. Bitte ein Elternteil um einen neuen.';

  @override
  String get errCodeWrongKind =>
      'Dieser Code ist für eine andere Art von Beitritt. Bitte um den richtigen Code.';

  @override
  String get errNeedsRecentLogin =>
      'Melde dich zur Sicherheit ab, wieder an und versuche es dann erneut.';

  @override
  String get errNetwork =>
      'Keine Internetverbindung. Versuche es erneut, wenn du online bist.';

  @override
  String get errUnknown => 'Etwas ist schiefgelaufen. Versuche es erneut.';

  @override
  String get setUpFamily => 'Familie einrichten';

  @override
  String get createFamily => 'Familie erstellen';

  @override
  String get familyName => 'Familienname';

  @override
  String get yourName => 'Dein Name in der Familie';

  @override
  String get joinFamily => 'Der Familie meines Partners beitreten';

  @override
  String get inviteCode => 'Einladungscode';

  @override
  String get continueAction => 'Weiter';

  @override
  String get enterCode =>
      'Gib den Code ein, der auf dem Telefon eines Elternteils angezeigt wird.';

  @override
  String get pairCode => 'Code';

  @override
  String get join => 'Beitreten';

  @override
  String get family => 'Familie';

  @override
  String get addChild => 'Kind hinzufügen';

  @override
  String get inviteParent => 'Elternteil einladen';

  @override
  String get nickname => 'Name oder Spitzname';

  @override
  String get ageBand => 'Alter';

  @override
  String get ageUnder6 => 'Unter 6';

  @override
  String get age6to9 => '6 bis 9';

  @override
  String get age10to12 => '10 bis 12';

  @override
  String get ageTeen => '13 bis 17';

  @override
  String get ownDevice => 'Hat ein eigenes Telefon oder Tablet';

  @override
  String get consentTitle => 'Einwilligung der Eltern';

  @override
  String get consentBody =>
      'Ich bin Elternteil oder Erziehungsberechtigte(r) dieses Kindes. Ich bin einverstanden, dass Family Habits Spitzname, Altersgruppe und abgehakte Gewohnheiten des Kindes speichert, damit unsere Familie Gewohnheiten gemeinsam verfolgen kann. Ich kann diese Daten jederzeit löschen.';

  @override
  String get consentCheck => 'Ich stimme zu';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get pairDevice => 'Gerät verbinden';

  @override
  String get sharedDevice => 'Gemeinsames Familiengerät verbinden';

  @override
  String get codeInstructions =>
      'Öffne Family Habits auf dem anderen Gerät, tippe auf „Mit einem Code beitreten“ und gib diesen Code ein. Er gilt einmal, 24 Stunden lang.';

  @override
  String get setPin => 'PIN festlegen';

  @override
  String get removePin => 'PIN entfernen';

  @override
  String get pinTitle => 'PIN eingeben';

  @override
  String get pinWrong => 'Falsche PIN';

  @override
  String removeMemberConfirm(String name) {
    return '$name und alle Gewohnheiten löschen?';
  }

  @override
  String get weekStartsOn => 'Die Woche beginnt am';

  @override
  String get weekStartAuto => 'Wie die Sprache';

  @override
  String get signOut => 'Abmelden';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get deleteOwnerBody =>
      'Dadurch werden dein Konto und die ganze Familie gelöscht: jedes Profil, jede Gewohnheit und jeder Eintrag. Das lässt sich nicht rückgängig machen.';

  @override
  String get deleteParentBody =>
      'Dadurch werden dein Konto und dein Profil in dieser Familie gelöscht. Das lässt sich nicht rückgängig machen.';

  @override
  String get unpairDevice => 'Dieses Gerät trennen';

  @override
  String get unpairBody =>
      'Dieses Gerät verlässt die Familie. Ein Elternteil kann es mit einem neuen Code wieder verbinden.';

  @override
  String get demoBanner =>
      'Beispielfamilie. Änderungen werden nicht gespeichert.';

  @override
  String get addHabit => 'Gewohnheit hinzufügen';

  @override
  String get editHabit => 'Gewohnheit bearbeiten';

  @override
  String get habitName => 'Name der Gewohnheit';

  @override
  String get category => 'Kategorie';

  @override
  String get habitFor => 'Für';

  @override
  String get wholeFamily => 'Ganze Familie';

  @override
  String timesPerWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count-mal pro Woche',
      one: 'Einmal pro Woche',
    );
    return '$_temp0';
  }

  @override
  String deleteHabitConfirm(String habit) {
    return '„$habit“ und den Verlauf löschen?';
  }

  @override
  String get noHabitsYet => 'Noch keine Gewohnheiten.';

  @override
  String get members => 'Mitglieder';

  @override
  String get settings => 'Einstellungen';

  @override
  String get everyDay => 'Jeden Tag';

  @override
  String get catBreakHabit => 'Gewohnheit ablegen';

  @override
  String get catMindfulness => 'Achtsamkeit';

  @override
  String get catFamilyCare => 'Familie & Erziehung';

  @override
  String get catFamilyMeals => 'Familienessen & Treffen';

  @override
  String get catHobbies => 'Hobbys & Spaß';

  @override
  String get groupSelf => 'Für mich sorgen';

  @override
  String get groupFamily => 'Für meine Familie sorgen';

  @override
  String get groupDaily => 'Meine Aufgaben';

  @override
  String get groupLeisure => 'Das Leben genießen';

  @override
  String get createMyOwnHabit => 'Eigene Gewohnheit erstellen';

  @override
  String get createMyOwnCategory => 'Eigene Kategorie erstellen';

  @override
  String createNamedHabit(String name) {
    return '„$name“ als eigene Gewohnheit erstellen';
  }

  @override
  String get searchHabitsHint => 'Suchen, zum Beispiel „Park“ oder „Buch“';

  @override
  String get noMatchingHabits =>
      'Keine fertige Gewohnheit passt. Du kannst deine eigene erstellen.';

  @override
  String get ourCategories => 'Kategorien unserer Familie';

  @override
  String get personalDefinition => 'Was zählt als erledigt? (optional)';

  @override
  String get personalDefinitionHint =>
      'Zum Beispiel: Ich habe heute genug Wasser getrunken';

  @override
  String get categoryName => 'Name der Kategorie';

  @override
  String get categoryHabits => 'Gewohnheiten in dieser Kategorie';

  @override
  String get addHabitToCategory => 'Gewohnheit hinzufügen';

  @override
  String get editCategory => 'Kategorie bearbeiten';

  @override
  String get deleteCategory => 'Kategorie löschen';

  @override
  String deleteCategoryConfirm(String name) {
    return '„$name“ löschen? Gewohnheiten darin bleiben erhalten.';
  }

  @override
  String get otherCategory => 'Sonstiges';
}
