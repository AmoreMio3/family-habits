import 'package:flutter/material.dart';

import '../data/family_store.dart';
import '../l10n/app_localizations.dart';
import '../models/category.dart';

/// Creates a family category, or edits [category]. Returns the category's id
/// when saved, or null when cancelled or deleted.
Future<String?> showCategoryEditor(
  BuildContext context,
  FamilyStore store, {
  CustomCategory? category,
}) => Navigator.of(context).push(
  MaterialPageRoute<String>(
    fullscreenDialog: true,
    builder: (_) => _CategoryEditor(store: store, category: category),
  ),
);

class _CategoryEditor extends StatefulWidget {
  const _CategoryEditor({required this.store, this.category});

  final FamilyStore store;
  final CustomCategory? category;

  @override
  State<_CategoryEditor> createState() => _CategoryEditorState();
}

class _CategoryEditorState extends State<_CategoryEditor> {
  late final _name = TextEditingController(text: widget.category?.name);
  final _newHabit = TextEditingController();
  late final List<String> _habits = [...?widget.category?.habits];

  @override
  void dispose() {
    _name.dispose();
    _newHabit.dispose();
    super.dispose();
  }

  void _addHabit() {
    final name = _newHabit.text.trim();
    if (name.isEmpty || _habits.contains(name)) return;
    setState(() {
      _habits.add(name);
      _newHabit.clear();
    });
  }

  Future<void> _save() async {
    _addHabit();
    final repository = widget.store.repository;
    final id = widget.category?.id ?? repository.newId();
    await repository.saveCategory(
      CustomCategory(id: id, name: _name.text.trim(), habits: _habits),
    );
    if (mounted) Navigator.pop(context, id);
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final category = widget.category!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.deleteCategoryConfirm(category.name)),
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
    await widget.store.repository.deleteCategory(category.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final valid = _name.text.trim().isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category == null
              ? l10n.createMyOwnCategory
              : l10n.editCategory,
        ),
        actions: [
          TextButton(
            key: const Key('saveCategory'),
            onPressed: valid ? _save : null,
            child: Text(l10n.save),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            key: const Key('categoryName'),
            controller: _name,
            maxLength: 40,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.categoryName,
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.categoryHabits,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          for (final habit in _habits)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(habit),
              trailing: IconButton(
                tooltip: l10n.delete,
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _habits.remove(habit)),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  key: const Key('categoryNewHabit'),
                  controller: _newHabit,
                  maxLength: 80,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: l10n.addHabitToCategory,
                  ),
                  onSubmitted: (_) => _addHabit(),
                ),
              ),
              IconButton(
                key: const Key('categoryAddHabit'),
                tooltip: l10n.addHabitToCategory,
                icon: const Icon(Icons.add_circle_outline),
                onPressed: _addHabit,
              ),
            ],
          ),
          if (widget.category != null) ...[
            const Divider(height: 32),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                l10n.deleteCategory,
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
