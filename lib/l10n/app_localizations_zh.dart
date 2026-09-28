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
  String get catQuitBadHabit => '戒除坏习惯';

  @override
  String get catArt => '艺术';

  @override
  String get catMeditate => '冥想';

  @override
  String get catStudy => '学习';

  @override
  String get catSport => '运动';

  @override
  String get catEntertainment => '娱乐';

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
  String get catFamilyTable => '家庭聚餐';

  @override
  String get catSleep => '睡眠';

  @override
  String get catSelfCare => '个人护理与卫生';
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
  String get catQuitBadHabit => '戒除壞習慣';

  @override
  String get catArt => '藝術';

  @override
  String get catMeditate => '冥想';

  @override
  String get catStudy => '學習';

  @override
  String get catSport => '運動';

  @override
  String get catEntertainment => '娛樂';

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
  String get catFamilyTable => '家庭聚餐';

  @override
  String get catSleep => '睡眠';

  @override
  String get catSelfCare => '個人護理與衛生';
}
