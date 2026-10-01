import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:family_habits/data/account_service.dart';
import 'package:family_habits/data/family_repository.dart';
import 'package:family_habits/data/firestore_family_repository.dart';
import 'package:family_habits/models/category.dart';
import 'package:family_habits/models/family.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 9, 30, 18);
  DateTime clock() => now;

  group('FirestoreFamilyRepository', () {
    late FakeFirebaseFirestore db;
    late FirestoreFamilyRepository repo;

    setUp(() async {
      db = FakeFirebaseFirestore();
      await db.collection('families').doc('f1').set({
        'name': 'Levis',
        'ownerUid': 'u1',
        'weekStart': null,
      });
      repo = FirestoreFamilyRepository(
        db,
        familyId: 'f1',
        uid: 'u1',
        clock: clock,
      );
    });

    const read = Habit(
      id: 'read',
      name: 'Read',
      owner: PersonalOwner('maya'),
      category: BuiltInRef(BuiltInCategory.study),
      timesPerWeek: 5,
    );

    test('round-trips members, habits and check-ins', () async {
      final consent = DateTime(2026, 9, 1);
      await repo.saveMember(
        Member(
          id: 'maya',
          nickname: 'Maya',
          role: MemberRole.child,
          ageBand: AgeBand.age6to9,
          consentAt: consent,
          consentByUid: 'u1',
        ),
      );
      await repo.saveHabit(read);
      await repo.setCheckIn(
        read,
        DateTime(2026, 9, 30),
        done: true,
        byMemberId: 'maya',
      );

      final snap = await repo.watch().first;
      expect(snap.info.name, 'Levis');
      final maya = snap.members.single;
      expect(maya.ageBand, AgeBand.age6to9);
      expect(maya.consentAt, consent);
      expect(snap.habits.single.ownerMemberId, 'maya');
      expect(snap.habits.single.timesPerWeek, 5);
      expect(snap.checkIns.single.day, DateTime(2026, 9, 30));
      expect(snap.checkIns.single.checkedInBy, 'maya');
    });

    test(
      'checking in twice on one day keeps one record; unchecking removes it',
      () async {
        await repo.setCheckIn(
          read,
          DateTime(2026, 9, 30),
          done: true,
          byMemberId: 'maya',
        );
        await repo.setCheckIn(
          read,
          DateTime(2026, 9, 30),
          done: true,
          byMemberId: 'maya',
        );
        expect(
          (await db.collection('families/f1/checkIns').get()).docs.map(
            (d) => d.id,
          ),
          ['read_2026-09-30'],
        );
        await repo.setCheckIn(
          read,
          DateTime(2026, 9, 30),
          done: false,
          byMemberId: 'maya',
        );
        expect(
          (await db.collection('families/f1/checkIns').get()).docs,
          isEmpty,
        );
      },
    );

    test('loads only the last 60 days of check-ins', () async {
      await repo.setCheckIn(
        read,
        DateTime(2026, 7, 1),
        done: true,
        byMemberId: 'maya',
      );
      await repo.setCheckIn(
        read,
        DateTime(2026, 9, 1),
        done: true,
        byMemberId: 'maya',
      );
      final snap = await repo.watch().first;
      expect(snap.checkIns.map((c) => c.day), [DateTime(2026, 9, 1)]);
    });

    test('removing a member removes their habits and check-ins', () async {
      await repo.saveMember(
        const Member(id: 'maya', nickname: 'Maya', role: MemberRole.child),
      );
      await repo.saveHabit(read);
      await repo.setCheckIn(
        read,
        DateTime(2026, 9, 30),
        done: true,
        byMemberId: 'maya',
      );
      await repo.removeMember('maya');
      final snap = await repo.watch().first;
      expect(snap.members, isEmpty);
      expect(snap.habits, isEmpty);
      expect(snap.checkIns, isEmpty);
    });

    test('pairing codes expire after a day', () async {
      final code = await repo.createPairingCode(
        PairingKind.device,
        memberIds: ['maya'],
      );
      final data = (await db.collection('pairingCodes').doc(code).get())
          .data()!;
      expect(data['familyId'], 'f1');
      expect(data['memberIds'], ['maya']);
      expect(
        (data['expiresAt'] as Timestamp).toDate(),
        now.add(const Duration(hours: 24)),
      );
      expect(code, matches(RegExp('^[$pairingAlphabet]{8}\$')));
    });
  });

  group('FirebaseAccountService', () {
    late FakeFirebaseFirestore db;
    late MockFirebaseAuth auth;
    late FirebaseAccountService service;

    setUp(() {
      db = FakeFirebaseFirestore();
      auth = MockFirebaseAuth(
        mockUser: MockUser(uid: 'parent1', email: 'a@example.com'),
      );
      service = FirebaseAccountService(auth, db, clock: clock);
    });

    Future<Session> readySession() async {
      final state = await service.watch().firstWhere((s) => s is Ready);
      return (state as Ready).session;
    }

    void useSignedInParent() {
      auth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'parent1', email: 'a@example.com'),
      );
      service = FirebaseAccountService(auth, db, clock: clock);
    }

    test('a new parent creates a family and becomes its owner', () async {
      useSignedInParent();
      await service.createFamily(familyName: ' Levis ', nickname: 'Abba');

      final session = await readySession();
      expect(session.isParent, isTrue);
      final family =
          (await db.collection('families').doc(session.familyId).get()).data()!;
      expect(family['name'], 'Levis');
      expect(family['ownerUid'], 'parent1');
      final me =
          (await db
                  .doc(
                    'families/${session.familyId}/members/${session.memberId}',
                  )
                  .get())
              .data()!;
      expect(me['role'], 'parent');
      expect(me['uid'], 'parent1');
    });

    Future<String> familyWithCode(
      PairingKind kind, {
      Duration age = Duration.zero,
    }) async {
      await db.collection('families').doc('f1').set({
        'name': 'Levis',
        'ownerUid': 'owner',
      });
      final repo = FirestoreFamilyRepository(
        db,
        familyId: 'f1',
        uid: 'owner',
        clock: () => now.subtract(age),
      );
      return repo.createPairingCode(
        kind,
        memberIds: kind == PairingKind.device ? ['maya'] : [],
      );
    }

    void useTablet() {
      auth = MockFirebaseAuth(
        mockUser: MockUser(uid: 'tablet', isAnonymous: true),
      );
      service = FirebaseAccountService(auth, db, clock: clock);
    }

    test('a device pairs with a code, which then stops working', () async {
      useTablet();
      final code = await familyWithCode(PairingKind.device);
      await service.pairDevice(code.toLowerCase());
      final session = await readySession();
      expect(session.role, AccountRole.device);
      expect(session.familyId, 'f1');
      expect(session.memberIds, ['maya']);
      expect(
        (await db.collection('pairingCodes').doc(code).get()).exists,
        isFalse,
      );
    });

    test('expired, unknown and wrong-kind codes are refused', () async {
      final expired = await familyWithCode(
        PairingKind.device,
        age: const Duration(hours: 25),
      );
      final invite = await familyWithCode(PairingKind.coParent);
      useTablet();
      Future<void> pair(String code) => service.pairDevice(code);
      expect(
        pair(expired),
        throwsA(
          isA<AccountException>().having(
            (e) => e.error,
            'error',
            AccountError.codeExpired,
          ),
        ),
      );
      expect(
        pair('ZZZZZZZZ'),
        throwsA(
          isA<AccountException>().having(
            (e) => e.error,
            'error',
            AccountError.codeNotFound,
          ),
        ),
      );
      expect(
        pair(invite),
        throwsA(
          isA<AccountException>().having(
            (e) => e.error,
            'error',
            AccountError.codeWrongKind,
          ),
        ),
      );
    });

    test('a second parent joins with an invite code', () async {
      final code = await familyWithCode(PairingKind.coParent);
      await service.signUp('b@example.com', 'secret1');
      await service.joinAsCoParent(code: code, nickname: 'Ima');
      final session = await readySession();
      expect(session.isParent, isTrue);
      expect(session.familyId, 'f1');
      final me = (await db.doc('families/f1/members/${session.memberId}').get())
          .data()!;
      expect(me['nickname'], 'Ima');
    });

    test('the owner deleting their account deletes the whole family', () async {
      useSignedInParent();
      await service.createFamily(familyName: 'Levis', nickname: 'Abba');
      final session = await readySession();
      final repo = service.repositoryFor(session);
      await repo.saveMember(
        const Member(id: 'maya', nickname: 'Maya', role: MemberRole.child),
      );
      await repo.saveHabit(
        const Habit(
          id: 'h',
          name: 'Read',
          owner: PersonalOwner('maya'),
          category: BuiltInRef(BuiltInCategory.study),
        ),
      );
      await db.collection('users').doc('tablet').set({
        'familyId': session.familyId,
        'role': 'device',
      });

      await service.deleteAccount();
      expect(
        (await db.collection('families').doc(session.familyId).get()).exists,
        isFalse,
      );
      expect(
        (await db.collection('families/${session.familyId}/members').get())
            .docs,
        isEmpty,
      );
      expect(
        (await db.collection('families/${session.familyId}/habits').get()).docs,
        isEmpty,
      );
      expect((await db.collection('users').get()).docs, isEmpty);
    });
  });
}
