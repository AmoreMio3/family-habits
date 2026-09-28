import 'package:flutter/material.dart';

import '../../app.dart';
import '../../data/account_service.dart';
import '../../l10n/app_localizations.dart';
import '../common.dart';

/// A signed-in parent creates a family or joins their partner's.
class FamilySetupScreen extends StatefulWidget {
  const FamilySetupScreen({
    super.key,
    required this.accounts,
    required this.settings,
  });

  final AccountService accounts;
  final AppSettings settings;

  @override
  State<FamilySetupScreen> createState() => _FamilySetupScreenState();
}

class _FamilySetupScreenState extends State<FamilySetupScreen> with BusyAction {
  final _familyName = TextEditingController();
  final _nickname = TextEditingController();
  final _code = TextEditingController();
  var _joining = false;

  @override
  void dispose() {
    _familyName.dispose();
    _nickname.dispose();
    _code.dispose();
    super.dispose();
  }

  bool get _valid =>
      _nickname.text.trim().isNotEmpty &&
      (_joining
          ? _code.text.trim().isNotEmpty
          : _familyName.text.trim().isNotEmpty);

  Future<void> _submit() => run(
    () => _joining
        ? widget.accounts.joinAsCoParent(
            code: _code.text,
            nickname: _nickname.text,
          )
        : widget.accounts.createFamily(
            familyName: _familyName.text,
            nickname: _nickname.text,
          ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    InputDecoration field(String label) =>
        InputDecoration(labelText: label, border: const OutlineInputBorder());
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.setUpFamily),
        actions: [
          LanguageMenu(settings: widget.settings),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l10n.signOut,
            onPressed: widget.accounts.signOut,
          ),
        ],
      ),
      body: FormPage(
        children: [
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: false, label: Text(l10n.createFamily)),
              ButtonSegment(value: true, label: Text(l10n.joinFamily)),
            ],
            selected: {_joining},
            onSelectionChanged: (s) => setState(() => _joining = s.first),
          ),
          const SizedBox(height: 20),
          if (_joining)
            TextField(
              key: const Key('inviteCode'),
              controller: _code,
              textCapitalization: TextCapitalization.characters,
              decoration: field(l10n.inviteCode),
              onChanged: (_) => setState(() {}),
            )
          else
            TextField(
              key: const Key('familyName'),
              controller: _familyName,
              textCapitalization: TextCapitalization.words,
              decoration: field(l10n.familyName),
              onChanged: (_) => setState(() {}),
            ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('nickname'),
            controller: _nickname,
            textCapitalization: TextCapitalization.words,
            decoration: field(l10n.yourName),
            onChanged: (_) => setState(() {}),
          ),
          ErrorLine(errorText),
          const SizedBox(height: 20),
          BusyButton(
            label: l10n.continueAction,
            busy: busy,
            onPressed: _valid ? _submit : null,
          ),
        ],
      ),
    );
  }
}
