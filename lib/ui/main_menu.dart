import 'package:flutter/material.dart';

import 'look.dart';

/// Where the main menu sits: a row of tabs under the top bar, or a bar at
/// the bottom of the screen.
enum MenuPlace { top, bottom }

class MenuItem {
  const MenuItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// The main tabs as a row of pills under the top bar. It scrolls sideways
/// when the names don't fit, and starts from the right in Hebrew and Arabic.
class TopMenu extends StatefulWidget {
  const TopMenu({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  final List<MenuItem> items;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  State<TopMenu> createState() => _TopMenuState();
}

class _TopMenuState extends State<TopMenu> {
  late final List<GlobalKey> _keys = [
    for (final _ in widget.items) GlobalKey(),
  ];

  @override
  void didUpdateWidget(TopMenu old) {
    super.didUpdateWidget(old);
    if (old.selected != widget.selected) {
      // Keep the chosen tab in view.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = _keys[widget.selected].currentContext;
        if (ctx != null && ctx.mounted) {
          Scrollable.ensureVisible(
            ctx,
            alignment: 0.5,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final look = Look.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          for (var i = 0; i < widget.items.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            _pill(look, i),
          ],
        ],
      ),
    );
  }

  Widget _pill(Look look, int i) {
    final item = widget.items[i];
    final selected = i == widget.selected;
    return Semantics(
      key: _keys[i],
      button: true,
      selected: selected,
      child: Material(
        key: Key('menu-$i'),
        color: selected ? look.primary : look.card,
        shape: StadiumBorder(
          side: selected
              ? BorderSide.none
              : BorderSide(color: look.muted.withValues(alpha: 0.18)),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: () => widget.onSelected(i),
          child: SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selected ? item.selectedIcon : item.icon,
                    size: 20,
                    color: selected ? look.onPrimary : look.muted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? look.onPrimary : look.ink,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The main tabs as a bar at the bottom: five equal slots, each an icon over
/// a one-line name that shrinks to fit rather than wrapping.
class BottomMenu extends StatelessWidget {
  const BottomMenu({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  final List<MenuItem> items;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final look = Look.of(context);
    return Material(
      color: look.nav,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _BottomItem(
                    key: Key('menu-$i'),
                    item: items[i],
                    selected: i == selected,
                    look: look,
                    onTap: () => onSelected(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    super.key,
    required this.item,
    required this.selected,
    required this.look,
    required this.onTap,
  });

  final MenuItem item;
  final bool selected;
  final Look look;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? look.primary : look.muted;
    return Semantics(
      button: true,
      selected: selected,
      child: InkResponse(
        onTap: onTap,
        highlightShape: BoxShape.rectangle,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52,
              height: 30,
              decoration: BoxDecoration(
                color: selected ? look.tint(look.primary) : null,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Icon(
                selected ? item.selectedIcon : item.icon,
                size: 22,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  item.label,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: color,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
