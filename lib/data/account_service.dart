import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/family.dart';
import 'family_repository.dart';
import 'firestore_family_repository.dart';

/// What an account may do in its family.
enum AccountRole {
  /// A parent's own sign-in. Can manage everything.
  parent,

  /// A paired child's device or shared device. Can use only [Session.memberIds].
  device,
}

class Session {
  const Session({
    required this.uid,
    required this.familyId,
    required this.role,
    this.memberId,
    this.memberIds = const [],
  });

  final String uid;
  final String familyId;
  final AccountRole role;

  /// The parent's own profile.
  final String? memberId;

  /// Profiles a paired device may open.
  final List<String> memberIds;

  bool get isParent => role == AccountRole.parent;
}

sealed class AccountState {
  const AccountState();
}

class SignedOut extends AccountState {
  const SignedOut();
}

/// Signed in as a parent who hasn't created or joined a family yet.
class NeedsFamily extends AccountState {
  const NeedsFamily(this.uid, this.email);
  final String uid;
  final String? email;
}

class Ready extends AccountState {
  const Ready(this.session);
  final Session session;
}

/// Why an account action failed, in terms the app can explain.
enum AccountError {
  wrongPassword,
  emailInUse,
  weakPassword,
  invalidEmail,
  codeNotFound,
  codeExpired,
  codeWrongKind,
  needsRecentLogin,
  network,
  unknown,
}

class AccountException implements Exception {
  const AccountException(this.error);
  final AccountError error;

  @override
  String toString() => 'AccountException($error)';
}

abstract class AccountService {
  Stream<AccountState> watch();

  Future<void> signUp(String email, String password);
  Future<void> signIn(String email, String password);
  Future<void> sendPasswordReset(String email);
  Future<void> signOut();

  Future<void> createFamily({
    required String familyName,
    required String nickname,
  });
  Future<void> joinAsCoParent({required String code, required String nickname});

  /// Joins this device to a family with a code from a parent.
  Future<void> pairDevice(String code);

  /// Deletes this account. The family's owner also deletes the whole family.
  Future<void> deleteAccount();

  FamilyRepository repositoryFor(Session session);
}

class FirebaseAccountService implements AccountService {
  FirebaseAccountService(this._auth, this._db, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  final DateTime Function() _clock;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  @override
  Stream<AccountState> watch() => _auth.authStateChanges().asyncExpand((user) {
    if (user == null) return Stream.value(const SignedOut());
    return _userDoc(user.uid).snapshots().map((s) {
      final data = s.data();
      if (data == null) return NeedsFamily(user.uid, user.email);
      final role =
          AccountRole.values.asNameMap()[data['role']] ?? AccountRole.device;
      return Ready(
        Session(
          uid: user.uid,
          familyId: data['familyId'] as String,
          role: role,
          memberId: data['memberId'] as String?,
          memberIds: [...?(data['memberIds'] as List?)?.cast<String>()],
        ),
      );
    });
  });

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (e) {
      throw AccountException(switch (e.code) {
        'wrong-password' ||
        'invalid-credential' ||
        'user-not-found' => AccountError.wrongPassword,
        'email-already-in-use' => AccountError.emailInUse,
        'weak-password' => AccountError.weakPassword,
        'invalid-email' => AccountError.invalidEmail,
        'requires-recent-login' => AccountError.needsRecentLogin,
        'network-request-failed' => AccountError.network,
        _ => AccountError.unknown,
      });
    } on FirebaseException catch (e) {
      throw AccountException(
        e.code == 'unavailable' ? AccountError.network : AccountError.unknown,
      );
    }
  }

