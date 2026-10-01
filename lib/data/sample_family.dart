import '../models/category.dart';
import '../models/family.dart';
import 'family_repository.dart';
import 'family_store.dart';

/// Example family shown until the app is connected to Firebase.
InMemoryFamilyRepository sampleRepository({DateTime Function()? clock}) {
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
      ageBand: AgeBand.age6to9,
      hasOwnDevice: true,
    ),
    Member(
      id: 'itai',
      nickname: 'Itai',
      role: MemberRole.child,
      ageBand: AgeBand.under6,
    ),
  ];

  const habits = [
    Habit(
      id: 'dinner',
      name: 'Have a phone-free meal',
      owner: FamilyOwner(),
      category: BuiltInRef(BuiltInCategory.familyMeals),
      templateId: 'FAMILY_MEALS_005',
      timesPerWeek: 4,
    ),
    Habit(
      id: 'hike',
      name: 'Go hiking',
      owner: FamilyOwner(),
      category: BuiltInRef(BuiltInCategory.outdoor),
      templateId: 'OUTDOOR_002',
      timesPerWeek: 1,
    ),
    Habit(
      id: 'dad-run',
      name: 'Run',
      owner: PersonalOwner('dad'),
      category: BuiltInRef(BuiltInCategory.sport),
      templateId: 'SPORT_002',
      definition: 'I ran 5 km',
      timesPerWeek: 3,
    ),
    Habit(
      id: 'dad-phone',
      name: 'No phone in bed',
      owner: PersonalOwner('dad'),
      category: BuiltInRef(BuiltInCategory.breakHabit),
      templateId: 'BREAK_011',
      definition: 'No phone after 22:00',
    ),
    Habit(
      id: 'mom-meditate',
      name: 'Meditate',
      owner: PersonalOwner('mom'),
      category: BuiltInRef(BuiltInCategory.mindfulness),
      templateId: 'MINDFUL_001',
      definition: 'At least 10 minutes',
    ),
    Habit(
      id: 'noa-read',
      name: 'Read',
      owner: PersonalOwner('noa'),
      category: BuiltInRef(BuiltInCategory.study),
      templateId: 'STUDY_002',
      definition: 'I read for 20 minutes',
    ),
    Habit(
      id: 'noa-teeth',
      name: 'Brush teeth',
      owner: PersonalOwner('noa'),
      category: BuiltInRef(BuiltInCategory.selfCare),
      templateId: 'SELF_CARE_001',
    ),
    Habit(
      id: 'noa-piano',
      name: 'Play an instrument',
      owner: PersonalOwner('noa'),
      category: BuiltInRef(BuiltInCategory.art),
      templateId: 'ART_004',
      definition: 'Piano, 15 minutes',
      timesPerWeek: 5,
    ),
    Habit(
      id: 'itai-bed',
      name: 'Make the bed',
      owner: PersonalOwner('itai'),
      category: BuiltInRef(BuiltInCategory.homeTasks),
      templateId: 'HOME_001',
    ),
    Habit(
      id: 'itai-sleep',
      name: 'Go to bed on time',
      owner: PersonalOwner('itai'),
      category: BuiltInRef(BuiltInCategory.sleep),
      templateId: 'SLEEP_001',
      definition: 'In bed by 20:30',
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

  return InMemoryFamilyRepository(
    info: const FamilyInfo(id: 'demo', name: 'Demo family'),
    members: members,
    habits: habits,
    checkIns: checkIns,
  );
}

/// The demo family, opened as Dad's parent account.
FamilyStore sampleFamily({DateTime Function()? clock}) => FamilyStore(
  repository: sampleRepository(clock: clock),
  access: const DeviceAccess.parent(myMemberId: 'dad'),
  clock: clock,
  isDemo: true,
);
