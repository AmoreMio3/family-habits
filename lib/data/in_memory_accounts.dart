import 'dart:async';

import '../models/family.dart';
import 'account_service.dart';
import 'family_repository.dart';
import 'sample_family.dart';

/// Accounts kept in memory. Runs the whole app, sign-up and pairing
/// included, before Firebase is connected, and backs the widget tests.
/// Nothing survives a restart.
class InMemoryAccountService implements AccountService {
  InMemoryAccountService({DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  final _passwords = <String, String>{};
  final _uids = <String, String>{};
  final _records = <String, Session>{};
  final families = <String, InMemoryFamilyRepository>{};
  final _codes =
      <
        String,
        ({
          String familyId,
          PairingKind kind,
          List<String> memberIds,
          DateTime expiresAt,
        })
      >{};
  final _controller = StreamController<AccountState>.broadcast();
  String? _currentUid;
  String? _currentEmail;
  var _next = 0;

  AccountState get state {
    final uid = _currentUid;
    if (uid == null) return const SignedOut();
    final session = _records[uid];
    return session == null ? NeedsFamily(uid, _currentEmail) : Ready(session);
  }

  void _emit() => _controller.add(state);

  @override
  Stream<AccountState> watch() async* {
    yield state;
    yield* _controller.stream;
  }

  /// Opens the example family as a parent.
  Future<void> openDemo() async {
    families.putIfAbsent(
      'demo',
      () => _trackCodes(sampleRepository(clock: _clock), 'demo'),
    );
    _currentUid = 'demo-parent';
    _currentEmail = null;
    _records['demo-parent'] = const Session(
      uid: 'demo-parent',
      familyId: 'demo',
      role: AccountRole.parent,
      memberId: 'dad',
    );
    _emit();
  }

  bool isDemo(Session session) => session.familyId == 'demo';

  @override
  Future<void> signUp(String email, String password) async {
    final key = email.trim().toLowerCase();
    if (!key.contains('@')) {
      throw const AccountException(AccountError.invalidEmail);
    }
    if (_passwords.containsKey(key)) {
      throw const AccountException(AccountError.emailInUse);
    }
    if (password.length < 6) {
      throw const AccountException(AccountError.weakPassword);
    }
    _passwords[key] = password;
    _uids[key] = 'user-${_next++}';
    _currentUid = _uids[key];
    _currentEmail = key;
    _emit();
  }

  @override
  Future<void> signIn(String email, String password) async {
    final key = email.trim().toLowerCase();
    if (_passwords[key] != password) {
      throw const AccountException(AccountError.wrongPassword);
    }
    _currentUid = _uids[key];
    _currentEmail = key;
    _emit();
  }

  @override
  Future<void> sendPasswordReset(String email) async {}

  @override
  Future<void> signOut() async {
    _currentUid = null;
    _currentEmail = null;
    _emit();
  }

  @override
  Future<void> createFamily({
    required String familyName,
    required String nickname,
  }) async {
    final uid = _currentUid!;
    final familyId = 'family-${_next++}';
    final memberId = 'member-${_next++}';
    families[familyId] = _trackCodes(
      InMemoryFamilyRepository(
        info: FamilyInfo(id: familyId, name: familyName.trim(), ownerUid: uid),
        members: [
          Member(
            id: memberId,
            nickname: nickname.trim(),
            role: MemberRole.parent,
            hasOwnDevice: true,
            uid: uid,
          ),
        ],
      ),
      familyId,
    );
    _records[uid] = Session(
      uid: uid,
      familyId: familyId,
      role: AccountRole.parent,
      memberId: memberId,
    );
    _emit();
  }

  ({
    String familyId,
    PairingKind kind,
    List<String> memberIds,
    DateTime expiresAt,
  })
  _take(String code, PairingKind kind) {
    final entry = _codes[normalizePairingCode(code)];
    if (entry == null) throw const AccountException(AccountError.codeNotFound);
    if (entry.kind != kind) {
      throw const AccountException(AccountError.codeWrongKind);
    }
    if (!_clock().isBefore(entry.expiresAt)) {
      throw const AccountException(AccountError.codeExpired);
    }
    _codes.remove(normalizePairingCode(code));
    return entry;
  }

  @override
  Future<void> joinAsCoParent({
    required String code,
    required String nickname,
  }) async {
    final uid = _currentUid!;
    final entry = _take(code, PairingKind.coParent);
    final memberId = 'member-${_next++}';
    await families[entry.familyId]!.saveMember(
      Member(
        id: memberId,
        nickname: nickname.trim(),
        role: MemberRole.parent,
        hasOwnDevice: true,
        uid: uid,
      ),
    );
    _records[uid] = Session(
      uid: uid,
      familyId: entry.familyId,
      role: AccountRole.parent,
      memberId: memberId,
    );
    _emit();
  }

  @override
  Future<void> pairDevice(String code) async {
    final entry = _take(code, PairingKind.device);
    final uid = _currentUid ??= 'device-${_next++}';
    _records[uid] = Session(
      uid: uid,
      familyId: entry.familyId,
      role: AccountRole.device,
      memberIds: entry.memberIds,
    );
    _emit();
  }

  @override
  Future<void> deleteAccount() async {
    final uid = _currentUid;
    if (uid == null) return;
    final session = _records.remove(uid);
    if (session != null) {
      final family = families[session.familyId];
      if (family != null && family.current.info.ownerUid == uid) {
        families.remove(session.familyId);
        _records.removeWhere((_, s) => s.familyId == session.familyId);
      } else if (session.memberId != null) {
        await family?.removeMember(session.memberId!);
      }
    }
    _passwords.remove(_currentEmail);
    _uids.remove(_currentEmail);
    _currentUid = null;
    _currentEmail = null;
    _emit();
  }

  @override
  FamilyRepository repositoryFor(Session session) =>
      families[session.familyId]!;

  InMemoryFamilyRepository _trackCodes(
    InMemoryFamilyRepository repo,
    String familyId,
  ) {
    repo.onPairingCode = (code, kind, memberIds) {
      _codes[code] = (
        familyId: familyId,
        kind: kind,
        memberIds: memberIds,
        expiresAt: _clock().add(pairingCodeLifetime),
      );
    };
    return repo;
  }
}
