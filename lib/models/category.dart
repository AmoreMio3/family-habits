import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// How the category list is grouped: take care of myself, then my family,
/// then my responsibilities, then enjoy my life.
enum CategoryGroup {
  self,
  family,
  daily,
  leisure;

  String label(AppLocalizations l10n) => switch (this) {
    self => l10n.groupSelf,
    family => l10n.groupFamily,
    daily => l10n.groupDaily,
    leisure => l10n.groupLeisure,
  };
}

/// The 17 built-in categories, in the order the app shows them. Families add
/// their own with [CustomCategory].
enum BuiltInCategory {
  health(CategoryGroup.self, Icons.favorite_outline, Color(0xFFD81B60)),
  breakHabit(CategoryGroup.self, Icons.block, Color(0xFFB0412E)),
  nutrition(CategoryGroup.self, Icons.restaurant_outlined, Color(0xFF7CB342)),
  sleep(CategoryGroup.self, Icons.bedtime_outlined, Color(0xFF3F51B5)),
  sport(CategoryGroup.self, Icons.directions_run, Color(0xFF00897B)),
  selfCare(CategoryGroup.self, Icons.shower_outlined, Color(0xFF0097A7)),
  mindfulness(CategoryGroup.self, Icons.self_improvement, Color(0xFF7E57C2)),
  familyTime(CategoryGroup.family, Icons.diversity_3, Color(0xFFE64A19)),
  familyCare(
    CategoryGroup.family,
    Icons.volunteer_activism_outlined,
    Color(0xFFEC407A),
  ),
  familyMeals(
    CategoryGroup.family,
    Icons.dinner_dining_outlined,
    Color(0xFFF57C00),
  ),
  homeTasks(CategoryGroup.daily, Icons.home_outlined, Color(0xFF6D4C41)),
  study(CategoryGroup.daily, Icons.menu_book_outlined, Color(0xFF3949AB)),
  work(CategoryGroup.daily, Icons.work_outline, Color(0xFF546E7A)),
  finance(CategoryGroup.daily, Icons.savings_outlined, Color(0xFF2E7D32)),
  outdoor(CategoryGroup.daily, Icons.park_outlined, Color(0xFF558B2F)),
  art(CategoryGroup.leisure, Icons.palette_outlined, Color(0xFFC2185B)),
  hobbies(CategoryGroup.leisure, Icons.extension_outlined, Color(0xFF8E24AA));

  const BuiltInCategory(this.group, this.icon, this.color);

  final CategoryGroup group;
  final IconData icon;
  final Color color;

  /// Position in the list, starting at 1.
  int get number => index + 1;

  /// Looks up a stored category id, including names used before Habit
  /// Library V1.
  static BuiltInCategory? fromId(String? id) =>
      values.asNameMap()[id] ??
      switch (id) {
        'quitBadHabit' => breakHabit,
        'meditate' => mindfulness,
        'entertainment' => hobbies,
        'familyTable' => familyMeals,
        _ => null,
      };

  String label(AppLocalizations l10n) => switch (this) {
    health => l10n.catHealth,
    breakHabit => l10n.catBreakHabit,
    nutrition => l10n.catNutrition,
    sleep => l10n.catSleep,
    sport => l10n.catSport,
    selfCare => l10n.catSelfCare,
    mindfulness => l10n.catMindfulness,
    familyTime => l10n.catFamilyTime,
    familyCare => l10n.catFamilyCare,
    familyMeals => l10n.catFamilyMeals,
    homeTasks => l10n.catHomeTasks,
    study => l10n.catStudy,
    work => l10n.catWork,
    finance => l10n.catFinance,
    outdoor => l10n.catOutdoor,
    art => l10n.catArt,
    hobbies => l10n.catHobbies,
  };
}

/// A category a family made, with its own list of habits to pick from.
class CustomCategory {
  const CustomCategory({
    required this.id,
    required this.name,
    this.habits = const [],
  });

  final String id;
  final String name;

  /// Habit names offered when adding a habit in this category.
  final List<String> habits;

  static const icon = Icons.star_outline;
  static const color = Color(0xFF607D8B);

  Map<String, Object?> toMap() => {'name': name, 'habits': habits};

  factory CustomCategory.fromMap(String id, Map<String, Object?> map) =>
      CustomCategory(
        id: id,
        name: map['name'] as String? ?? '',
        habits: [...?(map['habits'] as List?)?.cast<String>()],
      );
}

/// What a habit's category id points at: a built-in or a family's own.
sealed class CategoryRef {
  const CategoryRef();

  /// Stored form: a built-in name, or `custom:<id>`.
  String get id;

  static const _customPrefix = 'custom:';

  static CategoryRef parse(String? id) {
    if (id != null && id.startsWith(_customPrefix)) {
      return CustomRef(id.substring(_customPrefix.length));
    }
    return BuiltInRef(BuiltInCategory.fromId(id) ?? BuiltInCategory.health);
  }
}

class BuiltInRef extends CategoryRef {
  const BuiltInRef(this.category);
  final BuiltInCategory category;

  @override
  String get id => category.name;

  @override
  bool operator ==(Object other) =>
      other is BuiltInRef && other.category == category;

  @override
  int get hashCode => category.hashCode;
}

class CustomRef extends CategoryRef {
  const CustomRef(this.customId);
  final String customId;

  @override
  String get id => '${CategoryRef._customPrefix}$customId';

  @override
  bool operator ==(Object other) =>
      other is CustomRef && other.customId == customId;

  @override
  int get hashCode => customId.hashCode;
}
