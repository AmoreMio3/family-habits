import 'dart:ui';

import 'package:family_habits/logic/week.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('firstDayOfWeek', () {
    test('Sunday-first locales', () {
      for (final l in const [
        Locale('en'),
        Locale('en', 'US'),
        Locale('he'),
        Locale('he', 'IL'),
        Locale('ar', 'SA'),
        Locale('pt', 'BR'),
        Locale('hi'),
        Locale('zh', 'TW'),
      ]) {
        expect(firstDayOfWeek(l), DateTime.sunday, reason: '$l');
      }
    });

    test('Monday-first locales', () {
      for (final l in const [
        Locale('en', 'GB'),
        Locale('es'),
        Locale('es', '419'),
        Locale('zh'),
        Locale('fr'),
        Locale('de'),
        Locale('it'),
      ]) {
        expect(firstDayOfWeek(l), DateTime.monday, reason: '$l');
      }
    });
  });

  group('startOfWeek', () {
    // Wednesday 30 September 2026.
    final wednesday = DateTime(2026, 9, 30, 15, 45);

    test('Sunday start', () {
      expect(startOfWeek(wednesday, DateTime.sunday), DateTime(2026, 9, 27));
    });

    test('Monday start', () {
      expect(startOfWeek(wednesday, DateTime.monday), DateTime(2026, 9, 28));
    });

    test('the first day is its own week start', () {
      expect(
        startOfWeek(DateTime(2026, 9, 27), DateTime.sunday),
        DateTime(2026, 9, 27),
      );
    });

    test('isInWeek covers exactly seven days', () {
      final start = DateTime(2026, 9, 27);
      expect(isInWeek(DateTime(2026, 9, 26), start), isFalse);
      expect(isInWeek(DateTime(2026, 9, 27), start), isTrue);
      expect(isInWeek(DateTime(2026, 10, 3, 23, 59), start), isTrue);
      expect(isInWeek(DateTime(2026, 10, 4), start), isFalse);
    });
  });
}
