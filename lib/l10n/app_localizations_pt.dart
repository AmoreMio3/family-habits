// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Hábitos em Família';

  @override
  String get today => 'Hoje';

  @override
  String get familyWeek => 'Semana da família';

  @override
  String checkInsProgress(int done, int total) {
    return '$done de $total registros';
  }

  @override
  String get myHabits => 'Meus hábitos';

  @override
  String get familyHabits => 'Hábitos da família';

  @override
  String get familyHabitTag => 'Hábito da família';

  @override
  String get checkInForFamily => 'Registrar para a família toda';

  @override
  String familyCheckedIn(String name, String habit) {
    return '$name registrou “$habit” para a família toda';
  }

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias',
      one: '1 dia',
      zero: 'Nenhuma sequência ainda',
    );
    return '$_temp0';
  }

  @override
  String weekTarget(int done, int target) {
    return '$done/$target nesta semana';
  }

  @override
  String get categories => 'Categorias';

  @override
  String get language => 'Idioma';

  @override
  String get phoneLanguage => 'Idioma do celular';

  @override
  String get parent => 'Pai ou mãe';

  @override
  String get child => 'Filho ou filha';

  @override
  String get switchProfile => 'Trocar de perfil';

  @override
  String get catQuitBadHabit => 'Largar um mau hábito';

  @override
  String get catArt => 'Arte';

  @override
  String get catMeditate => 'Meditar';

  @override
  String get catStudy => 'Estudos';

  @override
  String get catSport => 'Esporte';

  @override
  String get catEntertainment => 'Entretenimento';

  @override
  String get catFinance => 'Finanças';

  @override
  String get catHealth => 'Saúde';

  @override
  String get catWork => 'Trabalho';

  @override
  String get catNutrition => 'Nutrição';

  @override
  String get catHomeTasks => 'Tarefas de casa';

  @override
  String get catOutdoor => 'Atividades ao ar livre';

  @override
  String get catFamilyTime => 'Tempo em família';

  @override
  String get catFamilyTable => 'Refeições e encontros em família';

  @override
  String get catSleep => 'Sono';

  @override
  String get catSelfCare => 'Autocuidado e higiene';
}
