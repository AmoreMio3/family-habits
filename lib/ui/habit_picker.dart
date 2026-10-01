import 'package:flutter/material.dart';

import '../data/family_store.dart';
import '../l10n/app_localizations.dart';
import '../logic/habit_search.dart';
import '../models/category.dart';
import '../models/habit_library.dart';
import '../models/habit_library_l10n.dart';
import 'category_editor.dart';
import 'look.dart';
import 'common.dart';
import 'habit_editor.dart';

/// Adding a habit: search, or pick a category and then a habit. Creating your
/// own habit or category is always offered.
Future<void> showHabitPicker(BuildContext context, FamilyStore store) =>
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => _HabitPicker(store: store)));

/// Whether library habits should be limited to ones that suit a child.
bool _forChild(FamilyStore store) => store.activeMember?.isParent == false;

class _HabitPicker extends StatefulWidget {
  const _HabitPicker({required this.store});

  final FamilyStore store;

  @override
  State<_HabitPicker> createState() => _HabitPickerState();
}

class _HabitPickerState extends State<_HabitPicker> {
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  Future<void> _edit({
    String? name,
    CategoryRef? category,
    String? templateId,
  }) async {
    final saved = await showHabitEditor(
      context,
      widget.store,
      name: name,
      category: category,
      templateId: templateId,
    );
    if (saved && mounted) Navigator.pop(context);
  }

  Future<void> _openCategory(CategoryRef category) async {
    final saved = await Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (_) =>
            _CategoryHabits(store: widget.store, category: category),
      ),
    );
    if (saved == true && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final store = widget.store;
    final query = _query.text.trim();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addHabit)),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                key: const Key('habitSearch'),
                controller: _query,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: l10n.searchHabitsHint,
                  border: const OutlineInputBorder(),
                  suffixIcon: query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          tooltip: l10n.cancel,
                          onPressed: () => setState(_query.clear),
                        ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            if (query.isEmpty)
              ..._browse(context, l10n)
            else
              ..._results(context, l10n, query),
          ],
        ),
      ),
    );
  }

  List<Widget> _results(
    BuildContext context,
    AppLocalizations l10n,
    String query,
  ) {
    final store = widget.store;
    final results = searchHabits(
      query,
      locale: Localizations.localeOf(context),
      categoryLabel: (c) => c.label(l10n),
      custom: store.categories,
      forChild: _forChild(store),
    );
    return [
      for (final r in results)
        Builder(
          builder: (context) {
            final look = categoryLook(l10n, store, r.category);
            return ListTile(
              leading: IconBubble(icon: look.icon, color: look.color, size: 40),
              title: Text(r.name),
              subtitle: Text(look.label),
              onTap: () => _edit(
                name: r.name,
                category: r.category,
                templateId: r.template?.id,
              ),
            );
          },
        ),
      if (results.isEmpty)
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(l10n.noMatchingHabits),
        ),
      CreateOwnTile(
        key: const Key('createFromSearch'),
        icon: Icons.add,
        label: l10n.createNamedHabit(query),
        onTap: () => _edit(name: query),
      ),
    ];
  }

  List<Widget> _browse(BuildContext context, AppLocalizations l10n) {
    final store = widget.store;
    Widget header(String text) => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 22, 20, 6),
      child: Text(text, style: Look.of(context).heading(19)),
    );
    return [
      CreateOwnTile(
        key: const Key('createOwnHabit'),
        icon: Icons.add,
        label: l10n.createMyOwnHabit,
        onTap: _edit,
      ),
      if (store.canManage)
        CreateOwnTile(
          key: const Key('createOwnCategory'),
          icon: Icons.create_new_folder_outlined,
          label: l10n.createMyOwnCategory,
          onTap: () async {
            final id = await showCategoryEditor(context, store);
            if (id != null && mounted) _openCategory(CustomRef(id));
          },
        ),
      if (store.categories.isNotEmpty) ...[
        header(l10n.ourCategories),
        for (final c in store.categories)
          ListTile(
            leading: const IconBubble(
              icon: CustomCategory.icon,
              color: CustomCategory.color,
              size: 40,
            ),
            title: Text(c.name),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openCategory(CustomRef(c.id)),
          ),
      ],
      for (final group in CategoryGroup.values) ...[
        header(group.label(l10n)),
        for (final c in BuiltInCategory.values.where((c) => c.group == group))
          ListTile(
            key: Key('category-${c.name}'),
            leading: IconBubble(icon: c.icon, color: c.color, size: 40),
            title: Text(c.label(l10n)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openCategory(BuiltInRef(c)),
          ),
      ],
    ];
  }
}

/// The habits in one category, with "Create my own" at the bottom.
class _CategoryHabits extends StatelessWidget {
  const _CategoryHabits({required this.store, required this.category});

  final FamilyStore store;
  final CategoryRef category;

  Future<void> _edit(
    BuildContext context, {
    String? name,
    String? templateId,
  }) async {
    final saved = await showHabitEditor(
      context,
      store,
      name: name,
      category: category,
      templateId: templateId,
    );
    if (saved && context.mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final look = categoryLook(l10n, store, category);
        final custom = switch (category) {
          CustomRef(:final customId) => store.customCategory(customId),
          BuiltInRef() => null,
        };
        return Scaffold(
          appBar: AppBar(
            title: Text(look.label),
            actions: [
              if (custom != null && store.canManage)
                IconButton(
                  tooltip: l10n.editCategory,
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () async {
                    await showCategoryEditor(context, store, category: custom);
                    // Leave the screen if the category was deleted.
                    if (store.customCategory(custom.id) == null &&
                        context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              if (category case BuiltInRef(category: final c))
                for (final t in templatesIn(c))
                  if (!_forChild(store) || suitsChild(t))
                    ListTile(
                      key: Key('template-${t.id}'),
                      leading: IconBubble(
                        icon: c.icon,
                        color: c.color,
                        size: 40,
                      ),
                      title: Text(habitTemplateName(t, locale)),
                      onTap: () => _edit(
                        context,
                        name: habitTemplateName(t, locale),
                        templateId: t.id,
                      ),
                    ),
              if (custom != null)
                for (final name in custom.habits)
                  ListTile(
                    leading: IconBubble(
                      icon: look.icon,
                      color: look.color,
                      size: 40,
                    ),
                    title: Text(name),
                    onTap: () => _edit(context, name: name),
                  ),
              CreateOwnTile(
                key: const Key('createOwnInCategory'),
                icon: Icons.add,
                label: l10n.createMyOwnHabit,
                onTap: () => _edit(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A bold, highlighted row for making your own habit or category, so it is
/// always clear the list is only a starting point.
class CreateOwnTile extends StatelessWidget {
  const CreateOwnTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final look = Look.of(context);
    return SoftCard(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      color: Color.alphaBlend(look.tint(look.primary), look.card),
      onTap: onTap,
      child: Row(
        children: [
          IconBubble(icon: icon, color: look.primary, size: 40),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: look.ink,
              ),
            ),
          ),
          Icon(Icons.add_circle_rounded, color: look.primary),
        ],
      ),
    );
  }
}
