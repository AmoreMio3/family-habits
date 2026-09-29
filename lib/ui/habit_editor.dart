import 'package:flutter/material.dart';

import '../data/family_store.dart';
import '../l10n/app_localizations.dart';
import '../models/category.dart';
import '../models/family.dart';
import 'common.dart';

/// Edits [habit], or adds a new habit starting from [name] and [category]
/// (for example a library habit, with its [templateId]). Returns whether it
/// was saved.
Future<bool> showHabitEditor(
  BuildContext context,
  FamilyStore store, {
  Habit? habit,
  String? name,
  CategoryRef? category,
  String? templateId,
}) async =>
    await Navigator.of(context).push(
      MaterialPageRoute<bool>(
        fullscreenDialog: true,
        builder: (_) => _HabitEditor(
          store: store,
          habit: habit,
          name: name,
          category: category,
          templateId: templateId,
        ),
      ),
    ) ??
    false;

class _HabitEditor extends StatefulWidget {
  const _HabitEditor({
    required this.store,
    this.habit,
    this.name,
    this.category,
    this.templateId,
  });

  final FamilyStore store;
  final Habit? habit;
  final String? name;
  final CategoryRef? category;
  final String? templateId;

  @override
  State<_HabitEditor> createState() => _HabitEditorState();
}

// Owner dropdown value for family habits.
const _familyOwner = '';

class _HabitEditorState extends State<_HabitEditor> {
  late final _name = TextEditingController(
    text: widget.habit?.name ?? widget.name,
  );
  late final _definition = TextEditingController(
    text: widget.habit?.definition,
  );
  late CategoryRef _category =
      widget.habit?.category ??
      widget.category ??
      const BuiltInRef(BuiltInCategory.health);
  late String _owner =
      widget.habit?.ownerMemberId ??
      widget.store.activeMember?.id ??
      _familyOwner;
  late int _times = widget.habit?.timesPerWeek ?? 7;

  @override
  void dispose() {
    _name.dispose();
    _definition.dispose();
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
        templateId: _name.text.trim() == (widget.habit?.name ?? widget.name)
            ? widget.habit?.templateId ?? widget.templateId
            : null,
        definition: _definition.text.trim().isEmpty
            ? null
            : _definition.text.trim(),
        timesPerWeek: _times,
      ),
    );
    if (mounted) Navigator.pop(context, true);
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
    if (mounted) Navigator.pop(context, true);
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
          TextField(
            key: const Key('habitDefinition'),
            controller: _definition,
            textCapitalization: TextCapitalization.sentences,
            maxLength: 120,
            decoration: field(l10n.personalDefinition)
                .copyWith(hintText: l10n.personalDefinitionHint),
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
          DropdownButtonFormField<CategoryRef>(
            key: const Key('habitCategory'),
            initialValue: _category,
            isExpanded: true,
            decoration: field(l10n.category),
            items: [
              for (final ref in [
                for (final c in BuiltInCategory.values) BuiltInRef(c),
                for (final c in widget.store.categories) CustomRef(c.id),
                if (_category is CustomRef &&
                    widget.store.customCategory(
                          (_category as CustomRef).customId,
                        ) ==
                        null)
                  _category,
              ])
                DropdownMenuItem(
                  value: ref,
                  child: Builder(
                    builder: (context) {
                      final look = categoryLook(l10n, widget.store, ref);
                      return Row(
                        children: [
                          Icon(look.icon, color: look.color, size: 20),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              look.label,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
            ],
            onChanged: (c) => setState(() => _category = c ?? _category),
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
