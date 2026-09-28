// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Hábitos en Familia';

  @override
  String get today => 'Hoy';

  @override
  String get familyWeek => 'Semana familiar';

  @override
  String checkInsProgress(int done, int total) {
    return '$done de $total registros';
  }

  @override
  String get myHabits => 'Mis hábitos';

  @override
  String get familyHabits => 'Hábitos familiares';

  @override
  String get familyHabitTag => 'Hábito familiar';

  @override
  String get checkInForFamily => 'Registrar para toda la familia';

  @override
  String familyCheckedIn(String name, String habit) {
    return '$name ha registrado «$habit» para toda la familia';
  }

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '1 día',
      zero: 'Aún sin racha',
    );
    return '$_temp0';
  }

  @override
  String weekTarget(int done, int target) {
    return '$done/$target esta semana';
  }

  @override
  String get categories => 'Categorías';

  @override
  String get language => 'Idioma';

  @override
  String get phoneLanguage => 'Idioma del teléfono';

  @override
  String get parent => 'Padre o madre';

  @override
  String get child => 'Hijo o hija';

  @override
  String get switchProfile => 'Cambiar de perfil';

  @override
  String get catQuitBadHabit => 'Dejar un mal hábito';

  @override
  String get catArt => 'Arte';

  @override
  String get catMeditate => 'Meditar';

  @override
  String get catStudy => 'Estudio';

  @override
  String get catSport => 'Deporte';

  @override
  String get catEntertainment => 'Entretenimiento';

  @override
  String get catFinance => 'Finanzas';

  @override
  String get catHealth => 'Salud';

  @override
  String get catWork => 'Trabajo';

  @override
  String get catNutrition => 'Nutrición';

  @override
  String get catHomeTasks => 'Tareas del hogar';

  @override
  String get catOutdoor => 'Actividades al aire libre';

  @override
  String get catFamilyTime => 'Tiempo en familia';

  @override
  String get catFamilyTable => 'Comidas y reuniones familiares';

  @override
  String get catSleep => 'Sueño';

  @override
  String get catSelfCare => 'Cuidado personal e higiene';
}

/// The translations for Spanish Castilian, as used in Latin America and the Caribbean (`es_419`).
class AppLocalizationsEs419 extends AppLocalizationsEs {
  AppLocalizationsEs419() : super('es_419');

  @override
  String familyCheckedIn(String name, String habit) {
    return '$name registró «$habit» para toda la familia';
  }

  @override
  String get phoneLanguage => 'Idioma del celular';

  @override
  String get catHomeTasks => 'Tareas de la casa';
}
