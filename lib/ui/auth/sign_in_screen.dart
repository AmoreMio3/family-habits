import 'package:flutter/material.dart';

import '../../data/account_service.dart';
import '../../l10n/app_localizations.dart';
import '../common.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.accounts});

  final AccountService accounts;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with BusyAction {
  final _email = TextEditingController();
  final _password = TextEditingController();
  var _creating = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await run(
      () => _creating
          ? widget.accounts.signUp(_email.text, _password.text)
          : widget.accounts.signIn(_email.text, _password.text),
    );
    if (ok && mounted) Navigator.of(context).popUntil((r) => r.isFirst);
  }

  Future<void> _reset() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await run(() => widget.accounts.sendPasswordReset(_email.text));
    if (ok) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.passwordResetSent(_email.text.trim()))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(_creating ? l10n.createAccount : l10n.signIn)),
      body: FormPage(
        children: [
          TextField(
            key: const Key('email'),
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(
              labelText: l10n.email,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('password'),
            controller: _password,
            obscureText: true,
            autofillHints: [
              _creating ? AutofillHints.newPassword : AutofillHints.password,
            ],
            decoration: InputDecoration(
              labelText: l10n.password,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(),
          ),
          ErrorLine(errorText),
          const SizedBox(height: 20),
          BusyButton(
            label: _creating ? l10n.createAccount : l10n.signIn,
            busy: busy,
            onPressed: _submit,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => setState(() {
              _creating = !_creating;
              errorText = null;
            }),
            child: Text(_creating ? l10n.haveAccount : l10n.newHere),
          ),
          if (!_creating)
            TextButton(onPressed: _reset, child: Text(l10n.forgotPassword)),
        ],
      ),
    );
  }
}
