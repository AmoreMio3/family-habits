import 'package:flutter/material.dart';

/// The app's visual style: colors, fonts, corner rounding and shadows.
///
/// There are three looks while the family picks one. Build with
/// `--dart-define=LOOK=garden` or `LOOK=playground` to try the others;
/// `sunshine` is the default.
enum LookName { sunshine, garden, playground, clear, sky, ocean }

final selectedLook =
    LookName.values.asNameMap()[const String.fromEnvironment(
      'LOOK',
      defaultValue: 'sunshine',
    )] ??
    LookName.sunshine;

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
      LookName.sunshine => Look(
        brightness: brightness,
        background: dark ? const Color(0xFF1E1813) : const Color(0xFFFFF6EA),
        card: dark ? const Color(0xFF2B231C) : Colors.white,
        ink: dark ? const Color(0xFFF8EEE4) : const Color(0xFF2E2118),
        muted: dark ? const Color(0xFFC3B2A2) : const Color(0xFF7A6656),
        primary: dark ? const Color(0xFFFF8A4C) : const Color(0xFFC9501A),
        onPrimary: dark ? const Color(0xFF2E1405) : Colors.white,
        done: const Color(0xFF1FA463),
        hero: const LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [Color(0xFFFF9B42), Color(0xFFFF5F6D)],
        ),
        heroInk: Colors.white,
        radius: 24,
        borderWidth: 0,
        border: Colors.transparent,
        shadows: dark
            ? const []
            : const [
                BoxShadow(
                  color: Color(0x1FE07B2E),
                  blurRadius: 18,
                  offset: Offset(0, 6),
                ),
              ],
        headingFont: 'Fredoka',
        headingWeight: FontWeight.w600,
        memberColors: const [
          Color(0xFFFF8A3D),
          Color(0xFFF2547D),
          Color(0xFF7C5CFF),
          Color(0xFF14A8A0),
          Color(0xFFF2B01E),
          Color(0xFF3D9BFF),
        ],
        familyColor: const Color(0xFF1FA463),
        streak: const Color(0xFFFF7A1A),
        nav: dark ? const Color(0xFF2B231C) : Colors.white,
      ),
      LookName.garden => Look(
        brightness: brightness,
        background: dark ? const Color(0xFF151C17) : const Color(0xFFF2F5EC),
        card: dark ? const Color(0xFF1F2922) : Colors.white,
        ink: dark ? const Color(0xFFE9F0E7) : const Color(0xFF1F2D24),
        muted: dark ? const Color(0xFFA7B6AA) : const Color(0xFF627266),
        primary: dark ? const Color(0xFF8FCBA6) : const Color(0xFF3B7655),
        onPrimary: dark ? const Color(0xFF0E2618) : Colors.white,
        done: dark ? const Color(0xFF6DBB8C) : const Color(0xFF3B7655),
        hero: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: dark
              ? const [Color(0xFF2D5A40), Color(0xFF6B4A33)]
              : const [Color(0xFFB9DEC5), Color(0xFFF7D9B5)],
        ),
        heroInk: dark ? const Color(0xFFF1F5EF) : const Color(0xFF1F2D24),
        radius: 18,
        borderWidth: 1,
        border: dark ? const Color(0xFF2E3B32) : const Color(0xFFDDE6D5),
        shadows: const [],
        headingFont: 'VarelaRound',
        headingWeight: FontWeight.w400,
        memberColors: const [
          Color(0xFF4F9A6E),
          Color(0xFFE08A5F),
          Color(0xFF7484D2),
          Color(0xFFC07BB0),
          Color(0xFFD0A73C),
          Color(0xFF4FA1B3),
        ],
        familyColor: const Color(0xFFE9A23B),
        streak: const Color(0xFFE08A5F),
        nav: dark ? const Color(0xFF1F2922) : Colors.white,
      ),
      LookName.playground => Look(
        brightness: brightness,
        background: dark ? const Color(0xFF17132B) : const Color(0xFFF3EFFF),
        card: dark ? const Color(0xFF231D40) : Colors.white,
        ink: dark ? const Color(0xFFF2EEFF) : const Color(0xFF231A4A),
        muted: dark ? const Color(0xFFB6ADDB) : const Color(0xFF625A86),
        primary: dark ? const Color(0xFFA48BFF) : const Color(0xFF5F3DF0),
        onPrimary: dark ? const Color(0xFF1A0F4A) : Colors.white,
        done: const Color(0xFF16A34A),
        hero: const LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [Color(0xFF5F3DF0), Color(0xFFC03FE0)],
        ),
        heroInk: Colors.white,
        radius: 20,
        borderWidth: 2.5,
        border: dark ? const Color(0xFF4A3F80) : const Color(0xFF231A4A),
        shadows: [
          BoxShadow(
            color: dark ? const Color(0xFF0B0818) : const Color(0xFF231A4A),
            offset: const Offset(0, 4),
          ),
        ],
        headingFont: 'Fredoka',
        headingWeight: FontWeight.w700,
        memberColors: const [
          Color(0xFFFF4F86),
          Color(0xFFFFA41B),
          Color(0xFF22B455),
          Color(0xFF2E9BFF),
          Color(0xFFA855F7),
          Color(0xFFFF6B3D),
        ],
        familyColor: const Color(0xFF0FB5A6),
        streak: const Color(0xFFFF6B3D),
        nav: dark ? const Color(0xFF231D40) : Colors.white,
      ),
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
      LookName.sky => Look(
        brightness: brightness,
        background: dark ? const Color(0xFF0C1730) : const Color(0xFFEEF5FF),
        card: dark ? const Color(0xFF15244A) : Colors.white,
        ink: dark ? const Color(0xFFEAF2FF) : const Color(0xFF13294B),
        muted: dark ? const Color(0xFF9FB3D9) : const Color(0xFF5A6F92),
        primary: dark ? const Color(0xFF7DB2FF) : const Color(0xFF2F7BF5),
        onPrimary: dark ? const Color(0xFF08204A) : Colors.white,
        done: const Color(0xFF20B486),
        hero: const LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [Color(0xFF4FB3FF), Color(0xFF2F6BF5)],
        ),
        heroInk: Colors.white,
        radius: 22,
        borderWidth: 0,
        border: Colors.transparent,
        shadows: dark
            ? const []
            : const [
                BoxShadow(
                  color: Color(0x1A2F7BF5),
                  blurRadius: 18,
                  offset: Offset(0, 6),
                ),
              ],
        headingFont: 'MPLUSRounded1c',
        headingWeight: FontWeight.w800,
        bodyFont: 'MPLUSRounded1c',
        memberColors: const [
          Color(0xFF2F7BF5),
          Color(0xFFFF6B8B),
          Color(0xFF20B486),
          Color(0xFFFFB020),
          Color(0xFF8C6BFF),
          Color(0xFF14B8C8),
        ],
        familyColor: const Color(0xFFFFB020),
        streak: const Color(0xFFFF8A3D),
        nav: dark ? const Color(0xFF15244A) : Colors.white,
      ),
      LookName.ocean => Look(
        brightness: brightness,
        background: dark ? const Color(0xFF06111D) : const Color(0xFFF1F5F8),
        card: dark ? const Color(0xFF0E1C2C) : Colors.white,
        ink: dark ? const Color(0xFFE6EEF6) : const Color(0xFF0A1A2A),
        muted: dark ? const Color(0xFF93A6BA) : const Color(0xFF586A7C),
        primary: dark ? const Color(0xFF4C9BFF) : const Color(0xFF0B63E5),
        onPrimary: dark ? const Color(0xFF021A3D) : Colors.white,
        done: const Color(0xFF13B07A),
        hero: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: dark
              ? const [Color(0xFF08345E), Color(0xFF0B6E8C)]
              : const [Color(0xFF062A4D), Color(0xFF0B6E8C)],
        ),
        heroInk: Colors.white,
        radius: 12,
        borderWidth: 1,
        border: dark ? const Color(0xFF1A2B3E) : const Color(0xFFDCE4EC),
        shadows: const [],
        headingFont: 'SecularOne',
        headingWeight: FontWeight.w400,
        bodyFont: 'Assistant',
        memberColors: const [
          Color(0xFF0B63E5),
          Color(0xFFFF5D5D),
          Color(0xFF13B07A),
          Color(0xFFF2B705),
          Color(0xFF7A5CFA),
          Color(0xFF0BB3C4),
        ],
        familyColor: const Color(0xFFA3D930),
        streak: const Color(0xFFFF7A1A),
        nav: dark ? const Color(0xFF0E1C2C) : Colors.white,
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
