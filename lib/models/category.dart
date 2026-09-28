import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// The 16 built-in categories. Families can add their own with [CustomCategory].
enum BuiltInCategory {
  quitBadHabit(Icons.block, Color(0xFFB0412E), [
    'Screen time',
    'Social media',
    'Smoking or vaping',
    'Alcohol',
    'Sugar and junk food',
    'Nail biting',
    'Swearing',
    'Procrastination',
    'Impulse buying',
  ]),
  art(Icons.palette_outlined, Color(0xFFC2185B), [
    'Drawing and painting',
    'Music practice',
    'Writing and journaling',
    'Crafts',
    'Photography',
    'Dance',
    'Theatre',
  ]),
  meditate(Icons.self_improvement, Color(0xFF7E57C2), [
    'Meditation',
    'Breathing',
    'Gratitude',
    'Prayer or reflection',
    'Journaling feelings',
  ]),
  study(Icons.menu_book_outlined, Color(0xFF3949AB), [
    'Homework',
    'Reading',
    'Languages',
    'Exam prep',
    'Online courses',
    'Coding',
  ]),
  sport(Icons.directions_run, Color(0xFF00897B), [
    'Running',
    'Gym and strength',
    'Team sports',
    'Swimming',
    'Cycling',
    'Martial arts',
    'Yoga and stretching',
    'Steps',
  ]),
  entertainment(Icons.sports_esports_outlined, Color(0xFF8E24AA), [
    'Board games',
    'Video games',
    'Movies and series',
    'Puzzles',
    'Collections',
    'Building toys',
  ]),
  finance(Icons.savings_outlined, Color(0xFF2E7D32), [
    'Budget check',
    'Saving',
    'No-spend days',
    'Pocket money',
    'Investing',
    'Bills',
    'Giving',
  ]),
  health(Icons.favorite_outline, Color(0xFFD81B60), [
    'Water',
    'Medication',
    'Vitamins',
    'Doctor and dentist',
    'Posture',
    'Eye breaks',
  ]),
  work(Icons.work_outline, Color(0xFF546E7A), [
    'Deep work',
    'Inbox zero',
    'Planning',
    'Learning a skill',
    'Side project',
  ]),
  nutrition(Icons.restaurant_outlined, Color(0xFF7CB342), [
    'Fruit and vegetables',
    'Breakfast',
    'Protein',
    'Cooking at home',
    'Mindful eating',
    'Try a new food',
  ]),
  homeTasks(Icons.cleaning_services_outlined, Color(0xFF6D4C41), [
    'Tidy room',
    'Make bed',
    'Dishes',
    'Laundry',
    'Trash and recycling',
    'Pet care',
    'Plants and garden',
  ]),
  outdoor(Icons.park_outlined, Color(0xFF43A047), [
    'Walk',
    'Hiking',
    'Park and playground',
    'Beach',
    'Biking',
    'Sunlight time',
  ]),
  familyTime(Icons.diversity_1_outlined, Color(0xFFD9961A), [
    'Game night',
    'One-on-one time',
    'Bedtime story',
    'Talk about the day',
    'Trips',
    'Calling grandparents',
  ]),
  familyTable(Icons.dinner_dining_outlined, Color(0xFFEF6C00), [
    'Family dinner',
    'Holiday meals',
    'Weekend breakfast',
    'Cooking together',
    'Phone-free meals',
    'Hosting relatives',
  ]),
  sleep(Icons.bedtime_outlined, Color(0xFF3F51B5), [
    'Bedtime',
    'Wake-up time',
    'Screens off before bed',
    'Naps',
    'Wind-down routine',
  ]),
  selfCare(Icons.shower_outlined, Color(0xFF0097A7), [
    'Brush teeth',
    'Shower',
    'Get dressed',
    'Skincare',
    'Pack school bag',
    'Morning routine',
    'Evening routine',
  ]);

  const BuiltInCategory(this.icon, this.color, this.defaultSubcategories);

  final IconData icon;
  final Color color;

  /// Starting subcategories. Families can rename, hide or add their own.
  /// These are English seed values; translating them is a follow-up.
  final List<String> defaultSubcategories;

  String label(AppLocalizations l10n) => switch (this) {
    quitBadHabit => l10n.catQuitBadHabit,
    art => l10n.catArt,
    meditate => l10n.catMeditate,
    study => l10n.catStudy,
    sport => l10n.catSport,
    entertainment => l10n.catEntertainment,
    finance => l10n.catFinance,
    health => l10n.catHealth,
    work => l10n.catWork,
    nutrition => l10n.catNutrition,
    homeTasks => l10n.catHomeTasks,
    outdoor => l10n.catOutdoor,
    familyTime => l10n.catFamilyTime,
    familyTable => l10n.catFamilyTable,
    sleep => l10n.catSleep,
    selfCare => l10n.catSelfCare,
  };
}

/// A category a family created. [familyWide] categories are visible to every
/// member; otherwise only the member who created it sees it.
class CustomCategory {
  const CustomCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.subcategories = const [],
    this.familyWide = false,
  });

  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<String> subcategories;
  final bool familyWide;
}