  @override
  Future<void> signUp(String email, String password) => _guard(
    () => _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    ),
  );

  @override
  Future<void> signIn(String email, String password) => _guard(
    () => _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    ),
  );

  @override
  Future<void> sendPasswordReset(String email) =>
      _guard(() => _auth.sendPasswordResetEmail(email: email.trim()));

  @override
  Future<void> signOut() => _auth.signOut();

  String get _uid => _auth.currentUser!.uid;

  // Writes happen in this order because each security rule checks the
  // previous write: the family names its owner, the user record points at a
  // family the user owns, and only then may the user add members.
  @override
  Future<void> createFamily({
    required String familyName,
    required String nickname,
  }) => _guard(() async {
    final uid = _uid;
    final family = _db.collection('families').doc();
    final memberId = family.collection('members').doc().id;
    await family.set({
      'name': familyName.trim(),
      'ownerUid': uid,
      'weekStart': null,
    });
    await _userDoc(uid).set({
      'familyId': family.id,
      'role': AccountRole.parent.name,
      'memberId': memberId,
    });
    await family
        .collection('members')
        .doc(memberId)
        .set(
          Member(
            id: memberId,
            nickname: nickname.trim(),
            role: MemberRole.parent,
            hasOwnDevice: true,
            uid: uid,
          ).toMap(),
        );
  });

  Future<Map<String, dynamic>> _readCode(String code, PairingKind kind) async {
    final snap = await _db
        .collection('pairingCodes')
        .doc(normalizePairingCode(code))
        .get();
    final data = snap.data();
    if (data == null) throw const AccountException(AccountError.codeNotFound);
    if (data['kind'] != kind.name) {
      throw const AccountException(AccountError.codeWrongKind);
    }
    final expires = (data['expiresAt'] as Timestamp).toDate();
    if (!_clock().isBefore(expires)) {
      throw const AccountException(AccountError.codeExpired);
    }
    return data;
  }

  @override
  Future<void> joinAsCoParent({
    required String code,
    required String nickname,
  }) => _guard(() async {
    final uid = _uid;
    final normalized = normalizePairingCode(code);
    final data = await _readCode(normalized, PairingKind.coParent);
    final familyId = data['familyId'] as String;
    final members = _db
        .collection('families')
        .doc(familyId)
        .collection('members');
    final memberId = members.doc().id;
    await _userDoc(uid).set({
      'familyId': familyId,
      'role': AccountRole.parent.name,
      'memberId': memberId,
      'inviteCode': normalized,
    });
    await members
        .doc(memberId)
        .set(
          Member(
            id: memberId,
            nickname: nickname.trim(),
            role: MemberRole.parent,
            hasOwnDevice: true,
            uid: uid,
          ).toMap(),
        );
    await _db.collection('pairingCodes').doc(normalized).delete();
  });

  @override
  Future<void> pairDevice(String code) => _guard(() async {
    if (_auth.currentUser == null) await _auth.signInAnonymously();
    final uid = _uid;
    final normalized = normalizePairingCode(code);
    final data = await _readCode(normalized, PairingKind.device);
    await _userDoc(uid).set({
      'familyId': data['familyId'],
      'role': AccountRole.device.name,
      'memberIds': data['memberIds'],
      'inviteCode': normalized,
    });
    await _db.collection('pairingCodes').doc(normalized).delete();
  });

  @override
  Future<void> deleteAccount() => _guard(() async {
    final user = _auth.currentUser!;
    final record = (await _userDoc(user.uid).get()).data();
    if (record != null) {
      final family = _db
          .collection('families')
          .doc(record['familyId'] as String);
      final info = (await family.get()).data();
      if (info != null && info['ownerUid'] == user.uid) {
        await _deleteFamily(family);
      } else if (record['memberId'] != null) {
        await family
            .collection('members')
            .doc(record['memberId'] as String)
            .delete();
      }
      await _userDoc(user.uid).delete();
    }
    await user.delete();
  });

  Future<void> _deleteFamily(
    DocumentReference<Map<String, dynamic>> family,
  ) async {
    Future<void> deleteAll(Query<Map<String, dynamic>> query) async {
      final docs = (await query.get()).docs;
      for (var i = 0; i < docs.length; i += 400) {
        final batch = _db.batch();
        for (final d in docs.skip(i).take(400)) {
          batch.delete(d.reference);
        }
        await batch.commit();
      }
    }

    await deleteAll(family.collection('checkIns'));
    await deleteAll(family.collection('habits'));
    await deleteAll(family.collection('members'));
    await deleteAll(
      _db.collection('pairingCodes').where('familyId', isEqualTo: family.id),
    );
    // Other parents and paired devices lose access with the family's records.
    final others = await _db
        .collection('users')
        .where('familyId', isEqualTo: family.id)
        .get();
    for (final d in others.docs.where((d) => d.id != _uid)) {
      await d.reference.delete();
    }
    await family.delete();
  }

  @override
  FamilyRepository repositoryFor(Session session) => FirestoreFamilyRepository(
    _db,
    familyId: session.familyId,
    uid: session.uid,
    clock: _clock,
  );
}
