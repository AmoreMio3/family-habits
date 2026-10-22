import 'package:flutter/material.dart';

/// The app's visual style: colors, fonts, corner rounding and shadows.
///
/// The family picked Clear Blue: navy and royal blue, Frank Ruhl Libre
/// headings and IBM Plex Sans Hebrew text.
enum LookName { clear }

const selectedLook = LookName.clear;

class Look extends ThemeExtension<Look> {
  const Look({
    required this.brightness,
    required this.background,
    required this.card,
    required this.ink,
    required this.muted,
    required this.primary,
    required this.onPrimary,
    required this.done,
    required this.hero,
    required this.heroInk,
    required this.radius,
    required this.borderWidth,
    required this.border,
    required this.shadows,
    required this.headingFont,
    required this.headingWeight,
    required this.memberColors,
    required this.familyColor,
    required this.streak,
    required this.nav,
    this.bodyFont = fallbackFont,
  });

  final Brightness brightness;
  final Color background;
  final Color card;
  final Color ink;
  final Color muted;
  final Color primary;
  final Color onPrimary;

  /// Fill of a checked-in habit.
  final Color done;

  /// The family week card's background.
  final Gradient hero;
  final Color heroInk;
  final double radius;
  final double borderWidth;
  final Color border;
  final List<BoxShadow> shadows;
  final String headingFont;
  final FontWeight headingWeight;
  final List<Color> memberColors;
  final Color familyColor;
  final Color streak;
  final Color nav;

  /// Font for everything but headings.
  final String bodyFont;

  /// Covers Hebrew and Arabic; used for any letter a look's fonts lack.
  static const fallbackFont = 'Rubik';

  bool get isDark => brightness == Brightness.dark;

  /// The current look; screens shown outside the app's theme (as in tests)
  /// get the default one.
  static Look of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<Look>() ??
        Look.resolve(selectedLook, theme.brightness);
  }

  /// A soft circle behind an icon, tinted with the icon's color.
  Color tint(Color color) => color.withValues(alpha: isDark ? 0.26 : 0.14);

  BoxDecoration cardDecoration({Color? color, double? radius}) => BoxDecoration(
    color: color ?? card,
    borderRadius: BorderRadius.circular(radius ?? this.radius),
    border: borderWidth > 0
        ? Border.all(color: border, width: borderWidth)
        : null,
    boxShadow: shadows,
  );

  TextStyle heading(double size, {Color? color}) => TextStyle(
    fontFamily: headingFont,
    fontFamilyFallback: [bodyFont, fallbackFont],
    fontSize: size,
    fontWeight: headingWeight,
    color: color ?? ink,
    height: 1.2,
  );

  static Look resolve(LookName name, Brightness brightness) {
    final dark = brightness == Brightness.dark;
    return switch (name) {
      LookName.clear => Look(
        brightness: brightness,
        background: dark ? const Color(0xFF0B1424) : const Color(0xFFF5F7FB),
        card: dark ? const Color(0xFF132036) : Colors.white,
        ink: dark ? const Color(0xFFE8EEF8) : const Color(0xFF0F1E36),
        muted: dark ? const Color(0xFF9AA9C2) : const Color(0xFF5B6B84),
        primary: dark ? const Color(0xFF6EA2FF) : const Color(0xFF1D5FD1),
        onPrimary: dark ? const Color(0xFF071A3D) : Colors.white,
        done: const Color(0xFF0F9D7A),
        hero: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: dark
              ? const [Color(0xFF16305C), Color(0xFF1D4E9E)]
              : const [Color(0xFF10264A), Color(0xFF1D4E9E)],
        ),
        heroInk: Colors.white,
        radius: 16,
        borderWidth: 1,
        border: dark ? const Color(0xFF1F2E48) : const Color(0xFFE2E8F2),
        shadows: const [],
        headingFont: 'FrankRuhlLibre',
        headingWeight: FontWeight.w700,
        bodyFont: 'IBMPlexSansHebrew',
        memberColors: const [
          Color(0xFF1D5FD1),
          Color(0xFFE2557A),
          Color(0xFF0F9D7A),
          Color(0xFFE89A24),
          Color(0xFF7B61FF),
          Color(0xFF2BB3D9),
        ],
        familyColor: const Color(0xFFE89A24),
        streak: const Color(0xFFF07A30),
        nav: dark ? const Color(0xFF132036) : Colors.white,
      ),
    };
  }

  @override
  Look copyWith() => this;

  @override
  Look lerp(Look? other, double t) => t < 0.5 || other == null ? this : other;
}

