import 'package:flutter/material.dart';

import '../data/family_store.dart';
import '../l10n/app_localizations.dart';
import '../logic/progress.dart';
import 'common.dart';
import 'look.dart';

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final look = Look.of(context);
    final progress = familyProgress(store.habits, store.checkIns, weekStart);
    final percent = (progress.fraction * 100).round();

    final segments = <(String, Color, int)>[
      for (final m in store.members)
        (
          m.nickname,
          memberColor(context, store, m.id),
          progress.byOwner[m.id] ?? 0,
        ),
      (l10n.familyHabits, look.familyColor, progress.byOwner[familyKey] ?? 0),
    ];
    final remaining = progress.target - progress.done;
    final radius = BorderRadius.circular(look.radius + 4);

    return Container(
      decoration: BoxDecoration(
        gradient: look.hero,
        borderRadius: radius,
        border: look.borderWidth > 0
            ? Border.all(color: look.border, width: look.borderWidth)
            : null,
        boxShadow: look.shadows,
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 10, 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.familyWeek,
                        style: look.heading(22, color: look.heroInk),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.checkInsProgress(progress.done, progress.target),
                        style: TextStyle(
                          color: look.heroInk.withValues(alpha: 0.85),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 76,
                  height: 76,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.expand(
                        child: CircularProgressIndicator(
                          value: progress.fraction,
                          strokeWidth: 8,
                          strokeCap: StrokeCap.round,
                          color: look.heroInk,
                          backgroundColor: look.heroInk.withValues(alpha: 0.25),
                        ),
                      ),
                      Text(
                        '$percent%',
                        style: look.heading(20, color: look.heroInk),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            decoration: BoxDecoration(
              color: look.card,
              borderRadius: BorderRadius.circular(look.radius - 4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: SizedBox(
                    height: 14,
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
                            child: ColoredBox(
                              color: look.muted.withValues(alpha: 0.14),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 14,
                  runSpacing: 6,
                  children: [
                    for (final (name, color, value) in segments)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '$name $value',
                            style: TextStyle(
                              color: look.ink,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
