import 'package:flutter/material.dart';

import '../data/family_store.dart';
import '../l10n/app_localizations.dart';
import '../models/category.dart';
import '../models/family.dart';

/// Adds a habit, or edits [habit].
Future<void> showHabitEditor(
  BuildContext context,
  FamilyStore store, {
  Habit? habit,
}) => Navigator.of(context).push(
  MaterialPageRoute<void>(
    fullscreenDialog: true,
    builder: (_) => _HabitEditor(store: store, habit: habit),
  ),
);

class _HabitEditor extends StatefulWidget {
  const _HabitEditor({required this.store, this.habit});

  final FamilyStore store;
  final Habit? habit;

  @override
  State<_HabitEditor> createState() => _HabitEditorState();
}

// Owner dropdown value for family habits.
const _familyOwner = '';

class _HabitEditorState extends State<_HabitEditor> {
  late final _name = TextEditingController(text: widget.habit?.name);
  late BuiltInCategory _category =
      widget.habit?.category ?? BuiltInCategory.health;
  late String? _subcategory = widget.habit?.subcategory;
  late String _owner =
      widget.habit?.ownerMemberId ??
      widget.store.activeMember?.id ??
      _familyOwner;
  late int _times = widget.habit?.timesPerWeek ?? 7;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final store = widget.store;
    await store.repository.saveHabit(
      Habit(
        id: widget.habit?.id ?? store.repository.newId(),
        name: _name.text.trim(),
        owner: _owner == _familyOwner
            ? const FamilyOwner()
            : PersonalOwner(_owner),
        category: _category,
        subcategory: _subcategory,
        timesPerWeek: _times,
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final habit = widget.habit!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.deleteHabitConfirm(habit.name)),
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
    await widget.store.repository.deleteHabit(habit.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    InputDecoration field(String label) =>
        InputDecoration(labelText: label, border: const OutlineInputBorder());
    final valid = _name.text.trim().isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit == null ? l10n.addHabit : l10n.editHabit),
        actions: [
          TextButton(onPressed: valid ? _save : null, child: Text(l10n.save)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            key: const Key('habitName'),
            controller: _name,
            textCapitalization: TextCapitalization.sentences,
            decoration: field(l10n.habitName),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            key: const Key('habitOwner'),
            initialValue: _owner,
            isExpanded: true,
            decoration: field(l10n.habitFor),
            items: [
              DropdownMenuItem(
                value: _familyOwner,
                child: Text(l10n.wholeFamily),
              ),
              for (final m in widget.store.sortedMembers)
                DropdownMenuItem(value: m.id, child: Text(m.nickname)),
            ],
            onChanged: (v) => setState(() => _owner = v ?? _familyOwner),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<BuiltInCategory>(
            initialValue: _category,
            isExpanded: true,
            decoration: field(l10n.category),
            items: [
              for (final c in BuiltInCategory.values)
                DropdownMenuItem(
                  value: c,
                  child: Row(
                    children: [
                      Icon(c.icon, color: c.color, size: 20),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          c.label(l10n),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            onChanged: (c) => setState(() {
              _category = c ?? _category;
              _subcategory = null;
            }),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String?>(
            key: ValueKey(_category),
            initialValue: _subcategory,
            isExpanded: true,
            decoration: field(l10n.subcategory),
            items: [
              const DropdownMenuItem(value: null, child: Text('—')),
              for (final s in _category.defaultSubcategories)
                DropdownMenuItem(value: s, child: Text(s)),
            ],
            onChanged: (s) => setState(() => _subcategory = s),
          ),
          const SizedBox(height: 16),
          Text(_times == 7 ? l10n.everyDay : l10n.timesPerWeek(_times)),
          Slider(
            value: _times.toDouble(),
            min: 1,
            max: 7,
            divisions: 6,
            label: '$_times',
            onChanged: (v) => setState(() => _times = v.round()),
          ),
          if (widget.habit != null) ...[
            const Divider(height: 32),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                l10n.delete,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: _delete,
            ),
          ],
        ],
      ),
    );
  }
}
