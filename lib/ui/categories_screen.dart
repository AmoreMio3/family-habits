import 'package:flutter/material.dart';

import '../data/family_store.dart';
import '../l10n/app_localizations.dart';
import '../models/category.dart';
import '../models/habit_library.dart';
import '../models/habit_library_l10n.dart';
import 'category_editor.dart';
import 'habit_picker.dart';
import 'look.dart';

/// Every category and its ready-made habits, in the order people pick from,
/// plus the family's own categories.
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key, required this.store});

  final FamilyStore store;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final look = Look.of(context);
    Widget header(String text) => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 22, 20, 6),
      child: Text(text, style: look.heading(19)),
    );
    Widget chips(List<String> names, Color color) => Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final n in names)
          Chip(
            label: Text(n),
            backgroundColor: look.tint(color),
            labelStyle: TextStyle(color: look.ink, fontSize: 13),
            visualDensity: VisualDensity.compact,
          ),
      ],
    );
    const padding = EdgeInsetsDirectional.fromSTEB(16, 0, 16, 14);
    Widget category({
      required IconData icon,
      required Color color,
      required String title,
      required List<Widget> children,
    }) => SoftCard(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        leading: IconBubble(icon: icon, color: color, size: 40),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: look.ink),
        ),
        childrenPadding: padding,
        expandedAlignment: AlignmentDirectional.centerStart,
        children: children,
      ),
    );
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.only(top: 4, bottom: 32),
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
              category(
                icon: CustomCategory.icon,
                color: CustomCategory.color,
                title: c.name,
                children: [
                  chips(c.habits, CustomCategory.color),
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
              category(
                icon: c.icon,
                color: c.color,
                title: c.label(l10n),
                children: [
                  chips([
                    for (final t in templatesIn(c))
                      habitTemplateName(t, locale),
                  ], c.color),
                ],
              ),
          ],
        ],
      ),
    );
  }
}
