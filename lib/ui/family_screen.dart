import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../data/family_repository.dart';
import '../data/family_store.dart';
import '../l10n/app_localizations.dart';
import '../models/family.dart';
import 'common.dart';
import 'look.dart';
import 'member_editor.dart';
import 'progress_screen.dart';

/// Family progress, then the family's settings: members, device codes and
/// the first day of the week.
class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key, required this.store});

  final FamilyStore store;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final manage = store.canManage;
    final children = store.members
        .where((m) => !m.isParent)
        .map((m) => m.id)
        .toList();

    final look = Look.of(context);
    Widget group(List<Widget> tiles) => SoftCard(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(children: tiles),
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      children: [
        SectionTitle(l10n.familyProgress),
        FamilyProgressSection(store: store),
        const SizedBox(height: 12),
        SectionTitle(l10n.familySettings),
        group([
          for (final m in store.sortedMembers)
            ListTile(
              leading: MemberAvatar(
                name: m.nickname,
                color: memberColor(context, store, m.id),
              ),
              title: Text(
                m.nickname,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                m.isParent
                    ? l10n.parent
                    : '${l10n.child} · ${ageBandLabel(l10n, m.ageBand)}',
              ),
              trailing: manage ? const Icon(Icons.edit_outlined) : null,
              onTap: manage
                  ? () => showMemberEditor(context, store, member: m)
                  : null,
            ),
        ]),
        if (manage) ...[
          const SizedBox(height: 4),
          _Action(
            icon: Icons.child_care_rounded,
            color: look.memberColors[2],
            label: l10n.addChild,
            onTap: () => showMemberEditor(context, store),
          ),
          _Action(
            icon: Icons.person_add_alt_rounded,
            color: look.memberColors[1],
            label: l10n.inviteParent,
            onTap: () => showPairingCode(context, store, PairingKind.coParent),
          ),
          if (children.isNotEmpty)
            _Action(
              icon: Icons.tablet_android_rounded,
              color: look.memberColors[3],
              label: l10n.sharedDevice,
              onTap: () => showPairingCode(
                context,
                store,
                PairingKind.device,
                memberIds: children,
              ),
            ),
          group([
            ListTile(
              leading: const Icon(Icons.calendar_view_week_rounded),
              title: Text(l10n.weekStartsOn),
              trailing: _WeekStartMenu(store: store),
            ),
          ]),
        ],
      ],
    );
  }
}

/// Shows a new pairing code for another device.
Future<void> showPairingCode(
  BuildContext context,
  FamilyStore store,
  PairingKind kind, {
  List<String> memberIds = const [],
}) async {
  final l10n = AppLocalizations.of(context);
  final future = store.repository.createPairingCode(kind, memberIds: memberIds);
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        kind == PairingKind.coParent ? l10n.inviteParent : l10n.pairDevice,
      ),
      content: FutureBuilder<String>(
        future: future,
        builder: (context, snap) {
          if (snap.hasError) return Text(accountErrorText(l10n, snap.error!));
          if (!snap.hasData) {
            return const SizedBox(
              height: 80,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final code = snap.data!;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Codes are Latin letters and digits in every language.
              Directionality(
                textDirection: TextDirection.ltr,
                child: SelectableText(
                  '${code.substring(0, 4)} ${code.substring(4)}',
                  key: const Key('pairingCode'),
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(letterSpacing: 4),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                kind == PairingKind.coParent
                    ? l10n.enterCode
                    : l10n.codeInstructions,
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.continueAction),
        ),
      ],
    ),
  );
}

class _WeekStartMenu extends StatelessWidget {
  const _WeekStartMenu({required this.store});

  final FamilyStore store;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    // 27 September 2026 is a Sunday; DateTime weekdays run Monday = 1 .. Sunday = 7.
    String dayName(int weekday) =>
        DateFormat.EEEE(locale).format(DateTime(2026, 9, 27 + weekday % 7));

    return DropdownButton<int?>(
      value: store.info.weekStart,
      underline: const SizedBox.shrink(),
      items: [
        DropdownMenuItem(value: null, child: Text(l10n.weekStartAuto)),
        for (final d in [DateTime.saturday, DateTime.sunday, DateTime.monday])
          DropdownMenuItem(value: d, child: Text(dayName(d))),
      ],
      onChanged: (value) => store.repository.updateFamily(
        FamilyInfo(
          id: store.info.id,
          name: store.info.name,
          ownerUid: store.info.ownerUid,
          weekStart: value,
        ),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final look = Look.of(context);
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: onTap,
      child: Row(
        children: [
          IconBubble(icon: icon, color: color, size: 40),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: look.ink,
              ),
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: look.muted),
        ],
      ),
    );
  }
}
