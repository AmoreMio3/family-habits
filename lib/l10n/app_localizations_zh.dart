// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '家庭习惯';

  @override
  String get today => '今天';

  @override
  String get familyWeek => '家庭本周';

  @override
  String checkInsProgress(int done, int total) {
    return '已打卡 $done/$total';
  }

  @override
  String get myHabits => '我的习惯';

  @override
  String get familyHabits => '家庭习惯';

  @override
  String get familyHabitTag => '家庭习惯';

  @override
  String get checkInForFamily => '为全家打卡';

  @override
  String familyCheckedIn(String name, String habit) {
    return '$name 已为全家完成“$habit”打卡';
  }

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '连续 $count 天',
      zero: '尚无连续记录',
    );
    return '$_temp0';
  }

  @override
  String weekTarget(int done, int target) {
    return '本周 $done/$target';
  }

  @override
  String get categories => '分类';

  @override
  String get language => '语言';

  @override
  String get phoneLanguage => '跟随手机语言';

  @override
  String get parent => '家长';

  @override
  String get child => '孩子';

  @override
  String get switchProfile => '切换成员';

  @override
  String get catArt => '艺术与创意';

  @override
  String get catStudy => '学习';

  @override
  String get catSport => '运动';

  @override
  String get catFinance => '理财';

  @override
  String get catHealth => '健康';

  @override
  String get catWork => '工作';

  @override
  String get catNutrition => '营养';

  @override
  String get catHomeTasks => '家务';

  @override
  String get catOutdoor => '户外活动';

  @override
  String get catFamilyTime => '家庭时光';

  @override
  String get catSleep => '睡眠';

  @override
  String get catSelfCare => '个人护理与卫生';

  @override
  String get welcomeTitle => '一起养成好习惯';

  @override
  String get welcomeBody => '记录自己的习惯，帮孩子坚持他们的习惯，看着家庭进度条一点点填满。';

  @override
  String get imParent => '我是家长';

  @override
  String get joinWithCode => '用邀请码加入';

  @override
  String get tryDemo => '试用示例家庭';

  @override
  String get signIn => '登录';

  @override
  String get createAccount => '创建账号';

  @override
  String get email => '邮箱';

  @override
  String get password => '密码';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String passwordResetSent(String email) {
    return '我们已向 $email 发送重置密码的链接。';
  }

  @override
  String get haveAccount => '我已有账号';

  @override
  String get newHere => '我是新用户';

  @override
  String get errWrongPassword => '邮箱或密码不正确。';

  @override
  String get errEmailInUse => '该邮箱已注册账号，请直接登录。';

  @override
  String get errWeakPassword => '密码至少需要 6 个字符。';

  @override
  String get errInvalidEmail => '请检查邮箱地址。';

  @override
  String get errCodeNotFound => '此代码不存在，请向创建它的家长核对。';

  @override
  String get errCodeExpired => '此代码已过期，请向家长索取新代码。';

  @override
  String get errCodeWrongKind => '此代码用于其他加入方式，请向家长索取正确的代码。';

  @override
  String get errNeedsRecentLogin => '为了安全，请退出后重新登录，再试一次。';

  @override
  String get errNetwork => '没有网络连接，请联网后再试。';

  @override
  String get errUnknown => '出了点问题，请再试一次。';

  @override
  String get setUpFamily => '设置你的家庭';

  @override
  String get createFamily => '创建家庭';

  @override
  String get familyName => '家庭名称';

  @override
  String get yourName => '你在家里的称呼';

  @override
  String get joinFamily => '加入伴侣的家庭';

  @override
  String get inviteCode => '邀请码';

  @override
  String get continueAction => '继续';

  @override
  String get enterCode => '输入家长手机上显示的代码。';

  @override
  String get pairCode => '代码';

  @override
  String get join => '加入';

  @override
  String get family => '家庭';

  @override
  String get addChild => '添加孩子';

  @override
  String get inviteParent => '邀请另一位家长';

  @override
  String get nickname => '名字或昵称';

  @override
  String get ageBand => '年龄';

  @override
  String get ageUnder6 => '6 岁以下';

  @override
  String get age6to9 => '6 到 9 岁';

  @override
  String get age10to12 => '10 到 12 岁';

  @override
  String get ageTeen => '13 到 17 岁';

  @override
  String get ownDevice => '有自己的手机或平板';

  @override
  String get consentTitle => '家长同意';

  @override
  String get consentBody =>
      '我是这个孩子的家长或监护人。我同意 Family Habits 保存孩子的昵称、年龄段和习惯打卡记录，以便我们全家一起记录习惯。我可以随时删除这些数据。';

  @override
  String get consentCheck => '我同意';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get pairDevice => '连接设备';

  @override
  String get sharedDevice => '连接家庭共用设备';

  @override
  String get codeInstructions =>
      '在另一台设备上打开 Family Habits，点按“用邀请码加入”并输入此代码。代码 24 小时内有效，只能使用一次。';

  @override
  String get setPin => '设置 PIN 码';

  @override
  String get removePin => '移除 PIN 码';

  @override
  String get pinTitle => '输入 PIN 码';

  @override
  String get pinWrong => 'PIN 码错误';

  @override
  String removeMemberConfirm(String name) {
    return '删除 $name 及其所有习惯？';
  }

  @override
  String get weekStartsOn => '每周开始于';

  @override
  String get weekStartAuto => '跟随语言';

  @override
  String get signOut => '退出登录';

  @override
  String get deleteAccount => '删除账号';

  @override
  String get deleteOwnerBody => '这将删除你的账号和整个家庭：所有成员、习惯和打卡记录，且无法恢复。';

  @override
  String get deleteParentBody => '这将删除你的账号以及你在这个家庭中的资料，且无法恢复。';

  @override
  String get unpairDevice => '断开此设备';

  @override
  String get unpairBody => '此设备将离开家庭。家长可以用新代码重新连接。';

  @override
  String get demoBanner => '示例家庭，更改不会保存。';

  @override
  String get addHabit => '添加习惯';

  @override
  String get editHabit => '编辑习惯';

  @override
  String get habitName => '习惯名称';

  @override
  String get category => '分类';

  @override
  String get habitFor => '给谁';

  @override
  String get wholeFamily => '全家';

  @override
  String timesPerWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '每周 $count 次',
    );
    return '$_temp0';
  }

  @override
  String deleteHabitConfirm(String habit) {
    return '删除“$habit”及其记录？';
  }

  @override
  String get noHabitsYet => '还没有习惯。';

  @override
  String get members => '成员';

  @override
  String get settings => '设置';

  @override
  String get everyDay => '每天';

  @override
  String get catBreakHabit => '戒除习惯';

  @override
  String get catMindfulness => '正念';

  @override
  String get catFamilyCare => '家庭照顾与育儿';

  @override
  String get catFamilyMeals => '家庭聚餐与聚会';

  @override
  String get catHobbies => '爱好与娱乐';

  @override
  String get groupSelf => '照顾好自己';

  @override
  String get groupFamily => '照顾好家人';

  @override
  String get groupDaily => '我的责任';

  @override
  String get groupLeisure => '享受生活';

  @override
  String get createMyOwnHabit => '创建我自己的习惯';

  @override
  String get createMyOwnCategory => '创建我自己的分类';

  @override
  String createNamedHabit(String name) {
    return '将“$name”创建为我的习惯';
  }

  @override
  String get searchHabitsHint => '搜索，例如“公园”或“书”';

  @override
  String get noMatchingHabits => '没有匹配的现成习惯。你可以自己创建。';

  @override
  String get ourCategories => '我们家的分类';

  @override
  String get personalDefinition => '怎样算完成？（可选）';

  @override
  String get personalDefinitionHint => '例如：我今天喝了足够的水';

  @override
  String get categoryName => '分类名称';

  @override
  String get categoryHabits => '此分类中的习惯';

  @override
  String get addHabitToCategory => '添加习惯';

  @override
  String get editCategory => '编辑分类';

  @override
  String get deleteCategory => '删除分类';

  @override
  String deleteCategoryConfirm(String name) {
    return '删除“$name”？其中已有的习惯会保留。';
  }

  @override
  String get otherCategory => '其他';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => '家庭習慣';

  @override
  String get today => '今天';

  @override
  String get familyWeek => '家庭本週';

  @override
  String checkInsProgress(int done, int total) {
    return '已打卡 $done/$total';
  }

  @override
  String get myHabits => '我的習慣';

  @override
  String get familyHabits => '家庭習慣';

  @override
  String get familyHabitTag => '家庭習慣';

  @override
  String get checkInForFamily => '為全家打卡';

  @override
  String familyCheckedIn(String name, String habit) {
    return '$name 已為全家完成「$habit」打卡';
  }

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '連續 $count 天',
      zero: '尚無連續紀錄',
    );
    return '$_temp0';
  }

  @override
  String weekTarget(int done, int target) {
    return '本週 $done/$target';
  }

  @override
  String get categories => '分類';

  @override
  String get language => '語言';

  @override
  String get phoneLanguage => '跟隨手機語言';

  @override
  String get parent => '家長';

  @override
  String get child => '孩子';

  @override
  String get switchProfile => '切換成員';

  @override
  String get catArt => '藝術與創意';

  @override
  String get catStudy => '學習';

  @override
  String get catSport => '運動';

  @override
  String get catFinance => '理財';

  @override
  String get catHealth => '健康';

  @override
  String get catWork => '工作';

  @override
  String get catNutrition => '營養';

  @override
  String get catHomeTasks => '家務';

  @override
  String get catOutdoor => '戶外活動';

  @override
  String get catFamilyTime => '家庭時光';

  @override
  String get catSleep => '睡眠';

  @override
  String get catSelfCare => '個人保養與衛生';

  @override
  String get welcomeTitle => '一起養成好習慣';

  @override
  String get welcomeBody => '記錄自己的習慣，幫孩子堅持他們的習慣，看著家庭進度條一點點填滿。';

  @override
  String get imParent => '我是家長';

  @override
  String get joinWithCode => '用邀請碼加入';

  @override
  String get tryDemo => '試用範例家庭';

  @override
  String get signIn => '登入';

  @override
  String get createAccount => '建立帳號';

  @override
  String get email => '電子郵件';

  @override
  String get password => '密碼';

  @override
  String get forgotPassword => '忘記密碼？';

  @override
  String passwordResetSent(String email) {
    return '我們已將重設密碼的連結寄到 $email。';
  }

  @override
  String get haveAccount => '我已有帳號';

  @override
  String get newHere => '我是新使用者';

  @override
  String get errWrongPassword => '電子郵件或密碼不正確。';

  @override
  String get errEmailInUse => '這個電子郵件已經註冊，請直接登入。';

  @override
  String get errWeakPassword => '密碼至少需要 6 個字元。';

  @override
  String get errInvalidEmail => '請檢查電子郵件地址。';

  @override
  String get errCodeNotFound => '這組代碼不存在，請向建立它的家長確認。';

  @override
  String get errCodeExpired => '這組代碼已過期，請向家長索取新代碼。';

  @override
  String get errCodeWrongKind => '這組代碼用於其他加入方式，請向家長索取正確的代碼。';

  @override
  String get errNeedsRecentLogin => '為了安全，請登出後重新登入，再試一次。';

  @override
  String get errNetwork => '沒有網路連線，請連線後再試。';

  @override
  String get errUnknown => '發生問題，請再試一次。';

  @override
  String get setUpFamily => '設定你的家庭';

  @override
  String get createFamily => '建立家庭';

  @override
  String get familyName => '家庭名稱';

  @override
  String get yourName => '你在家裡的稱呼';

  @override
  String get joinFamily => '加入伴侶的家庭';

  @override
  String get inviteCode => '邀請碼';

  @override
  String get continueAction => '繼續';

  @override
  String get enterCode => '輸入家長手機上顯示的代碼。';

  @override
  String get pairCode => '代碼';

  @override
  String get join => '加入';

  @override
  String get family => '家庭';

  @override
  String get addChild => '新增孩子';

  @override
  String get inviteParent => '邀請另一位家長';

  @override
  String get nickname => '名字或暱稱';

  @override
  String get ageBand => '年齡';

  @override
  String get ageUnder6 => '未滿 6 歲';

  @override
  String get age6to9 => '6 到 9 歲';

  @override
  String get age10to12 => '10 到 12 歲';

  @override
  String get ageTeen => '13 到 17 歲';

  @override
  String get ownDevice => '有自己的手機或平板';

  @override
  String get consentTitle => '家長同意';

  @override
  String get consentBody =>
      '我是這個孩子的家長或監護人。我同意 Family Habits 儲存孩子的暱稱、年齡層和習慣打卡紀錄，讓我們全家一起記錄習慣。我可以隨時刪除這些資料。';

  @override
  String get consentCheck => '我同意';

  @override
  String get save => '儲存';

  @override
  String get cancel => '取消';

  @override
  String get delete => '刪除';

  @override
  String get pairDevice => '連接裝置';

  @override
  String get sharedDevice => '連接家庭共用裝置';

  @override
  String get codeInstructions =>
      '在另一台裝置上開啟 Family Habits，點選「用邀請碼加入」並輸入這組代碼。代碼 24 小時內有效，只能使用一次。';

  @override
  String get setPin => '設定 PIN 碼';

  @override
  String get removePin => '移除 PIN 碼';

  @override
  String get pinTitle => '輸入 PIN 碼';

  @override
  String get pinWrong => 'PIN 碼錯誤';

  @override
  String removeMemberConfirm(String name) {
    return '刪除 $name 和所有習慣？';
  }

  @override
  String get weekStartsOn => '每週開始於';

  @override
  String get weekStartAuto => '依語言設定';

  @override
  String get signOut => '登出';

  @override
  String get deleteAccount => '刪除帳號';

  @override
  String get deleteOwnerBody => '這會刪除你的帳號和整個家庭：所有成員、習慣和打卡紀錄，且無法復原。';

  @override
  String get deleteParentBody => '這會刪除你的帳號以及你在這個家庭中的資料，且無法復原。';

  @override
  String get unpairDevice => '中斷此裝置';

  @override
  String get unpairBody => '這台裝置將離開家庭。家長可以用新代碼重新連接。';

  @override
  String get demoBanner => '範例家庭，變更不會儲存。';

  @override
  String get addHabit => '新增習慣';

  @override
  String get editHabit => '編輯習慣';

  @override
  String get habitName => '習慣名稱';

  @override
  String get category => '分類';

  @override
  String get habitFor => '給誰';

  @override
  String get wholeFamily => '全家';

  @override
  String timesPerWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '每週 $count 次',
    );
    return '$_temp0';
  }

  @override
  String deleteHabitConfirm(String habit) {
    return '刪除「$habit」和相關紀錄？';
  }

  @override
  String get noHabitsYet => '還沒有習慣。';

  @override
  String get members => '成員';

  @override
  String get settings => '設定';

  @override
  String get everyDay => '每天';

  @override
  String get catBreakHabit => '戒除習慣';

  @override
  String get catMindfulness => '正念';

  @override
  String get catFamilyCare => '家庭照顧與育兒';

  @override
  String get catFamilyMeals => '家庭用餐與聚會';

  @override
  String get catHobbies => '嗜好與娛樂';

  @override
  String get groupSelf => '照顧好自己';

  @override
  String get groupFamily => '照顧好家人';

  @override
  String get groupDaily => '我的責任';

  @override
  String get groupLeisure => '享受生活';

  @override
  String get createMyOwnHabit => '建立我自己的習慣';

  @override
  String get createMyOwnCategory => '建立我自己的分類';

  @override
  String createNamedHabit(String name) {
    return '將「$name」建立為我的習慣';
  }

  @override
  String get searchHabitsHint => '搜尋，例如「公園」或「書」';

  @override
  String get noMatchingHabits => '沒有符合的現成習慣。你可以自己建立。';

  @override
  String get ourCategories => '我們家的分類';

  @override
  String get personalDefinition => '怎樣算完成？（選填）';

  @override
  String get personalDefinitionHint => '例如：我今天喝了足夠的水';

  @override
  String get categoryName => '分類名稱';

  @override
  String get categoryHabits => '此分類中的習慣';

  @override
  String get addHabitToCategory => '新增習慣';

  @override
  String get editCategory => '編輯分類';

  @override
  String get deleteCategory => '刪除分類';

  @override
  String deleteCategoryConfirm(String name) {
    return '刪除「$name」？其中已有的習慣會保留。';
  }

  @override
  String get otherCategory => '其他';
}
