import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/category.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        for (final category in BuiltInCategory.values)
          ExpansionTile(
            leading: Icon(category.icon, color: category.color),
            title: Text(category.label(l10n)),
            childrenPadding: const EdgeInsetsDirectional.fromSTEB(
              16,
              0,
              16,
              12,
            ),
            expandedAlignment: AlignmentDirectional.centerStart,
            children: [
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final sub in category.defaultSubcategories)
                    Chip(label: Text(sub)),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
