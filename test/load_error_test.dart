import 'dart:async';

import 'package:family_habits/app.dart';
import 'package:family_habits/data/family_repository.dart';
import 'package:family_habits/data/family_store.dart';
import 'package:family_habits/data/in_memory_accounts.dart';
import 'package:family_habits/data/sample_family.dart';
import 'package:family_habits/l10n/app_localizations.dart';
import 'package:family_habits/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Refuses the first attempt to load, like Firestore does when
/// the rules can't see the user's record yet.
class _FlakyRepository implements FamilyRepository {
  _FlakyRepository(this._inner);

  final FamilyRepository _inner;
  int failures = 1;

  @override
  Stream<FamilySnapshot> watch() {
    if (failures > 0) {
      failures--;
      return Stream.error(StateError('permission-denied'));
    }
    return _inner.watch();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('a family that fails to load shows a message and can retry', (
    tester,
  ) async {
    final store = FamilyStore(
      repository: _FlakyRepository(sampleRepository()),
      access: const DeviceAccess.parent(myMemberId: 'dad'),
    );
    addTearDown(store.dispose);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: HomeScreen(
          store: store,
          settings: AppSettings(),
          accounts: InMemoryAccountService(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.textContaining("Couldn't load your family"), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);

    await tester.tap(find.byKey(const Key('retry')));
    await tester.pumpAndSettle();

    expect(find.textContaining("Couldn't load your family"), findsNothing);
    expect(find.text('Demo family'), findsOneWidget);
  });
}
