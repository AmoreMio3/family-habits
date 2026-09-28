import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/family.dart';
import 'family_repository.dart';

/// How far back check-ins are loaded. Covers streaks, this week and last week.
const checkInHistory = Duration(days: 60);

/// Firestore layout (see firestore.rules):
///
///   families/{familyId}                  name, ownerUid, weekStart
///   families/{familyId}/members/{id}     Member
///   families/{familyId}/habits/{id}      Habit
///   families/{familyId}/checkIns/{id}    CheckIn, id = habitId_yyyy-mm-dd
///   users/{uid}                          which family and profiles an account may use
///   pairingCodes/{code}                  short-lived codes to join a family
class FirestoreFamilyRepository implements FamilyRepository {
  FirestoreFamilyRepository(
    this._db, {
    required this.familyId,
    required this.uid,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final FirebaseFirestore _db;
  final String familyId;
  final String uid;
  final DateTime Function() _clock;

  DocumentReference<Map<String, dynamic>> get _family =>
      _db.collection('families').doc(familyId);
  CollectionReference<Map<String, dynamic>> get _members =>
      _family.collection('members');
  CollectionReference<Map<String, dynamic>> get _habits =>
      _family.collection('habits');
  CollectionReference<Map<String, dynamic>> get _checkIns =>
      _family.collection('checkIns');

  @override
  Stream<FamilySnapshot> watch() {
    late StreamController<FamilySnapshot> controller;
    final subs = <StreamSubscription<Object?>>[];
    FamilyInfo? info;
    List<Member>? members;
    List<Habit>? habits;
    List<CheckIn>? checkIns;

    void emit() {
      if (info == null ||
          members == null ||
          habits == null ||
          checkIns == null) {
        return;
      }
      controller.add(
        FamilySnapshot(
          info: info!,
          members: members!,
          habits: habits!,
          checkIns: checkIns!,
        ),
      );
    }

    final today = _clock();
    final since = dayKey(
      DateTime(today.year, today.month, today.day).subtract(checkInHistory),
    );

    controller = StreamController<FamilySnapshot>(
      onListen: () {
        subs
          ..add(
            _family.snapshots().listen((s) {
              info = FamilyInfo.fromMap(s.id, fromFirestore(s.data() ?? {}));
              emit();
            }, onError: controller.addError),
          )
          ..add(
            _members.snapshots().listen((s) {
              members = [
                for (final d in s.docs)
                  Member.fromMap(d.id, fromFirestore(d.data())),
              ];
              emit();
            }, onError: controller.addError),
          )
          ..add(
            _habits.snapshots().listen((s) {
              habits = [
                for (final d in s.docs)
                  Habit.fromMap(d.id, fromFirestore(d.data())),
              ];
              emit();
            }, onError: controller.addError),
          )
          ..add(
            _checkIns
                .where('day', isGreaterThanOrEqualTo: since)
                .snapshots()
                .listen((s) {
                  checkIns = [
                    for (final d in s.docs) CheckIn.fromMap(d.data()),
                  ];
                  emit();
                }, onError: controller.addError),
          );
      },
      onCancel: () async {
        for (final s in subs) {
          await s.cancel();
        }
        subs.clear();
      },
    );
    return controller.stream;
  }

  @override
  Future<void> updateFamily(FamilyInfo info) =>
      _family.update({'name': info.name, 'weekStart': info.weekStart});

  @override
  Future<void> saveMember(Member member) =>
      _members.doc(member.id).set(member.toMap());

  @override
  Future<void> removeMember(String memberId) async {
    final owned = await _habits
        .where('ownerMemberId', isEqualTo: memberId)
        .get();
    final batch = _db.batch();
    for (final habit in owned.docs) {
      final checks = await _checkIns
          .where('habitId', isEqualTo: habit.id)
          .get();
      for (final c in checks.docs) {
        batch.delete(c.reference);
      }
      batch.delete(habit.reference);
    }
    batch.delete(_members.doc(memberId));
    await batch.commit();
  }

  @override
  Future<void> saveHabit(Habit habit) =>
      _habits.doc(habit.id).set(habit.toMap());

  @override
  Future<void> deleteHabit(String habitId) async {
    final checks = await _checkIns.where('habitId', isEqualTo: habitId).get();
    final batch = _db.batch();
    for (final c in checks.docs) {
      batch.delete(c.reference);
    }
    batch.delete(_habits.doc(habitId));
    await batch.commit();
  }

  @override
  Future<void> setCheckIn(
    Habit habit,
    DateTime day, {
    required bool done,
    required String byMemberId,
  }) {
    final ref = _checkIns.doc(checkInId(habit.id, day));
    if (!done) return ref.delete();
    return ref.set(
      CheckIn(habitId: habit.id, day: day, checkedInBy: byMemberId).toMap(),
    );
  }

  @override
  Future<String> createPairingCode(
    PairingKind kind, {
    List<String> memberIds = const [],
  }) async {
    final code = generatePairingCode();
    await _db.collection('pairingCodes').doc(code).set({
      'familyId': familyId,
      'kind': kind.name,
      'memberIds': memberIds,
      'createdBy': uid,
      'expiresAt': Timestamp.fromDate(_clock().add(pairingCodeLifetime)),
    });
    return code;
  }

  @override
  String newId() => _members.doc().id;
}

/// Converts Firestore timestamps to [DateTime] so models stay free of
/// Firestore types.
Map<String, Object?> fromFirestore(Map<String, dynamic> data) => {
  for (final e in data.entries)
    e.key: e.value is Timestamp ? (e.value as Timestamp).toDate() : e.value,
};
