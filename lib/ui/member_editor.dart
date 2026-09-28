import 'package:flutter/material.dart';

import '../data/family_repository.dart';
import '../data/family_store.dart';
import '../l10n/app_localizations.dart';
import '../models/family.dart';
import 'common.dart';
import 'family_screen.dart';
import 'pin_dialog.dart';

/// Adds a child, or edits any member when [member] is given.
Future<void> showMemberEditor(
  BuildContext context,
  FamilyStore store, {
  Member? member,
}) => Navigator.of(context).push(
  MaterialPageRoute<void>(
    fullscreenDialog: true,
    builder: (_) => _MemberEditor(store: store, member: member),
  ),
);

class _MemberEditor extends StatefulWidget {
  const _MemberEditor({required this.store, this.member});

  final FamilyStore store;
  final Member? member;

  @override
  State<_MemberEditor> createState() => _MemberEditorState();
}

class _MemberEditorState extends State<_MemberEditor> {
  late final _nickname = TextEditingController(text: widget.member?.nickname);
  late AgeBand _age = widget.member?.ageBand ?? AgeBand.age6to9;
  late bool _ownDevice = widget.member?.hasOwnDevice ?? false;
  late String? _pinHash = widget.member?.pinHash;
  var _consent = false;

  bool get _isNew => widget.member == null;
  bool get _isChild => widget.member?.isParent != true;
  bool get _valid => _nickname.text.trim().isNotEmpty && (!_isNew || _consent);

  @override
  void dispose() {
    _nickname.dispose();
    super.dispose();
  }

  Member _build() {
    final store = widget.store;
    final existing = widget.member;
    if (existing != null) {
      return existing.copyWith(
        nickname: _nickname.text.trim(),
        ageBand: _age,
        hasOwnDevice: _ownDevice,
        pinHash: _pinHash,
        clearPin: _pinHash == null,
      );
    }
    final me = store.access.myMemberId == null
        ? null
        : store.member(store.access.myMemberId!);
    return Member(
      id: store.repository.newId(),
      nickname: _nickname.text.trim(),
      role: MemberRole.child,
      ageBand: _age,
      hasOwnDevice: _ownDevice,
      pinHash: _pinHash,
      consentAt: DateTime.now(),
      consentByUid: me?.uid,
    );
  }

  Future<void> _save() async {
    await widget.store.repository.saveMember(_build());
    if (mounted) Navigator.pop(context);
  }

  Future<void> _setPin() async {
    final pin = await choosePin(context);
    if (pin == null) return;
    // New members get their id when built, so hash against the final id.
    final id = widget.member?.id;
    if (id == null) {
      final member = _build();
      setState(() => _pinHash = hashPin(member.id, pin));
      await widget.store.repository.saveMember(
        member.copyWith(pinHash: _pinHash),
      );
      if (mounted) Navigator.pop(context);
      return;
    }
    setState(() => _pinHash = hashPin(id, pin));
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final member = widget.member!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.removeMemberConfirm(member.nickname)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await widget.store.repository.removeMember(member.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final member = widget.member;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? l10n.addChild : member!.nickname),
        actions: [
          TextButton(onPressed: _valid ? _save : null, child: Text(l10n.save)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            key: const Key('memberNickname'),
            controller: _nickname,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: l10n.nickname,
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          if (_isChild) ...[
            const SizedBox(height: 20),
            Text(l10n.ageBand, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final band in AgeBand.values.where(
                  (b) => b != AgeBand.adult,
                ))
                  ChoiceChip(
                    label: Text(ageBandLabel(l10n, band)),
                    selected: _age == band,
                    onSelected: (_) => setState(() => _age = band),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.ownDevice),
              value: _ownDevice,
              onChanged: (v) => setState(() => _ownDevice = v),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.pin_outlined),
              title: Text(_pinHash == null ? l10n.setPin : l10n.removePin),
              onTap: _pinHash == null
                  ? (_valid ? _setPin : null)
                  : () => setState(() => _pinHash = null),
            ),
          ],
          if (_isNew) ...[
            const SizedBox(height: 16),
            Card(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.consentTitle, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Text(l10n.consentBody),
                    CheckboxListTile(
                      key: const Key('consent'),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(l10n.consentCheck),
                      value: _consent,
                      onChanged: (v) => setState(() => _consent = v ?? false),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (!_isNew && _isChild) ...[
            const Divider(height: 32),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.smartphone, color: theme.colorScheme.primary),
              title: Text(l10n.pairDevice),
              onTap: () => showPairingCode(
                context,
                widget.store,
                PairingKind.device,
                memberIds: [member!.id],
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.delete_outline,
                color: theme.colorScheme.error,
              ),
              title: Text(
                l10n.delete,
                style: TextStyle(color: theme.colorScheme.error),
              ),
              onTap: _delete,
            ),
          ],
        ],
      ),
    );
  }
}
