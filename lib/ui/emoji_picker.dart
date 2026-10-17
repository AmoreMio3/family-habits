import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'common.dart';
import 'look.dart';

/// Emoji offered for a habit's picture, roughly in the order of the
/// categories. Any other emoji can be typed in.
const habitEmoji = [
  '💧', '💊', '🍎', '🥗', '🥦', '🍳', '☕', '🚭', '📵', '🍬', //
  '😴', '🛏️', '🌙', '🏃', '🚴', '🏊', '⚽', '🏀', '🧘', '💪', //
  '🪥', '🚿', '🧴', '💅', '🙏', '🌿', '❤️', '👨‍👩‍👧', '🤗', '🍽️', //
  '🎲', '🧹', '🧺', '🌱', '🐶', '📚', '✏️', '🎓', '💻', '📝', //
  '💰', '🐷', '🌳', '🏕️', '🚶', '🎨', '🎸', '🎻', '🎹', '📷', //
  '🧩', '🎮', '🎬', '⭐', '🌈', '🔥', '✅', '🏆', '🎯', '😊', //
];

/// Returns the emoji picked, '' to go back to the category icon, or null
/// when the sheet was closed without a choice.
Future<String?> pickHabitEmoji(
  BuildContext context, {
  required String? current,
  required IconData categoryIcon,
  required Color categoryColor,
}) => showModalBottomSheet<String>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _EmojiSheet(
    current: current,
    categoryIcon: categoryIcon,
    categoryColor: categoryColor,
  ),
);

class _EmojiSheet extends StatefulWidget {
  const _EmojiSheet({
    required this.current,
    required this.categoryIcon,
    required this.categoryColor,
  });

  final String? current;
  final IconData categoryIcon;
  final Color categoryColor;

  @override
  State<_EmojiSheet> createState() => _EmojiSheetState();
}

class _EmojiSheetState extends State<_EmojiSheet> {
  final _typed = TextEditingController();

  @override
  void dispose() {
    _typed.dispose();
    super.dispose();
  }

  /// The first emoji or letter typed, or null for none or a very long one.
  String? get _typedEmoji {
    final text = _typed.text.trim();
    if (text.isEmpty) return null;
    final first = text.characters.first;
    return first.length <= 16 ? first : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final look = Look.of(context);
    Widget tile(Key key, Widget child, String value, bool selected) => InkWell(
      key: key,
      borderRadius: BorderRadius.circular(14),
      onTap: () => Navigator.pop(context, value),
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: selected ? Border.all(color: look.primary, width: 2) : null,
        ),
        child: child,
      ),
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.habitPicture, style: look.heading(20)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                tile(
                  const Key('emoji-none'),
                  Tooltip(
                    message: l10n.useCategoryIcon,
                    child: EmojiBubble(
                      emoji: null,
                      icon: widget.categoryIcon,
                      color: widget.categoryColor,
                      size: 36,
                    ),
                  ),
                  '',
                  widget.current == null,
                ),
                for (final e in habitEmoji)
                  tile(
                    Key('emoji-$e'),
                    Text(
                      e,
                      style: const TextStyle(fontSize: 26, height: 1),
                      textScaler: TextScaler.noScaling,
                    ),
                    e,
                    widget.current == e,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('typedEmoji'),
                    controller: _typed,
                    decoration: InputDecoration(
                      labelText: l10n.typeAnyEmoji,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) {
                      if (_typedEmoji case final e?) Navigator.pop(context, e);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  key: const Key('useTypedEmoji'),
                  onPressed: _typedEmoji == null
                      ? null
                      : () => Navigator.pop(context, _typedEmoji),
                  child: Text(l10n.useThis),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
