import 'dart:ui';

import '../models/category.dart';
import '../models/habit_library.dart';
import '../models/habit_library_l10n.dart';

/// One search result: a library habit, or a habit from a family's own category.
class HabitSuggestion {
  const HabitSuggestion({
    required this.name,
    required this.category,
    this.template,
  });

  final String name;
  final CategoryRef category;
  final HabitTemplate? template;
}

/// Finds habits for free text, so "park" suggests "Visit a park" and
/// "Go for a walk", "book" suggests "Read a bedtime story", and "diet"
/// suggests "Eat mindfully".
///
/// Every word typed must match something: a word of the habit's name (in the
/// user's language or English), one of its search keywords, or its category.
/// Words match by prefix, so "hik" finds "Go hiking".
List<HabitSuggestion> searchHabits(
  String query, {
  required Locale locale,
  required String Function(BuiltInCategory) categoryLabel,
  List<CustomCategory> custom = const [],
  bool forChild = false,
  int limit = 8,
}) {
  final tokens = _words(query);
  if (tokens.isEmpty) return const [];

  final scored = <(int, int, HabitSuggestion)>[];
  var rank = 0;
  for (final t in habitTemplates) {
    rank++;
    if (forChild && !suitsChild(t)) continue;
    final name = habitTemplateName(t, locale);
    final score = _score(tokens, [
      (_words(name), 10),
      (_words(t.name), 8),
      // A habit's first keyword is the word it answers best, so "diet"
      // puts "Eat mindfully" first.
      (t.keywords.take(1).toList(), 7),
      (t.keywords, 6),
      if (locale.languageCode == 'he') (hebrewKeywords(t), 6),
      (_words(categoryLabel(t.category)), 3),
    ]);
    if (score == 0) continue;
    scored.add((
      score + (t.recommended ? 1 : 0),
      rank,
      HabitSuggestion(
        name: name,
        category: BuiltInRef(t.category),
        template: t,
      ),
    ));
  }
  for (final c in custom) {
    for (final habit in c.habits) {
      rank++;
      final score = _score(tokens, [(_words(habit), 10), (_words(c.name), 4)]);
      if (score == 0) continue;
      scored.add((
        score + 2,
        rank,
        HabitSuggestion(name: habit, category: CustomRef(c.id)),
      ));
    }
  }
  scored.sort((a, b) => a.$1 != b.$1 ? b.$1 - a.$1 : a.$2 - b.$2);
  return [for (final s in scored.take(limit)) s.$3];
}

/// Parent-only and adult-only habits are left out for a child's profile.
bool suitsChild(HabitTemplate t) =>
    t.audience != Audience.parent && t.audience != Audience.adult;

int _score(List<String> tokens, List<(List<String>, int)> fields) {
  var total = 0;
  for (final token in tokens) {
    var best = 0;
    for (final (words, weight) in fields) {
      for (final word in words) {
        final w = _normalize(word);
        final int s;
        if (w == token) {
          s = weight + 1;
        } else if (w.startsWith(token) ||
            (token.length >= 4 && token.startsWith(w) && w.length >= 3)) {
          s = weight;
        } else {
          s = 0;
        }
        if (s > best) best = s;
      }
    }
    // Hebrew often attaches a one-letter prefix: "הספר" is "the book".
    if (best == 0 && token.length > 3 && _hebrewPrefixes.contains(token[0])) {
      best = _score([token.substring(1)], fields);
    }
    if (best == 0) return 0;
    total += best;
  }
  return total;
}

const _hebrewPrefixes = {'ה', 'ו', 'ב', 'ל', 'מ', 'ש', 'כ'};

List<String> _words(String text) => _normalize(text)
    // "בית ספר" (school) is one idea; don't let "ספר" (book) match it.
    .replaceAllMapped(RegExp('בית (ה?)ספר'), (m) => 'בית${m[1]}ספר')
    .split(RegExp(r'[^\p{L}\p{N}]+', unicode: true))
    .where((w) => w.length > 1)
    .toList();

String _normalize(String text) {
  final lower = text.toLowerCase();
  final out = StringBuffer();
  for (final rune in lower.runes) {
    // Hebrew vowel points and Arabic diacritics.
    if ((rune >= 0x0591 && rune <= 0x05C7) ||
        (rune >= 0x064B && rune <= 0x065F)) {
      continue;
    }
    final c = String.fromCharCode(rune);
    out.write(_accents[c] ?? c);
  }
  return out.toString();
}

const _accents = {
  'á': 'a', 'à': 'a', 'â': 'a', 'ä': 'a', 'ã': 'a', //
  'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e', //
  'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i', //
  'ó': 'o', 'ò': 'o', 'ô': 'o', 'ö': 'o', 'õ': 'o', //
  'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u', //
  'ç': 'c', 'ñ': 'n', 'ß': 'ss',
};
