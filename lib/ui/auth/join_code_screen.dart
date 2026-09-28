import 'package:flutter/material.dart';

import '../../data/account_service.dart';
import '../../l10n/app_localizations.dart';
import '../common.dart';

/// Joins this device to a family with a code a parent created.
class JoinCodeScreen extends StatefulWidget {
  const JoinCodeScreen({super.key, required this.accounts});

  final AccountService accounts;

  @override
  State<JoinCodeScreen> createState() => _JoinCodeScreenState();
}

class _JoinCodeScreenState extends State<JoinCodeScreen> with BusyAction {
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _join() async {
    final ok = await run(() => widget.accounts.pairDevice(_code.text));
    if (ok && mounted) Navigator.of(context).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.joinWithCode)),
      body: FormPage(
        children: [
          Text(l10n.enterCode, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          TextField(
            key: const Key('code'),
            controller: _code,
            textCapitalization: TextCapitalization.characters,
            style: const TextStyle(fontSize: 24, letterSpacing: 4),
            decoration: InputDecoration(
              labelText: l10n.pairCode,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _join(),
          ),
          ErrorLine(errorText),
          const SizedBox(height: 20),
          BusyButton(label: l10n.join, busy: busy, onPressed: _join),
        ],
      ),
    );
  }
}
