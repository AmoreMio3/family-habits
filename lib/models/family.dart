import 'category.dart';

enum MemberRole { parent, child }

/// Age bands instead of birthdates, to collect as little as possible about
/// children.
enum AgeBand { under6, age6to9, age10to12, teen, adult }

class Member {
  const Member({
    required this.id,
    required this.nickname,
    required this.role,
    this.ageBand = AgeBand.adult,
    this.hasOwnDevice = false,
    this.uid,
    this.pinHash,
    this.consentAt,
    this.consentByUid,
  });

  final String id;
  final String nickname;
  final MemberRole role;
  final AgeBand ageBand;

  /// Children without a device are managed only from a parent's account.
  final bool hasOwnDevice;

  /// Sign-in account of a parent. Children have none.
  final String? uid;

  /// Optional profile PIN, stored hashed. It keeps siblings out of each
  /// other's profile on a shared device; it is not a security boundary.
  final String? pinHash;

  /// When and by whom parental consent was given for a child profile.
  final DateTime? consentAt;
  final String? consentByUid;

  bool get isParent => role == MemberRole.parent;

  Member copyWith({
    String? nickname,
    AgeBand? ageBand,
    bool? hasOwnDevice,
    String? pinHash,
    bool clearPin = false,
  }) => Member(
    id: id,
    nickname: nickname ?? this.nickname,
    role: role,
    ageBand: ageBand ?? this.ageBand,
    hasOwnDevice: hasOwnDevice ?? this.hasOwnDevice,
    uid: uid,
    pinHash: clearPin ? null : pinHash ?? this.pinHash,
    consentAt: consentAt,
    consentByUid: consentByUid,
  );

  Map<String, Object?> toMap() => {
    'nickname': nickname,
    'role': role.name,
    'ageBand': ageBand.name,
    'hasOwnDevice': hasOwnDevice,
    'uid': uid,
    'pinHash': pinHash,
    'consentAt': consentAt,
    'consentByUid': consentByUid,
  };

  factory Member.fromMap(String id, Map<String, Object?> map) => Member(
    id: id,
    nickname: map['nickname'] as String? ?? '',
    role: MemberRole.values.byName(map['role'] as String? ?? 'child'),
    ageBand: AgeBand.values.byName(map['ageBand'] as String? ?? 'adult'),
    hasOwnDevice: map['hasOwnDevice'] as bool? ?? false,
    uid: map['uid'] as String?,
    pinHash: map['pinHash'] as String?,
    consentAt: map['consentAt'] as DateTime?,
    consentByUid: map['consentByUid'] as String?,
  );
}

/// Who a habit belongs to.
sealed class HabitOwner {
  const HabitOwner();
}

class PersonalOwner extends HabitOwner {
  const PersonalOwner(this.memberId);
  final String memberId;

  @override
  bool operator ==(Object other) =>
      other is PersonalOwner && other.memberId == memberId;

  @override
  int get hashCode => memberId.hashCode;
}

/// A family habit. A parent checks it in once for everyone.
class FamilyOwner extends HabitOwner {
  const FamilyOwner();

  @override
  bool operator ==(Object other) => other is FamilyOwner;

  @override
  int get hashCode => 0;
}

class Habit {
  const Habit({
    required this.id,
    required this.name,
    required this.owner,
    required this.category,
    this.subcategory,
    this.timesPerWeek = 7,
  });

  final String id;
  final String name;
  final HabitOwner owner;
  final BuiltInCategory category;
  final String? subcategory;

  /// Weekly target, e.g. 7 for daily or 4 for "4 family dinners a week".
  final int timesPerWeek;

  bool get isFamily => owner is FamilyOwner;

  /// The member who owns a personal habit, or null for a family habit.
  String? get ownerMemberId => switch (owner) {
    PersonalOwner(:final memberId) => memberId,
    FamilyOwner() => null,
  };

  Map<String, Object?> toMap() => {
    'name': name,
    'ownerMemberId': ownerMemberId,
    'category': category.name,
    'subcategory': subcategory,
    'timesPerWeek': timesPerWeek,
  };

  factory Habit.fromMap(String id, Map<String, Object?> map) {
    final ownerId = map['ownerMemberId'] as String?;
    return Habit(
      id: id,
      name: map['name'] as String? ?? '',
      owner: ownerId == null ? const FamilyOwner() : PersonalOwner(ownerId),
      category:
          BuiltInCategory.values.asNameMap()[map['category']] ??
          BuiltInCategory.health,
      subcategory: map['subcategory'] as String?,
      timesPerWeek: (map['timesPerWeek'] as num?)?.toInt() ?? 7,
    );
  }
}

/// `2026-09-28` style key for a local calendar day.
String dayKey(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

DateTime parseDayKey(String key) {
  final parts = key.split('-').map(int.parse).toList();
  return DateTime(parts[0], parts[1], parts[2]);
}

class CheckIn {
  const CheckIn({
    required this.habitId,
    required this.day,
    required this.checkedInBy,
  });

  final String habitId;

  /// Local calendar day, time set to midnight.
  final DateTime day;

  /// The member who pressed the check. For a family habit this is the parent.
  final String checkedInBy;

  /// One check-in per habit per day, so the id is derived from both.
  String get id => checkInId(habitId, day);

  Map<String, Object?> toMap() => {
    'habitId': habitId,
    'day': dayKey(day),
    'checkedInBy': checkedInBy,
  };

  factory CheckIn.fromMap(Map<String, Object?> map) => CheckIn(
    habitId: map['habitId'] as String,
    day: parseDayKey(map['day'] as String),
    checkedInBy: map['checkedInBy'] as String,
  );
}

String checkInId(String habitId, DateTime day) => '${habitId}_${dayKey(day)}';

/// Family-wide settings.
class FamilyInfo {
  const FamilyInfo({
    required this.id,
    required this.name,
    this.ownerUid,
    this.weekStart,
  });

  final String id;
  final String name;
  final String? ownerUid;

  /// Parent override for the first day of the week ([DateTime.monday] ..
  /// [DateTime.sunday]). Null follows the language and region.
  final int? weekStart;

  Map<String, Object?> toMap() => {
    'name': name,
    'ownerUid': ownerUid,
    'weekStart': weekStart,
  };

  factory FamilyInfo.fromMap(String id, Map<String, Object?> map) => FamilyInfo(
    id: id,
    name: map['name'] as String? ?? '',
    ownerUid: map['ownerUid'] as String?,
    weekStart: (map['weekStart'] as num?)?.toInt(),
  );
}
