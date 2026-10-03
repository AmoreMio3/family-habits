// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Habitudes en famille';

  @override
  String get today => 'Aujourd’hui';

  @override
  String get familyWeek => 'Semaine de la famille';

  @override
  String checkInsProgress(int done, int total) {
    return '$done sur $total validations';
  }

  @override
  String get myHabits => 'Mes habitudes';

  @override
  String get familyHabits => 'Habitudes familiales';

  @override
  String get familyHabitTag => 'Habitude familiale';

  @override
  String get checkInForFamily => 'Valider pour toute la famille';

  @override
  String familyCheckedIn(String name, String habit) {
    return '$name a validé « $habit » pour toute la famille';
  }

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
      zero: 'Pas encore de série',
    );
    return '$_temp0';
  }

  @override
  String weekTarget(int done, int target) {
    return '$done/$target cette semaine';
  }

  @override
  String get categories => 'Catégories';

  @override
  String get language => 'Langue';

  @override
  String get phoneLanguage => 'Langue du téléphone';

  @override
  String get parent => 'Parent';

  @override
  String get child => 'Enfant';

  @override
  String get switchProfile => 'Changer de profil';

  @override
  String get catArt => 'Art et créativité';

  @override
  String get catStudy => 'Études';

  @override
  String get catSport => 'Sport';

  @override
  String get catFinance => 'Finances';

  @override
  String get catHealth => 'Santé';

  @override
  String get catWork => 'Travail';

  @override
  String get catNutrition => 'Alimentation';

  @override
  String get catHomeTasks => 'Tâches ménagères';

  @override
  String get catOutdoor => 'Activités en plein air';

  @override
  String get catFamilyTime => 'Moments en famille';

  @override
  String get catSleep => 'Sommeil';

  @override
  String get catSelfCare => 'Soins personnels et hygiène';

  @override
  String get welcomeTitle => 'Prenez de bonnes habitudes ensemble';

  @override
  String get welcomeBody =>
      'Suivez vos habitudes, aidez vos enfants avec les leurs et regardez la barre familiale se remplir.';

  @override
  String get imParent => 'Je suis parent';

  @override
  String get joinWithCode => 'Rejoindre avec un code';

  @override
  String get tryDemo => 'Essayer la famille exemple';

  @override
  String get signIn => 'Se connecter';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String passwordResetSent(String email) {
    return 'Nous avons envoyé un lien de réinitialisation à $email.';
  }

  @override
  String get haveAccount => 'J’ai déjà un compte';

  @override
  String get newHere => 'Je suis nouveau';

  @override
  String get errWrongPassword => 'L’e-mail ou le mot de passe est incorrect.';

  @override
  String get errEmailInUse =>
      'Un compte existe déjà avec cet e-mail. Connectez-vous plutôt.';

  @override
  String get errWeakPassword =>
      'Utilisez au moins 6 caractères pour le mot de passe.';

  @override
  String get errInvalidEmail => 'Vérifiez l’adresse e-mail.';

  @override
  String get errCodeNotFound =>
      'Ce code n’existe pas. Vérifiez-le avec le parent qui l’a créé.';

  @override
  String get errCodeExpired =>
      'Ce code a expiré. Demandez-en un nouveau à un parent.';

  @override
  String get errCodeWrongKind =>
      'Ce code sert à un autre type d’accès. Demandez le bon code à un parent.';

  @override
  String get errNeedsRecentLogin =>
      'Par sécurité, déconnectez-vous, reconnectez-vous, puis réessayez.';

  @override
  String get errNetwork =>
      'Pas de connexion internet. Réessayez une fois en ligne.';

  @override
  String get errUnknown => 'Un problème est survenu. Réessayez.';

  @override
  String get setUpFamily => 'Configurez votre famille';

  @override
  String get createFamily => 'Créer une famille';

  @override
  String get familyName => 'Nom de la famille';

  @override
  String get yourName => 'Votre nom dans la famille';

  @override
  String get joinFamily => 'Rejoindre la famille de mon conjoint';

  @override
  String get inviteCode => 'Code d’invitation';

  @override
  String get continueAction => 'Continuer';

  @override
  String get enterCode =>
      'Saisissez le code affiché sur le téléphone d’un parent.';

  @override
  String get pairCode => 'Code';

  @override
  String get join => 'Rejoindre';

  @override
  String get family => 'Famille';

  @override
  String get addChild => 'Ajouter un enfant';

  @override
  String get inviteParent => 'Inviter un parent';

  @override
  String get nickname => 'Prénom ou surnom';

  @override
  String get ageBand => 'Âge';

  @override
  String get ageUnder6 => 'Moins de 6 ans';

  @override
  String get age6to9 => '6 à 9 ans';

  @override
  String get age10to12 => '10 à 12 ans';

  @override
  String get ageTeen => '13 à 17 ans';

  @override
  String get ownDevice => 'A son propre téléphone ou sa tablette';

  @override
  String get consentTitle => 'Consentement parental';

  @override
  String get consentBody =>
      'Je suis le parent ou le tuteur de cet enfant. J’accepte que Family Habits enregistre son surnom, sa tranche d’âge et ses validations d’habitudes pour que notre famille suive ses habitudes ensemble. Je peux supprimer ces données à tout moment.';

  @override
  String get consentCheck => 'J’accepte';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get pairDevice => 'Connecter un appareil';

  @override
  String get sharedDevice => 'Connecter un appareil familial partagé';

  @override
  String get codeInstructions =>
      'Sur l’autre appareil, ouvrez Family Habits, touchez « Rejoindre avec un code » et saisissez ce code. Il fonctionne une fois, pendant 24 heures.';

  @override
  String get setPin => 'Définir un code PIN';

  @override
  String get removePin => 'Supprimer le code PIN';

  @override
  String get pinTitle => 'Saisissez le code PIN';

  @override
  String get pinWrong => 'Code PIN incorrect';

  @override
  String removeMemberConfirm(String name) {
    return 'Supprimer $name et toutes ses habitudes ?';
  }

  @override
  String get weekStartsOn => 'La semaine commence le';

  @override
  String get weekStartAuto => 'Selon la langue';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteOwnerBody =>
      'Votre compte et toute la famille seront supprimés : chaque profil, habitude et validation. Action irréversible.';

  @override
  String get deleteParentBody =>
      'Votre compte et votre profil dans cette famille seront supprimés. Action irréversible.';

  @override
  String get unpairDevice => 'Déconnecter cet appareil';

  @override
  String get unpairBody =>
      'Cet appareil quitte la famille. Un parent peut le reconnecter avec un nouveau code.';

  @override
  String get demoBanner =>
      'Famille exemple. Les modifications ne sont pas enregistrées.';

  @override
  String get addHabit => 'Ajouter une habitude';

  @override
  String get editHabit => 'Modifier l’habitude';

  @override
  String get habitName => 'Nom de l’habitude';

  @override
  String get category => 'Catégorie';

  @override
  String get habitFor => 'Pour';

  @override
  String get wholeFamily => 'Toute la famille';

  @override
  String timesPerWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fois par semaine',
      one: 'Une fois par semaine',
    );
    return '$_temp0';
  }

  @override
  String deleteHabitConfirm(String habit) {
    return 'Supprimer « $habit » et son historique ?';
  }

  @override
  String get noHabitsYet => 'Pas encore d’habitudes.';

  @override
  String get members => 'Membres';

  @override
  String get settings => 'Réglages';

  @override
  String get everyDay => 'Tous les jours';

  @override
  String get catBreakHabit => 'Arrêter une habitude';

  @override
  String get catMindfulness => 'Pleine conscience';

  @override
  String get catFamilyCare => 'Famille et parentalité';

  @override
  String get catFamilyMeals => 'Repas et réunions de famille';

  @override
  String get catHobbies => 'Loisirs et détente';

  @override
  String get groupSelf => 'Prendre soin de moi';

  @override
  String get groupFamily => 'Prendre soin de ma famille';

  @override
  String get groupDaily => 'Mes responsabilités';

  @override
  String get groupLeisure => 'Profiter de la vie';

  @override
  String get createMyOwnHabit => 'Créer ma propre habitude';

  @override
  String get createMyOwnCategory => 'Créer ma propre catégorie';

  @override
  String createNamedHabit(String name) {
    return 'Créer « $name » comme habitude';
  }

  @override
  String get searchHabitsHint =>
      'Rechercher, par exemple « parc » ou « livre »';

  @override
  String get noMatchingHabits =>
      'Aucune habitude toute faite ne correspond. Vous pouvez créer la vôtre.';

  @override
  String get ourCategories => 'Les catégories de notre famille';

  @override
  String get personalDefinition =>
      'Qu\'est-ce qui compte comme fait ? (facultatif)';

  @override
  String get personalDefinitionHint =>
      'Par exemple : j\'ai bu assez d\'eau aujourd\'hui';

  @override
  String get categoryName => 'Nom de la catégorie';

  @override
  String get categoryHabits => 'Habitudes de cette catégorie';

  @override
  String get addHabitToCategory => 'Ajouter une habitude';

  @override
  String get editCategory => 'Modifier la catégorie';

  @override
  String get deleteCategory => 'Supprimer la catégorie';

  @override
  String deleteCategoryConfirm(String name) {
    return 'Supprimer « $name » ? Les habitudes qu\'elle contient sont conservées.';
  }

  @override
  String get otherCategory => 'Autre';

  @override
  String get loadFailed =>
      'Impossible de charger votre famille. Vérifiez votre connexion internet et réessayez.';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String hiName(String name) {
    return 'Salut, $name !';
  }
}
