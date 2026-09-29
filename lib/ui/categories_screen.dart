import 'package:flutter/material.dart';

import '../data/family_store.dart';
import '../l10n/app_localizations.dart';
import '../models/category.dart';
import '../models/habit_library.dart';
import '../models/habit_library_l10n.dart';
import 'category_editor.dart';
import 'habit_picker.dart';

/// Every category and its ready-made habits, in the order people pick from,
/// plus the family's own categories.
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key, required this.store});

  final FamilyStore store;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    Widget header(String text) => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 4),
      child: Text(
        text,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
    Widget chips(List<String> names) => Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [for (final n in names) Chip(label: Text(n))],
    );
    const padding = EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12);
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        children: [
          if (store.canManage)
            CreateOwnTile(
              icon: Icons.create_new_folder_outlined,
              label: l10n.createMyOwnCategory,
              onTap: () => showCategoryEditor(context, store),
            ),
          if (store.categories.isNotEmpty) ...[
            header(l10n.ourCategories),
            for (final c in store.categories)
              ExpansionTile(
                leading: const Icon(
                  CustomCategory.icon,
                  color: CustomCategory.color,
                ),
                title: Text(c.name),
                childrenPadding: padding,
                expandedAlignment: AlignmentDirectional.centerStart,
                children: [
                  chips(c.habits),
                  if (store.canManage)
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton.icon(
                        icon: const Icon(Icons.edit_outlined),
                        label: Text(l10n.editCategory),
                        onPressed: () =>
                            showCategoryEditor(context, store, category: c),
                      ),
                    ),
                ],
              ),
          ],
          for (final group in CategoryGroup.values) ...[
            header(group.label(l10n)),
            for (final c in BuiltInCategory.values.where(
              (c) => c.group == group,
            ))
              ExpansionTile(
                leading: Icon(c.icon, color: c.color),
                title: Text(c.label(l10n)),
                childrenPadding: padding,
                expandedAlignment: AlignmentDirectional.centerStart,
                children: [
                  chips([
                    for (final t in templatesIn(c))
                      habitTemplateName(t, locale),
                  ]),
                ],
              ),
          ],
        ],
      ),
    );
  }
}
