// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Abitudini in famiglia';

  @override
  String get today => 'Oggi';

  @override
  String get familyWeek => 'Settimana della famiglia';

  @override
  String checkInsProgress(int done, int total) {
    return '$done su $total completate';
  }

  @override
  String get myHabits => 'Le mie abitudini';

  @override
  String get familyHabits => 'Abitudini di famiglia';

  @override
  String get familyHabitTag => 'Abitudine di famiglia';

  @override
  String get checkInForFamily => 'Segna per tutta la famiglia';

  @override
  String familyCheckedIn(String name, String habit) {
    return '$name ha segnato «$habit» per tutta la famiglia';
  }

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giorni',
      one: '1 giorno',
      zero: 'Ancora nessuna serie',
    );
    return '$_temp0';
  }

  @override
  String weekTarget(int done, int target) {
    return '$done/$target questa settimana';
  }

  @override
  String get categories => 'Categorie';

  @override
  String get language => 'Lingua';

  @override
  String get phoneLanguage => 'Lingua del telefono';

  @override
  String get parent => 'Genitore';

  @override
  String get child => 'Figlio o figlia';

  @override
  String get switchProfile => 'Cambia profilo';

  @override
  String get catQuitBadHabit => 'Smettere una cattiva abitudine';

  @override
  String get catArt => 'Arte';

  @override
  String get catMeditate => 'Meditazione';

  @override
  String get catStudy => 'Studio';

  @override
  String get catSport => 'Sport';

  @override
  String get catEntertainment => 'Intrattenimento';

  @override
  String get catFinance => 'Finanze';

  @override
  String get catHealth => 'Salute';

  @override
  String get catWork => 'Lavoro';

  @override
  String get catNutrition => 'Alimentazione';

  @override
  String get catHomeTasks => 'Faccende di casa';

  @override
  String get catOutdoor => 'Attività all’aperto';

  @override
  String get catFamilyTime => 'Tempo in famiglia';

  @override
  String get catFamilyTable => 'Pasti e ritrovi in famiglia';

  @override
  String get catSleep => 'Sonno';

  @override
  String get catSelfCare => 'Cura di sé e igiene';

  @override
  String get welcomeTitle => 'Costruite buone abitudini insieme';

  @override
  String get welcomeBody =>
      'Segui le tue abitudini, aiuta i tuoi figli con le loro e guarda la barra della famiglia riempirsi.';

  @override
  String get imParent => 'Sono un genitore';

  @override
  String get joinWithCode => 'Entra con un codice';

  @override
  String get tryDemo => 'Prova la famiglia di esempio';

  @override
  String get signIn => 'Accedi';

  @override
  String get createAccount => 'Crea account';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Password dimenticata?';

  @override
  String passwordResetSent(String email) {
    return 'Abbiamo inviato un link per reimpostare la password a $email.';
  }

  @override
  String get haveAccount => 'Ho già un account';

  @override
  String get newHere => 'Sono nuovo';

  @override
  String get errWrongPassword => 'L’email o la password non sono corrette.';

  @override
  String get errEmailInUse => 'Esiste già un account con questa email. Accedi.';

  @override
  String get errWeakPassword => 'Usa almeno 6 caratteri per la password.';

  @override
  String get errInvalidEmail => 'Controlla l’indirizzo email.';

  @override
  String get errCodeNotFound =>
      'Questo codice non esiste. Verificalo con il genitore che l’ha creato.';

  @override
  String get errCodeExpired =>
      'Questo codice è scaduto. Chiedine uno nuovo a un genitore.';

  @override
  String get errCodeWrongKind =>
      'Questo codice serve per un altro tipo di accesso. Chiedi quello giusto.';

  @override
  String get errNeedsRecentLogin =>
      'Per sicurezza, esci, accedi di nuovo e riprova.';

  @override
  String get errNetwork =>
      'Nessuna connessione a internet. Riprova quando sei online.';

  @override
  String get errUnknown => 'Qualcosa è andato storto. Riprova.';

  @override
  String get setUpFamily => 'Configura la tua famiglia';

  @override
  String get createFamily => 'Crea una famiglia';

  @override
  String get familyName => 'Nome della famiglia';

  @override
  String get yourName => 'Il tuo nome in famiglia';

  @override
  String get joinFamily => 'Entra nella famiglia del mio partner';

  @override
  String get inviteCode => 'Codice di invito';

  @override
  String get continueAction => 'Continua';

  @override
  String get enterCode =>
      'Inserisci il codice mostrato sul telefono di un genitore.';

  @override
  String get pairCode => 'Codice';

  @override
  String get join => 'Entra';

  @override
  String get family => 'Famiglia';

  @override
  String get addChild => 'Aggiungi un figlio o una figlia';

  @override
  String get inviteParent => 'Invita un genitore';

  @override
  String get nickname => 'Nome o soprannome';

  @override
  String get ageBand => 'Età';

  @override
  String get ageUnder6 => 'Meno di 6';

  @override
  String get age6to9 => 'Da 6 a 9';

  @override
  String get age10to12 => 'Da 10 a 12';

  @override
  String get ageTeen => 'Da 13 a 17';

  @override
  String get ownDevice => 'Ha un proprio telefono o tablet';

  @override
  String get consentTitle => 'Consenso del genitore';

  @override
  String get consentBody =>
      'Sono il genitore o il tutore di questo bambino. Acconsento che Family Habits conservi il suo soprannome, la fascia d’età e le abitudini segnate, così la nostra famiglia può seguire le abitudini insieme. Posso eliminare questi dati in qualsiasi momento.';

  @override
  String get consentCheck => 'Acconsento';

  @override
  String get save => 'Salva';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get pairDevice => 'Collega un dispositivo';

  @override
  String get sharedDevice => 'Collega un dispositivo condiviso della famiglia';

  @override
  String get codeInstructions =>
      'Sull’altro dispositivo apri Family Habits, tocca «Entra con un codice» e inserisci questo codice. Vale una volta, per 24 ore.';

  @override
  String get setPin => 'Imposta un PIN';

  @override
  String get removePin => 'Rimuovi il PIN';

  @override
  String get pinTitle => 'Inserisci il PIN';

  @override
  String get pinWrong => 'PIN errato';

  @override
  String removeMemberConfirm(String name) {
    return 'Eliminare $name e tutte le sue abitudini?';
  }

  @override
  String get weekStartsOn => 'La settimana inizia di';

  @override
  String get weekStartAuto => 'Come la lingua';

  @override
  String get signOut => 'Esci';

  @override
  String get deleteAccount => 'Elimina account';

  @override
  String get deleteOwnerBody =>
      'Verranno eliminati il tuo account e l’intera famiglia: ogni profilo, abitudine e registrazione. Non si può annullare.';

  @override
  String get deleteParentBody =>
      'Verranno eliminati il tuo account e il tuo profilo in questa famiglia. Non si può annullare.';

  @override
  String get unpairDevice => 'Scollega questo dispositivo';

  @override
  String get unpairBody =>
      'Questo dispositivo lascia la famiglia. Un genitore può ricollegarlo con un nuovo codice.';

  @override
  String get demoBanner =>
      'Famiglia di esempio. Le modifiche non vengono salvate.';

  @override
  String get addHabit => 'Aggiungi abitudine';

  @override
  String get editHabit => 'Modifica abitudine';

  @override
  String get habitName => 'Nome dell’abitudine';

  @override
  String get category => 'Categoria';

  @override
  String get subcategory => 'Sottocategoria';

  @override
  String get habitFor => 'Per';

  @override
  String get wholeFamily => 'Tutta la famiglia';

  @override
  String timesPerWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count volte a settimana',
      one: 'Una volta a settimana',
    );
    return '$_temp0';
  }

  @override
  String deleteHabitConfirm(String habit) {
    return 'Eliminare «$habit» e la sua cronologia?';
  }

  @override
  String get noHabitsYet => 'Ancora nessuna abitudine.';

  @override
  String get members => 'Membri';

  @override
  String get settings => 'Impostazioni';

  @override
  String get everyDay => 'Ogni giorno';

  @override
  String get loadFailed =>
      'Impossibile caricare la tua famiglia. Controlla la connessione a internet e riprova.';

  @override
  String get tryAgain => 'Riprova';
}
