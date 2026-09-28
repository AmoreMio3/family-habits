import 'category.dart';

enum MemberRole { parent, child }

class Member {
  const Member({
    required this.id,
    required this.nickname,
    required this.role,
    this.hasOwnDevice = false,
  });

  final String id;
  final String nickname;
  final MemberRole role;

  /// Children without a device are managed only from a parent's account.
  final bool hasOwnDevice;

  bool get isParent => role == MemberRole.parent;
}

/// Who a habit belongs to.
sealed class HabitOwner {
  const HabitOwner();
}

class PersonalOwner extends HabitOwner {
  const PersonalOwner(this.memberId);
  final String memberId;
}

/// A family habit. A parent checks it in once for everyone.
class FamilyOwner extends HabitOwner {
  const FamilyOwner();
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
}
