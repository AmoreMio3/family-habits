import 'dart:async';
import 'dart:math';

import '../models/family.dart';

/// Everything a family screen shows, read in one piece.
class FamilySnapshot {
  const FamilySnapshot({
    required this.info,
    required this.members,
    required this.habits,
    required this.checkIns,
  });

  final FamilyInfo info;
  final List<Member> members;
  final List<Habit> habits;
  final List<CheckIn> checkIns;
}

/// What a pairing code lets its holder do.
enum PairingKind {
  /// A child's own phone or tablet, or a shared device with several children.
  device,

  /// A second parent joining the family.
  coParent,
}

/// Reads and writes one family's data.
abstract class FamilyRepository {
  Stream<FamilySnapshot> watch();

  Future<void> updateFamily(FamilyInfo info);

  Future<void> saveMember(Member member);
  Future<void> removeMember(String memberId);

  Future<void> saveHabit(Habit habit);
  Future<void> deleteHabit(String habitId);

  /// Marks [habit] done or not done on [day]. For a family habit one parent's
  /// check-in counts for everyone.
  Future<void> setCheckIn(
    Habit habit,
    DateTime day, {
    required bool done,
    required String byMemberId,
  });

  /// Creates a short-lived code another device types or scans to join.
  Future<String> createPairingCode(
    PairingKind kind, {
    List<String> memberIds = const [],
  });

  /// A new id for a member or habit.
  String newId();
}

/// Keeps a family in memory. Used for the demo family and in tests.
class InMemoryFamilyRepository implements FamilyRepository {
  InMemoryFamilyRepository({
    required this._info,
    List<Member> members = const [],
    List<Habit> habits = const [],
    List<CheckIn> checkIns = const [],
  }) : _members = {for (final m in members) m.id: m},
       _habits = {for (final h in habits) h.id: h},
       _checkIns = {for (final c in checkIns) c.id: c};

  FamilyInfo _info;
  final Map<String, Member> _members;
  final Map<String, Habit> _habits;
  final Map<String, CheckIn> _checkIns;
  final _controller = StreamController<FamilySnapshot>.broadcast();
  var _nextId = 0;

  /// Called with each new pairing code, so in-memory accounts can accept it.
  void Function(String code, PairingKind kind, List<String> memberIds)?
  onPairingCode;

  FamilySnapshot get current => FamilySnapshot(
    info: _info,
    members: _members.values.toList(),
    habits: _habits.values.toList(),
    checkIns: _checkIns.values.toList(),
  );

  void _emit() => _controller.add(current);

  @override
  Stream<FamilySnapshot> watch() async* {
    yield current;
    yield* _controller.stream;
  }

  @override
  Future<void> updateFamily(FamilyInfo info) async {
    _info = info;
    _emit();
  }

  @override
  Future<void> saveMember(Member member) async {
    _members[member.id] = member;
    _emit();
  }

  @override
  Future<void> removeMember(String memberId) async {
    _members.remove(memberId);
    final owned = _habits.values
        .where((h) => h.ownerMemberId == memberId)
        .map((h) => h.id)
        .toSet();
    _habits.removeWhere((id, _) => owned.contains(id));
    _checkIns.removeWhere((_, c) => owned.contains(c.habitId));
    _emit();
  }

  @override
  Future<void> saveHabit(Habit habit) async {
    _habits[habit.id] = habit;
    _emit();
  }

  @override
  Future<void> deleteHabit(String habitId) async {
    _habits.remove(habitId);
    _checkIns.removeWhere((_, c) => c.habitId == habitId);
    _emit();
  }

  @override
  Future<void> setCheckIn(
    Habit habit,
    DateTime day, {
    required bool done,
    required String byMemberId,
  }) async {
    final id = checkInId(habit.id, day);
    if (done) {
      _checkIns[id] = CheckIn(
        habitId: habit.id,
        day: day,
        checkedInBy: byMemberId,
      );
    } else {
      _checkIns.remove(id);
    }
    _emit();
  }

  @override
  Future<String> createPairingCode(
    PairingKind kind, {
    List<String> memberIds = const [],
  }) async {
    final code = generatePairingCode();
    onPairingCode?.call(code, kind, memberIds);
    return code;
  }

  @override
  String newId() => 'local-${_nextId++}';
}

/// Letters and digits that can't be mixed up when read aloud or typed
/// (no 0/O, 1/I/L).
const pairingAlphabet = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
const pairingCodeLength = 8;

/// How long a pairing code works.
const pairingCodeLifetime = Duration(hours: 24);

String generatePairingCode([Random? random]) {
  final r = random ?? Random.secure();
  return List.generate(
    pairingCodeLength,
    (_) => pairingAlphabet[r.nextInt(pairingAlphabet.length)],
  ).join();
}

/// Uppercases and strips spaces and dashes from a typed code.
String normalizePairingCode(String input) =>
    input.toUpperCase().replaceAll(RegExp(r'[\s-]'), '');
