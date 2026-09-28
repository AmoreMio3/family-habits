import 'package:flutter/material.dart';

import '../data/family_store.dart';
import '../l10n/app_localizations.dart';
import '../logic/progress.dart';

/// The shared family bar. Segments follow reading direction, so the bar fills
/// from the right in Hebrew and Arabic.
class FamilyProgressCard extends StatelessWidget {
  const FamilyProgressCard({
    super.key,
    required this.store,
    required this.weekStart,
  });

  final FamilyStore store;
  final DateTime weekStart;

  static const _familyColor = Color(0xFFD9961A);
  static const _memberColors = [
    Color(0xFF1D6F55),
    Color(0xFF3C9C7C),
    Color(0xFF5A62C9),
    Color(0xFF8C92E0),
    Color(0xFFC2185B),
    Color(0xFF0097A7),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final progress = familyProgress(store.habits, store.checkIns, weekStart);
    final percent = (progress.fraction * 100).round();

    final segments = <(String, Color, int)>[
      for (final (i, m) in store.members.indexed)
        (
          m.nickname,
          _memberColors[i % _memberColors.length],
          progress.byOwner[m.id] ?? 0,
        ),
      (l10n.familyHabits, _familyColor, progress.byOwner[familyKey] ?? 0),
    ];
    final remaining = progress.target - progress.done;

    return Card(
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.familyWeek,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Text(
                  '$percent%',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: SizedBox(
                height: 12,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (_, color, value) in segments)
                      if (value > 0)
                        Expanded(
                          flex: value,
                          child: ColoredBox(color: color),
                        ),
                    if (remaining > 0)
                      Expanded(
                        flex: remaining,
                        child: ColoredBox(color: theme.colorScheme.surface),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                for (final (name, color, _) in segments)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(name, style: theme.textTheme.bodySmall),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l10n.checkInsProgress(progress.done, progress.target),
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
