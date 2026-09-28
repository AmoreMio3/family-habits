import 'package:flutter/widgets.dart';

import '../logic/week.dart';
import '../models/family.dart';

/// In-memory family state. Sync with the backend replaces this later.
class FamilyStore extends ChangeNotifier {
  FamilyStore({
    required List<Member> members,
    required List<Habit> habits,
    List<CheckIn> checkIns = const [],
    required String activeMemberId,
    DateTime Function()? clock,
  }) : _members = List.of(members),
       _habits = List.of(habits),
       _checkIns = List.of(checkIns),
       _clock = clock ?? DateTime.now {
    _activeMemberId = activeMemberId;
  }

  final List<Member> _members;
  final List<Habit> _habits;
  final List<CheckIn> _checkIns;
  final DateTime Function() _clock;
  late String _activeMemberId;
  Locale? _locale;

  List<Member> get members => List.unmodifiable(_members);
  List<Habit> get habits => List.unmodifiable(_habits);
  List<CheckIn> get checkIns => List.unmodifiable(_checkIns);
  DateTime get today => dateOnly(_clock());

  Member get activeMember =>
      _members.firstWhere((m) => m.id == _activeMemberId);

  /// Null means "follow the phone's language".
  Locale? get locale => _locale;

  set locale(Locale? value) {
    _locale = value;
    notifyListeners();
  }

  void switchTo(String memberId) {
    _activeMemberId = memberId;
    notifyListeners();
  }

  Member member(String id) => _members.firstWhere((m) => m.id == id);

  List<Habit> get familyHabits => _habits.where((h) => h.isFamily).toList();

  List<Habit> habitsOf(String memberId) => _habits
      .where(
        (h) =>
            h.owner is PersonalOwner &&
            (h.owner as PersonalOwner).memberId == memberId,
      )
      .toList();

  bool isDoneToday(Habit habit) =>
      _checkIns.any((c) => c.habitId == habit.id && dateOnly(c.day) == today);

  /// Only parents check in family habits. Anyone can check their own habits,
  /// and parents can check habits for a child without a device.
  bool canCheckIn(Habit habit) {
    final me = activeMember;
    return switch (habit.owner) {
      FamilyOwner() => me.isParent,
      PersonalOwner(:final memberId) => memberId == me.id || me.isParent,
    };
  }

  /// Toggles today's check-in. Returns true when a family habit was just
  /// checked in, so the caller can tell the family.
  bool toggleToday(Habit habit) {
    if (!canCheckIn(habit)) return false;
    if (isDoneToday(habit)) {
      _checkIns.removeWhere(
        (c) => c.habitId == habit.id && dateOnly(c.day) == today,
      );
      notifyListeners();
      return false;
    }
    _checkIns.add(
      CheckIn(habitId: habit.id, day: today, checkedInBy: _activeMemberId),
    );
    notifyListeners();
    return habit.isFamily;
  }
}
