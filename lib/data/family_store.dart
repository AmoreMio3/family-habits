import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';

import '../logic/week.dart';
import '../models/category.dart';
import '../models/family.dart';
import 'family_repository.dart';

/// Who is using this device and which profiles they may open.
class DeviceAccess {
  const DeviceAccess.parent({required this.myMemberId})
    : isParent = true,
      memberIds = const [];

  const DeviceAccess.device({required this.memberIds})
    : isParent = false,
      myMemberId = null;

  final bool isParent;

  /// The parent's own profile, when signed in as a parent.
  final String? myMemberId;

  /// Profiles a paired device may open. Parents may open every profile.
  final List<String> memberIds;
}

/// The family as the app sees it: data from [FamilyRepository] plus what
/// this device is doing (active profile, language).
class FamilyStore extends ChangeNotifier {
  FamilyStore({
    required this.repository,
    required this.access,
    DateTime Function()? clock,
    this.isDemo = false,
  }) : _clock = clock ?? DateTime.now {
    _sub = repository.watch().listen(
      (snapshot) {
        _snapshot = snapshot;
        notifyListeners();
      },
      onError: (Object e) {
        _error = e;
        notifyListeners();
      },
    );
  }

  final FamilyRepository repository;
  final DeviceAccess access;
  final bool isDemo;
  final DateTime Function() _clock;
  late final StreamSubscription<FamilySnapshot> _sub;
  FamilySnapshot? _snapshot;
  Object? _error;
  String? _activeMemberId;

  bool get isLoading => _snapshot == null && _error == null;
  Object? get error => _error;

  FamilyInfo get info => _snapshot!.info;
  List<Member> get members => _snapshot?.members ?? const [];
  List<Habit> get habits => _snapshot?.habits ?? const [];
  List<CheckIn> get checkIns => _snapshot?.checkIns ?? const [];
  List<CustomCategory> get categories => _snapshot?.categories ?? const [];

  CustomCategory? customCategory(String id) =>
      categories.where((c) => c.id == id).firstOrNull;
  DateTime get today => dateOnly(_clock());

  /// Parents first, then children, each in name order.
  List<Member> get sortedMembers => [...members]
    ..sort((a, b) {
      if (a.isParent != b.isParent) return a.isParent ? -1 : 1;
      return a.nickname.toLowerCase().compareTo(b.nickname.toLowerCase());
    });

  /// Profiles this device may switch to.
  List<Member> get availableMembers => access.isParent
      ? sortedMembers
      : sortedMembers.where((m) => access.memberIds.contains(m.id)).toList();

  Member? get activeMember {
    final available = availableMembers;
    if (available.isEmpty) return null;
    final wanted = _activeMemberId ?? access.myMemberId;
    return available.where((m) => m.id == wanted).firstOrNull ??
        available.first;
  }

  /// Whether opening [member] asks for a PIN. Parents never need one.
  bool needsPin(Member member) =>
      !access.isParent &&
      member.pinHash != null &&
      member.id != activeMember?.id;

  bool checkPin(Member member, String pin) =>
      member.pinHash == hashPin(member.id, pin);

  void switchTo(String memberId) {
    _activeMemberId = memberId;
    notifyListeners();
  }

  Member? member(String id) => members.where((m) => m.id == id).firstOrNull;

  List<Habit> get familyHabits => habits.where((h) => h.isFamily).toList();

  List<Habit> habitsOf(String memberId) =>
      habits.where((h) => h.ownerMemberId == memberId).toList();

  bool isDoneToday(Habit habit) =>
      checkIns.any((c) => c.habitId == habit.id && dateOnly(c.day) == today);

  /// Only parents check in family habits. Anyone can check their own habits,
  /// and parents can check habits for a child without a device.
  bool canCheckIn(Habit habit) {
    final me = activeMember;
    if (me == null) return false;
    return switch (habit.owner) {
      FamilyOwner() => me.isParent,
      PersonalOwner(:final memberId) => memberId == me.id || me.isParent,
    };
  }

  bool get canManage => access.isParent && (activeMember?.isParent ?? false);

  /// Toggles today's check-in. Returns true when a family habit was just
  /// checked in, so the caller can tell the family.
  Future<bool> toggleToday(Habit habit) async {
    final me = activeMember;
    if (me == null || !canCheckIn(habit)) return false;
    final done = !isDoneToday(habit);
    await repository.setCheckIn(habit, today, done: done, byMemberId: me.id);
    return done && habit.isFamily;
  }

  /// First day of the week: the family's setting, else the locale's.
  int weekStartFor(Locale locale) =>
      _snapshot?.info.weekStart ?? firstDayOfWeek(locale);

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

/// Salted with the member id so equal PINs don't produce equal hashes.
String hashPin(String memberId, String pin) =>
    sha256.convert(utf8.encode('$memberId:$pin')).toString();
