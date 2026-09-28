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

  @override
  String get welcomeTitle => 'Crear buenos hábitos juntos';

  @override
  String get welcomeBody =>
      'Sigue tus hábitos, ayuda a tus hijos con los suyos y mira cómo se llena la barra familiar.';

  @override
  String get imParent => 'Soy padre o madre';

  @override
  String get joinWithCode => 'Unirme con un código';

  @override
  String get tryDemo => 'Probar la familia de ejemplo';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get forgotPassword => '¿Has olvidado la contraseña?';

  @override
  String passwordResetSent(String email) {
    return 'Hemos enviado un enlace para restablecer la contraseña a $email.';
  }

  @override
  String get haveAccount => 'Ya tengo una cuenta';

  @override
  String get newHere => 'Soy nuevo';

  @override
  String get errWrongPassword => 'El correo o la contraseña no son correctos.';

  @override
  String get errEmailInUse =>
      'Ya existe una cuenta con este correo. Inicia sesión.';

  @override
  String get errWeakPassword => 'Usa al menos 6 caracteres en la contraseña.';

  @override
  String get errInvalidEmail => 'Revisa la dirección de correo.';

  @override
  String get errCodeNotFound =>
      'Este código no existe. Compruébalo con quien lo creó.';

  @override
  String get errCodeExpired =>
      'Este código ha caducado. Pide uno nuevo a un padre o madre.';

  @override
  String get errCodeWrongKind =>
      'Este código es para otro tipo de acceso. Pide el correcto.';

  @override
  String get errNeedsRecentLogin =>
      'Por seguridad, cierra sesión, vuelve a entrar e inténtalo de nuevo.';

  @override
  String get errNetwork =>
      'No hay conexión a internet. Inténtalo cuando estés en línea.';

  @override
  String get errUnknown => 'Algo ha fallado. Inténtalo de nuevo.';

  @override
  String get setUpFamily => 'Configura tu familia';

  @override
  String get createFamily => 'Crear una familia';

  @override
  String get familyName => 'Nombre de la familia';

  @override
  String get yourName => 'Tu nombre en la familia';

  @override
  String get joinFamily => 'Unirme a la familia de mi pareja';

  @override
  String get inviteCode => 'Código de invitación';

  @override
  String get continueAction => 'Continuar';

  @override
  String get enterCode =>
      'Escribe el código que aparece en el teléfono de un padre o madre.';

  @override
  String get pairCode => 'Código';

  @override
  String get join => 'Unirme';

  @override
  String get family => 'Familia';

  @override
  String get addChild => 'Añadir un hijo o hija';

  @override
  String get inviteParent => 'Invitar a otro padre o madre';

  @override
  String get nickname => 'Nombre o apodo';

  @override
  String get ageBand => 'Edad';

  @override
  String get ageUnder6 => 'Menos de 6';

  @override
  String get age6to9 => '6 a 9';

  @override
  String get age10to12 => '10 a 12';

  @override
  String get ageTeen => '13 a 17';

  @override
  String get ownDevice => 'Tiene su propio teléfono o tableta';

  @override
  String get consentTitle => 'Consentimiento parental';

  @override
  String get consentBody =>
      'Soy el padre, la madre o el tutor de este niño. Acepto que Family Habits guarde su apodo, su franja de edad y sus registros de hábitos para que nuestra familia siga sus hábitos juntos. Puedo borrar estos datos en cualquier momento.';

  @override
  String get consentCheck => 'Acepto';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get pairDevice => 'Conectar un dispositivo';

  @override
  String get sharedDevice => 'Conectar un dispositivo familiar compartido';

  @override
  String get codeInstructions =>
      'En el otro dispositivo, abre Family Habits, toca «Unirme con un código» e introduce este código. Sirve una sola vez durante 24 horas.';

  @override
  String get setPin => 'Poner un PIN';

  @override
  String get removePin => 'Quitar el PIN';

  @override
  String get pinTitle => 'Introduce el PIN';

  @override
  String get pinWrong => 'PIN incorrecto';

  @override
  String removeMemberConfirm(String name) {
    return '¿Eliminar a $name y todos sus hábitos?';
  }

  @override
  String get weekStartsOn => 'La semana empieza el';

  @override
  String get weekStartAuto => 'Según el idioma';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteOwnerBody =>
      'Se eliminarán tu cuenta y toda la familia: cada perfil, hábito y registro. No se puede deshacer.';

  @override
  String get deleteParentBody =>
      'Se eliminarán tu cuenta y tu perfil en esta familia. No se puede deshacer.';

  @override
  String get unpairDevice => 'Desconectar este dispositivo';

  @override
  String get unpairBody =>
      'Este dispositivo saldrá de la familia. Un padre o madre puede volver a conectarlo con un código nuevo.';

  @override
  String get demoBanner => 'Familia de ejemplo. Los cambios no se guardan.';

  @override
  String get addHabit => 'Añadir hábito';

  @override
  String get editHabit => 'Editar hábito';

  @override
  String get habitName => 'Nombre del hábito';

  @override
  String get category => 'Categoría';

  @override
  String get subcategory => 'Subcategoría';

  @override
  String get habitFor => 'Para';

  @override
  String get wholeFamily => 'Toda la familia';

  @override
  String timesPerWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count veces a la semana',
      one: 'Una vez a la semana',
    );
    return '$_temp0';
  }

  @override
  String deleteHabitConfirm(String habit) {
    return '¿Eliminar «$habit» y su historial?';
  }

  @override
  String get noHabitsYet => 'Aún no hay hábitos.';

  @override
  String get members => 'Miembros';

  @override
  String get settings => 'Ajustes';

  @override
  String get everyDay => 'Todos los días';
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

  @override
  String get imParent => 'Soy papá o mamá';

  @override
  String get forgotPassword => '¿Olvidaste la contraseña?';

  @override
  String passwordResetSent(String email) {
    return 'Enviamos un enlace para restablecer la contraseña a $email.';
  }

  @override
  String get errEmailInUse =>
      'Ya existe una cuenta con este correo. Inicia sesión.';

  @override
  String get errCodeExpired =>
      'Este código venció. Pide uno nuevo a un papá o mamá.';

  @override
  String get errCodeWrongKind =>
      'Este código es para otro tipo de acceso. Pide el correcto.';

  @override
  String get errUnknown => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get enterCode =>
      'Escribe el código que aparece en el celular de un papá o mamá.';

  @override
  String get addChild => 'Agregar un hijo o hija';

  @override
  String get inviteParent => 'Invitar a otro papá o mamá';

  @override
  String get ownDevice => 'Tiene su propio celular o tableta';

  @override
  String get codeInstructions =>
      'En el otro dispositivo, abre Family Habits, toca «Unirme con un código» e ingresa este código. Sirve una sola vez durante 24 horas.';

  @override
  String get pinTitle => 'Ingresa el PIN';

  @override
  String get unpairBody =>
      'Este dispositivo saldrá de la familia. Un papá o mamá puede volver a conectarlo con un código nuevo.';

  @override
  String get addHabit => 'Agregar hábito';

  @override
  String get settings => 'Configuración';
}