ThemeData buildTheme(Brightness brightness, {LookName? name}) {
  final look = Look.resolve(name ?? selectedLook, brightness);
  final scheme =
      ColorScheme.fromSeed(
        seedColor: look.primary,
        brightness: brightness,
      ).copyWith(
        primary: look.primary,
        onPrimary: look.onPrimary,
        surface: look.background,
        onSurface: look.ink,
        onSurfaceVariant: look.muted,
        surfaceContainerLowest: look.card,
        surfaceContainerLow: look.card,
        surfaceContainer: look.card,
        surfaceContainerHigh: look.card,
        surfaceContainerHighest: Color.alphaBlend(
          look.primary.withValues(alpha: 0.08),
          look.card,
        ),
        primaryContainer: look.tint(look.primary),
        onPrimaryContainer: look.ink,
        secondaryContainer: look.tint(look.primary),
        onSecondaryContainer: look.ink,
        outlineVariant: look.borderWidth > 0
            ? look.border.withValues(alpha: 0.4)
            : look.muted.withValues(alpha: 0.2),
      );
  final base = ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    fontFamily: look.bodyFont,
    fontFamilyFallback: const [Look.fallbackFont],
  );
  final shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(look.radius),
    side: look.borderWidth > 0
        ? BorderSide(color: look.border, width: look.borderWidth)
        : BorderSide.none,
  );
  TextStyle? headed(TextStyle? style) => style?.copyWith(
    fontFamily: look.headingFont,
    fontFamilyFallback: [look.bodyFont, Look.fallbackFont],
    fontWeight: look.headingWeight,
  );
  final text = base.textTheme.apply(
    bodyColor: look.ink,
    displayColor: look.ink,
  );
  final buttonText = TextStyle(
    fontFamily: look.bodyFont,
    fontFamilyFallback: const [Look.fallbackFont],
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  const buttonSize = Size(64, 46);

  return base.copyWith(
    extensions: [look],
    scaffoldBackgroundColor: look.background,
    textTheme: text.copyWith(
      displaySmall: headed(text.displaySmall),
      headlineLarge: headed(text.headlineLarge),
      headlineMedium: headed(text.headlineMedium),
      headlineSmall: headed(text.headlineSmall),
      titleLarge: headed(text.titleLarge),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: look.background,
      foregroundColor: look.ink,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      titleTextStyle: look.heading(20),
    ),
    cardTheme: CardThemeData(
      color: look.card,
      elevation: 0,
      shape: shape,
      surfaceTintColor: Colors.transparent,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: buttonSize,
        shape: const StadiumBorder(),
        textStyle: buttonText,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: buttonSize,
        shape: const StadiumBorder(),
        textStyle: buttonText,
        side: BorderSide(color: look.primary, width: 1.5),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(textStyle: buttonText),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: look.primary,
      foregroundColor: look.onPrimary,
      shape: StadiumBorder(
        side: look.borderWidth > 0
            ? BorderSide(color: look.border, width: look.borderWidth)
            : BorderSide.none,
      ),
      extendedTextStyle: buttonText,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: look.card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: look.muted.withValues(alpha: 0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: look.muted.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: look.primary, width: 2),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      shape: const StadiumBorder(),
      side: BorderSide.none,
      backgroundColor: look.tint(look.primary),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: look.nav,
      surfaceTintColor: Colors.transparent,
      indicatorColor: look.tint(look.primary),
      elevation: 0,
      height: 64,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? look.primary
              : look.muted,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 13,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w600
              : FontWeight.w500,
          color: states.contains(WidgetState.selected)
              ? look.primary
              : look.muted,
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: look.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      titleTextStyle: look.heading(22),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: look.card,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: look.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      shape: Border(),
      collapsedShape: Border(),
    ),
    listTileTheme: ListTileThemeData(iconColor: look.muted),
  );
}

/// Draws all text a little smaller than Flutter's default, on top of the
/// size the person picked in the phone's settings.
class CompactText extends StatelessWidget {
  const CompactText({super.key, required this.child});

  static const factor = 0.82;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(textScaler: _ScaledText(media.textScaler, factor)),
      child: child,
    );
  }
}

class _ScaledText extends TextScaler {
  const _ScaledText(this.base, this.factor);

  final TextScaler base;
  final double factor;

  @override
  double scale(double fontSize) => base.scale(fontSize) * factor;

  @override
  // ignore: deprecated_member_use
  double get textScaleFactor => base.textScaleFactor * factor;

  @override
  bool operator ==(Object other) =>
      other is _ScaledText && other.base == base && other.factor == factor;

  @override
  int get hashCode => Object.hash(base, factor);
}

/// A card in the current look that can be tapped.
class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.onTap,
    this.color,
    this.padding = const EdgeInsets.all(14),
    this.margin = const EdgeInsets.symmetric(vertical: 6),
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final look = Look.of(context);
    final radius = BorderRadius.circular(look.radius);
    return Padding(
      padding: margin,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: look.cardDecoration(color: color),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: radius,
            onTap: onTap,
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}

/// An icon on a soft circle of its own color.
class IconBubble extends StatelessWidget {
  const IconBubble({
    super.key,
    required this.icon,
    required this.color,
    this.size = 40,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final look = Look.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: look.tint(color),
        borderRadius: BorderRadius.circular(size * 0.36),
      ),
      child: Icon(icon, color: color, size: size * 0.52),
    );
  }
}

/// A member's colored circle with their first letter.
class MemberAvatar extends StatelessWidget {
  const MemberAvatar({
    super.key,
    required this.name,
    required this.color,
    this.size = 44,
  });

  final String name;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final look = Look.of(context);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: look.borderWidth > 0
            ? Border.all(color: look.border, width: look.borderWidth)
            : null,
      ),
      child: Text(
        name.characters.firstOrNull?.toUpperCase() ?? '?',
        style: look.heading(size * 0.44, color: Colors.white),
      ),
    );
  }
}

/// Section heading with an optional trailing note.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.trailing});

  final String text;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final look = Look.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(4, 20, 4, 6),
      child: Row(
        children: [
          Expanded(child: Text(text, style: look.heading(18))),
          if (trailing != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: look.tint(look.primary),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                trailing!,
                style: TextStyle(
                  color: look.ink,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
