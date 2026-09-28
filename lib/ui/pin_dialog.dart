import 'package:flutter/material.dart';

import '../data/family_store.dart';
import '../l10n/app_localizations.dart';
import '../models/family.dart';

/// Asks for [member]'s PIN. Returns true when it matches.
Future<bool> askPin(
  BuildContext context,
  FamilyStore store,
  Member member,
) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => _PinDialog(store: store, member: member),
  );
  return ok ?? false;
}

/// Asks a parent for a new 4-digit PIN. Returns null when cancelled.
Future<String?> choosePin(BuildContext context) =>
    showDialog<String>(context: context, builder: (_) => const _PinDialog());

class _PinDialog extends StatefulWidget {
  const _PinDialog({this.store, this.member});

  final FamilyStore? store;
  final Member? member;

  @override
  State<_PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<_PinDialog> {
  final _pin = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  void _submit() {
    final pin = _pin.text;
    if (pin.length != 4) return;
    final member = widget.member;
    if (member == null) {
      Navigator.pop(context, pin);
    } else if (widget.store!.checkPin(member, pin)) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _error = AppLocalizations.of(context).pinWrong;
        _pin.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(
        widget.member == null
            ? l10n.setPin
            : '${l10n.pinTitle} · ${widget.member!.nickname}',
      ),
      content: TextField(
        key: const Key('pin'),
        controller: _pin,
        autofocus: true,
        obscureText: true,
        maxLength: 4,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 28, letterSpacing: 12),
        decoration: InputDecoration(errorText: _error, counterText: ''),
        onChanged: (v) {
          if (v.length == 4) _submit();
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}
