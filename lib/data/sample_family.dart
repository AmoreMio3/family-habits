import '../models/category.dart';
import '../models/family.dart';
import 'family_store.dart';

/// Example family used until accounts and sync exist.
FamilyStore sampleFamily({DateTime Function()? clock}) {
  final now = (clock ?? DateTime.now)();
  DateTime daysAgo(int n) => DateTime(now.year, now.month, now.day - n);

  const members = [
    Member(
      id: 'dad',
      nickname: 'Dad',
      role: MemberRole.parent,
      hasOwnDevice: true,
    ),
    Member(
      id: 'mom',
      nickname: 'Mom',
      role: MemberRole.parent,
      hasOwnDevice: true,
    ),
    Member(
      id: 'noa',
      nickname: 'Noa',
      role: MemberRole.child,
      hasOwnDevice: true,
    ),
    Member(id: 'itai', nickname: 'Itai', role: MemberRole.child),
  ];

  const habits = [
    Habit(
      id: 'dinner',
      name: 'Family dinner, no phones',
      owner: FamilyOwner(),
      category: BuiltInCategory.familyTable,
      subcategory: 'Phone-free meals',
      timesPerWeek: 4,
    ),
    Habit(
      id: 'hike',
      name: 'Weekend hike',
      owner: FamilyOwner(),
      category: BuiltInCategory.outdoor,
      subcategory: 'Hiking',
      timesPerWeek: 1,
    ),
    Habit(
      id: 'dad-run',
      name: 'Run 5 km',
      owner: PersonalOwner('dad'),
      category: BuiltInCategory.sport,
      subcategory: 'Running',
      timesPerWeek: 3,
    ),
    Habit(
      id: 'dad-phone',
      name: 'No phone after 22:00',
      owner: PersonalOwner('dad'),
      category: BuiltInCategory.quitBadHabit,
      subcategory: 'Screen time',
    ),
    Habit(
      id: 'mom-meditate',
      name: 'Meditate 10 minutes',
      owner: PersonalOwner('mom'),
      category: BuiltInCategory.meditate,
      subcategory: 'Meditation',
    ),
    Habit(
      id: 'noa-read',
      name: 'Read 20 minutes',
      owner: PersonalOwner('noa'),
      category: BuiltInCategory.study,
      subcategory: 'Reading',
    ),
    Habit(
      id: 'noa-teeth',
      name: 'Brush teeth at night',
      owner: PersonalOwner('noa'),
      category: BuiltInCategory.selfCare,
      subcategory: 'Brush teeth',
    ),
    Habit(
      id: 'noa-piano',
      name: 'Piano practice 15 minutes',
      owner: PersonalOwner('noa'),
      category: BuiltInCategory.art,
      subcategory: 'Music practice',
      timesPerWeek: 5,
    ),
    Habit(
      id: 'itai-bed',
      name: 'Make my bed',
      owner: PersonalOwner('itai'),
      category: BuiltInCategory.homeTasks,
      subcategory: 'Make bed',
    ),
    Habit(
      id: 'itai-sleep',
      name: 'In bed by 20:30',
      owner: PersonalOwner('itai'),
      category: BuiltInCategory.sleep,
      subcategory: 'Bedtime',
    ),
  ];

  final checkIns = [
    for (final n in [1, 2, 4])
      CheckIn(habitId: 'dinner', day: daysAgo(n), checkedInBy: 'mom'),
    for (final n in [1, 3])
      CheckIn(habitId: 'dad-run', day: daysAgo(n), checkedInBy: 'dad'),
    for (var n = 1; n <= 5; n++)
      CheckIn(habitId: 'dad-phone', day: daysAgo(n), checkedInBy: 'dad'),
    for (var n = 0; n <= 6; n++)
      CheckIn(habitId: 'mom-meditate', day: daysAgo(n), checkedInBy: 'mom'),
    for (var n = 0; n <= 11; n++)
      CheckIn(habitId: 'noa-read', day: daysAgo(n), checkedInBy: 'noa'),
    for (var n = 1; n <= 30; n++)
      CheckIn(habitId: 'noa-teeth', day: daysAgo(n), checkedInBy: 'noa'),
    for (var n = 1; n <= 4; n++)
      CheckIn(habitId: 'noa-piano', day: daysAgo(n), checkedInBy: 'noa'),
    for (var n = 0; n <= 2; n++)
      CheckIn(habitId: 'itai-bed', day: daysAgo(n), checkedInBy: 'dad'),
  ];

  return FamilyStore(
    members: members,
    habits: habits,
    checkIns: checkIns,
    activeMemberId: 'noa',
    clock: clock,
  );
}
