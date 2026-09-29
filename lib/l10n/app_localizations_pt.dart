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
  String get catArt => 'Arte e criatividade';

  @override
  String get catStudy => 'Estudos';

  @override
  String get catSport => 'Esporte';

  @override
  String get catFinance => 'Finanças';

  @override
  String get catHealth => 'Saúde';

  @override
  String get catWork => 'Trabalho';

  @override
  String get catNutrition => 'Alimentação';

  @override
  String get catHomeTasks => 'Tarefas de casa';

  @override
  String get catOutdoor => 'Atividades ao ar livre';

  @override
  String get catFamilyTime => 'Tempo em família';

  @override
  String get catSleep => 'Sono';

  @override
  String get catSelfCare => 'Autocuidado e higiene';

  @override
  String get welcomeTitle => 'Criem bons hábitos juntos';

  @override
  String get welcomeBody =>
      'Acompanhe seus hábitos, ajude seus filhos com os deles e veja a barra da família encher.';

  @override
  String get imParent => 'Sou pai ou mãe';

  @override
  String get joinWithCode => 'Entrar com um código';

  @override
  String get tryDemo => 'Experimentar a família de exemplo';

  @override
  String get signIn => 'Entrar';

  @override
  String get createAccount => 'Criar conta';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Senha';

  @override
  String get forgotPassword => 'Esqueceu a senha?';

  @override
  String passwordResetSent(String email) {
    return 'Enviamos um link para redefinir a senha para $email.';
  }

  @override
  String get haveAccount => 'Já tenho uma conta';

  @override
  String get newHere => 'Sou novo aqui';

  @override
  String get errWrongPassword => 'O e-mail ou a senha estão errados.';

  @override
  String get errEmailInUse =>
      'Já existe uma conta com este e-mail. Entre nela.';

  @override
  String get errWeakPassword => 'Use pelo menos 6 caracteres na senha.';

  @override
  String get errInvalidEmail => 'Confira o endereço de e-mail.';

  @override
  String get errCodeNotFound =>
      'Este código não existe. Confira com quem o criou.';

  @override
  String get errCodeExpired =>
      'Este código expirou. Peça um novo a um dos pais.';

  @override
  String get errCodeWrongKind =>
      'Este código é para outro tipo de acesso. Peça o código certo.';

  @override
  String get errNeedsRecentLogin =>
      'Por segurança, saia, entre de novo e tente outra vez.';

  @override
  String get errNetwork =>
      'Sem conexão com a internet. Tente de novo quando estiver on-line.';

  @override
  String get errUnknown => 'Algo deu errado. Tente de novo.';

  @override
  String get setUpFamily => 'Configure sua família';

  @override
  String get createFamily => 'Criar uma família';

  @override
  String get familyName => 'Nome da família';

  @override
  String get yourName => 'Seu nome na família';

  @override
  String get joinFamily => 'Entrar na família do meu parceiro';

  @override
  String get inviteCode => 'Código de convite';

  @override
  String get continueAction => 'Continuar';

  @override
  String get enterCode => 'Digite o código mostrado no celular de um dos pais.';

  @override
  String get pairCode => 'Código';

  @override
  String get join => 'Entrar';

  @override
  String get family => 'Família';

  @override
  String get addChild => 'Adicionar um filho ou filha';

  @override
  String get inviteParent => 'Convidar outro pai ou mãe';

  @override
  String get nickname => 'Nome ou apelido';

  @override
  String get ageBand => 'Idade';

  @override
  String get ageUnder6 => 'Menos de 6';

  @override
  String get age6to9 => '6 a 9';

  @override
  String get age10to12 => '10 a 12';

  @override
  String get ageTeen => '13 a 17';

  @override
  String get ownDevice => 'Tem o próprio celular ou tablet';

  @override
  String get consentTitle => 'Consentimento dos pais';

  @override
  String get consentBody =>
      'Sou pai, mãe ou responsável por esta criança. Concordo que o Family Habits guarde o apelido, a faixa de idade e os registros de hábitos dela para que nossa família acompanhe os hábitos juntos. Posso apagar esses dados a qualquer momento.';

  @override
  String get consentCheck => 'Concordo';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get pairDevice => 'Conectar um aparelho';

  @override
  String get sharedDevice => 'Conectar um aparelho compartilhado da família';

  @override
  String get codeInstructions =>
      'No outro aparelho, abra o Family Habits, toque em “Entrar com um código” e digite este código. Ele vale uma vez, por 24 horas.';

  @override
  String get setPin => 'Definir um PIN';

  @override
  String get removePin => 'Remover o PIN';

  @override
  String get pinTitle => 'Digite o PIN';

  @override
  String get pinWrong => 'PIN errado';

  @override
  String removeMemberConfirm(String name) {
    return 'Excluir $name e todos os hábitos?';
  }

  @override
  String get weekStartsOn => 'A semana começa em';

  @override
  String get weekStartAuto => 'Padrão do idioma';

  @override
  String get signOut => 'Sair';

  @override
  String get deleteAccount => 'Excluir conta';

  @override
  String get deleteOwnerBody =>
      'Isso exclui sua conta e a família inteira: cada perfil, hábito e registro. Não dá para desfazer.';

  @override
  String get deleteParentBody =>
      'Isso exclui sua conta e seu perfil nesta família. Não dá para desfazer.';

  @override
  String get unpairDevice => 'Desconectar este aparelho';

  @override
  String get unpairBody =>
      'Este aparelho sai da família. Um dos pais pode conectá-lo de novo com um código novo.';

  @override
  String get demoBanner => 'Família de exemplo. As mudanças não são salvas.';

  @override
  String get addHabit => 'Adicionar hábito';

  @override
  String get editHabit => 'Editar hábito';

  @override
  String get habitName => 'Nome do hábito';

  @override
  String get category => 'Categoria';

  @override
  String get habitFor => 'Para';

  @override
  String get wholeFamily => 'Família toda';

  @override
  String timesPerWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vezes por semana',
      one: 'Uma vez por semana',
    );
    return '$_temp0';
  }

  @override
  String deleteHabitConfirm(String habit) {
    return 'Excluir “$habit” e o histórico?';
  }

  @override
  String get noHabitsYet => 'Nenhum hábito ainda.';

  @override
  String get members => 'Membros';

  @override
  String get settings => 'Configurações';

  @override
  String get everyDay => 'Todo dia';

  @override
  String get catBreakHabit => 'Largar um hábito';

  @override
  String get catMindfulness => 'Mindfulness';

  @override
  String get catFamilyCare => 'Cuidado da família e dos filhos';

  @override
  String get catFamilyMeals => 'Refeições e encontros em família';

  @override
  String get catHobbies => 'Hobbies e diversão';

  @override
  String get groupSelf => 'Cuidar de mim';

  @override
  String get groupFamily => 'Cuidar da minha família';

  @override
  String get groupDaily => 'Minhas responsabilidades';

  @override
  String get groupLeisure => 'Aproveitar a vida';

  @override
  String get createMyOwnHabit => 'Criar meu próprio hábito';

  @override
  String get createMyOwnCategory => 'Criar minha própria categoria';

  @override
  String createNamedHabit(String name) {
    return 'Criar “$name” como meu hábito';
  }

  @override
  String get searchHabitsHint => 'Pesquise, por exemplo “parque” ou “livro”';

  @override
  String get noMatchingHabits =>
      'Nenhum hábito pronto corresponde. Você pode criar o seu.';

  @override
  String get ourCategories => 'Categorias da nossa família';

  @override
  String get personalDefinition => 'O que conta como feito? (opcional)';

  @override
  String get personalDefinitionHint => 'Por exemplo: bebi água suficiente hoje';

  @override
  String get categoryName => 'Nome da categoria';

  @override
  String get categoryHabits => 'Hábitos nesta categoria';

  @override
  String get addHabitToCategory => 'Adicionar um hábito';

  @override
  String get editCategory => 'Editar categoria';

  @override
  String get deleteCategory => 'Excluir categoria';

  @override
  String deleteCategoryConfirm(String name) {
    return 'Excluir “$name”? Os hábitos que já estão nela são mantidos.';
  }

  @override
  String get otherCategory => 'Outros';

  @override
  String get loadFailed =>
      'Não foi possível carregar sua família. Verifique sua conexão com a internet e tente de novo.';

  @override
  String get tryAgain => 'Tentar de novo';
}
