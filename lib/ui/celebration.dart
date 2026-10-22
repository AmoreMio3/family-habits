import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/category.dart';
import '../models/family.dart';
import '../models/habit_library.dart';
import 'habit_scenes.dart';
import 'look.dart';

/// The little animation that plays when a habit is checked off: one per
/// built-in category, plus water for drinking habits and confetti for the
/// family's own categories.
enum Celebration {
  water,
  health,
  breakHabit,
  nutrition,
  sleep,
  sport,
  selfCare,
  mindfulness,
  familyTime,
  familyCare,
  familyMeals,
  homeTasks,
  reading,
  work,
  finance,
  outdoor,
  art,
  hobbies,
  confetti,
}

const _waterWords = ['water', 'drink', 'hydrat', 'מים', 'לשתות', 'ماء', 'agua'];
const _sleepWords = ['sleep', 'nap', 'bedtime', 'שינה', 'לישון', 'نوم'];
const _readingWords = ['read', 'book', 'לקרוא', 'ספר', 'قراءة'];
const _sportWords = [
  'run',
  'walk',
  'hike',
  'hiking',
  'swim',
  'bike',
  'workout',
  'exercise',
  'ריצה',
  'הליכה',
  'כושר',
];

/// Picks the animation from what the habit is about: drinking habits get
/// water, built-in categories get their own, and habits in the family's own
/// categories are matched by their words.
Celebration celebrationFor(Habit habit) {
  final template = habit.templateId == null
      ? null
      : habitTemplates.where((t) => t.id == habit.templateId).firstOrNull;
  final category = switch (habit.category) {
    BuiltInRef(:final category) => category,
    CustomRef() => null,
  };
  final text = [
    habit.name,
    if (template != null) template.name,
  ].join(' ').toLowerCase();
  bool has(List<String> words) => words.any(text.contains);

  // Watering plants is a home task, not a drink.
  if (has(_waterWords) && category != BuiltInCategory.homeTasks) {
    return Celebration.water;
  }
  if (category != null) {
    return switch (category) {
      BuiltInCategory.health => Celebration.health,
      BuiltInCategory.breakHabit => Celebration.breakHabit,
      BuiltInCategory.nutrition => Celebration.nutrition,
      BuiltInCategory.sleep => Celebration.sleep,
      BuiltInCategory.sport => Celebration.sport,
      BuiltInCategory.selfCare => Celebration.selfCare,
      BuiltInCategory.mindfulness => Celebration.mindfulness,
      BuiltInCategory.familyTime => Celebration.familyTime,
      BuiltInCategory.familyCare => Celebration.familyCare,
      BuiltInCategory.familyMeals => Celebration.familyMeals,
      BuiltInCategory.homeTasks => Celebration.homeTasks,
      BuiltInCategory.study => Celebration.reading,
      BuiltInCategory.work => Celebration.work,
      BuiltInCategory.finance => Celebration.finance,
      BuiltInCategory.outdoor => Celebration.outdoor,
      BuiltInCategory.art => Celebration.art,
      BuiltInCategory.hobbies => Celebration.hobbies,
    };
  }
  if (has(_sleepWords)) return Celebration.sleep;
  if (has(_readingWords)) return Celebration.reading;
  if (has(_sportWords)) return Celebration.sport;
  if (habit.isFamily) return Celebration.familyTime;
  return Celebration.confetti;
}

/// Plays the animation that fits [habit]: its own picture when it has one,
/// otherwise its category's. Drinking water keeps its glass.
void celebrateHabit(BuildContext context, Habit habit, String caption) {
  final kind = celebrationFor(habit);
  celebrate(
    context,
    kind,
    caption,
    scene: kind == Celebration.water && habit.emoji == null
        ? null
        : sceneFor(habit),
  );
}

/// Plays [kind] in a floating bubble over the screen, then removes it. Taps
/// pass through, and nothing plays when the phone asks for reduced motion.
void celebrate(
  BuildContext context,
  Celebration kind,
  String caption, {
  Scene? scene,
}) {
  if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return;
  // The root overlay, so the animation keeps playing while the habit
  // editor closes.
  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) return;
  HapticFeedback.mediumImpact();
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _CelebrationOverlay(
      kind: kind,
      scene: scene,
      caption: caption,
      look: Look.of(context),
      onDone: () => entry.remove(),
    ),
  );
  overlay.insert(entry);
}

class _CelebrationOverlay extends StatefulWidget {
  const _CelebrationOverlay({
    required this.kind,
    required this.scene,
    required this.caption,
    required this.look,
    required this.onDone,
  });

  final Celebration kind;
  final Scene? scene;
  final String caption;
  final Look look;
  final VoidCallback onDone;

  @override
  State<_CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<_CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1700),
  );

  @override
  void initState() {
    super.initState();
    _controller.forward().whenComplete(widget.onDone);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final look = widget.look;
    final color = celebrationColor(widget.kind, look);
    // The overlay sits outside the page's Material, so give the caption a
    // text style of its own (otherwise it shows the debug underline).
    return IgnorePointer(
      child: Material(
        type: MaterialType.transparency,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _controller.value;
            // Pop in over the first 18%, fade out over the last 15%.
            final scaleIn = Curves.elasticOut.transform(
              (t / 0.3).clamp(0.0, 1.0),
            );
            final fade =
                1 -
                Curves.easeIn.transform(((t - 0.85) / 0.15).clamp(0.0, 1.0));
            return Center(
              child: Opacity(
                opacity: fade,
                child: Transform.scale(
                  scale: 0.6 + 0.4 * scaleIn,
                  child: Container(
                    width: 210,
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                    decoration: BoxDecoration(
                      color: look.card,
                      borderRadius: BorderRadius.circular(32),
                      border: look.borderWidth > 0
                          ? Border.all(
                              color: look.border,
                              width: look.borderWidth,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.35),
                          blurRadius: 40,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox.square(
                          dimension: 150,
                          child: CustomPaint(
                            painter: CelebrationPainter(
                              kind: widget.kind,
                              scene: widget.scene,
                              t: t,
                              color: color,
                              look: look,
                              textDirection: Directionality.of(context),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.caption,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: look.heading(17),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

Color celebrationColor(Celebration kind, Look look) => switch (kind) {
  Celebration.water => const Color(0xFF2F9BFF),
  Celebration.health => const Color(0xFFE8496A),
  Celebration.breakHabit => const Color(0xFFE0603B),
  Celebration.nutrition => const Color(0xFF5DB33A),
  Celebration.sleep => const Color(0xFF6C5CE7),
  Celebration.sport => const Color(0xFFF2B01E),
  Celebration.selfCare => const Color(0xFF1FB5C9),
  Celebration.mindfulness => const Color(0xFF9B7BE0),
  Celebration.familyTime => const Color(0xFFF2547D),
  Celebration.familyCare => const Color(0xFFEC5F9A),
  Celebration.familyMeals => const Color(0xFFF28C28),
  Celebration.homeTasks => const Color(0xFF8D6E63),
  Celebration.reading => const Color(0xFFF2994A),
  Celebration.work => const Color(0xFF5C7CFA),
  Celebration.finance => const Color(0xFF2E9E5B),
  Celebration.outdoor => const Color(0xFF43A047),
  Celebration.art => const Color(0xFFE05297),
  Celebration.hobbies => const Color(0xFF8E5BD9),
  Celebration.confetti => look.done,
};

/// Draws one frame of a celebration; [t] runs from 0 to 1.
class CelebrationPainter extends CustomPainter {
  CelebrationPainter({
    required this.kind,
    required this.t,
    required this.color,
    required this.look,
    required this.textDirection,
    this.scene,
  });

  final Celebration kind;

  /// The habit's own picture; when set it plays instead of [kind]'s.
  final Scene? scene;
  final double t;
  final Color color;
  final Look look;
  final TextDirection textDirection;

  /// 1 in left-to-right languages, -1 in Hebrew and Arabic, so motion that
  /// drifts "forward" follows the reading direction.
  double get forward => textDirection == TextDirection.rtl ? -1 : 1;

  static double _seg(double t, double start, double end) =>
      ((t - start) / (end - start)).clamp(0.0, 1.0);

  @override
  void paint(Canvas canvas, Size size) {
    if (scene case final scene?) return _scene(canvas, size, scene);
    switch (kind) {
      case Celebration.water:
        _water(canvas, size);
      case Celebration.health:
        _health(canvas, size);
      case Celebration.breakHabit:
        _breakHabit(canvas, size);
      case Celebration.nutrition:
        _nutrition(canvas, size);
      case Celebration.sleep:
        _sleep(canvas, size);
      case Celebration.sport:
        _sport(canvas, size);
      case Celebration.selfCare:
        _selfCare(canvas, size);
      case Celebration.mindfulness:
        _mindfulness(canvas, size);
      case Celebration.familyTime:
        _family(canvas, size);
      case Celebration.familyCare:
        _familyCare(canvas, size);
      case Celebration.familyMeals:
        _familyMeals(canvas, size);
      case Celebration.homeTasks:
        _homeTasks(canvas, size);
      case Celebration.reading:
        _reading(canvas, size);
      case Celebration.work:
        _work(canvas, size);
      case Celebration.finance:
        _finance(canvas, size);
      case Celebration.outdoor:
        _outdoor(canvas, size);
      case Celebration.art:
        _art(canvas, size);
      case Celebration.hobbies:
        _hobbies(canvas, size);
      case Celebration.confetti:
        _confetti(canvas, size);
    }
  }

  /// A glass fills up with gently waving water and rising bubbles.
  void _water(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final top = h * 0.14, bottom = h * 0.92;
    final topHalf = w * 0.30, bottomHalf = w * 0.22;
    final cx = w / 2;
    final glass = Path()
      ..moveTo(cx - topHalf, top)
      ..lineTo(cx - bottomHalf, bottom)
      ..quadraticBezierTo(
        cx - bottomHalf,
        bottom + 4,
        cx - bottomHalf + 6,
        bottom + 4,
      )
      ..lineTo(cx + bottomHalf - 6, bottom + 4)
      ..quadraticBezierTo(cx + bottomHalf, bottom + 4, cx + bottomHalf, bottom)
      ..lineTo(cx + topHalf, top);

    // The drop falls in first.
    final drop = _seg(t, 0, 0.22);
    if (drop < 1) {
      final y = -10 + (bottom - 10) * Curves.easeIn.transform(drop);
      _drawDrop(canvas, Offset(cx, y), 9, color);
    }

    final fill = Curves.easeOutCubic.transform(_seg(t, 0.15, 0.75));
    final level = bottom - (bottom - top - 18) * fill;
    if (fill > 0) {
      canvas.save();
      canvas.clipPath(Path.from(glass)..close());
      final wave = Path()..moveTo(0, h);
      final phase = t * math.pi * 6;
      final amp = 5 * (1 - _seg(t, 0.7, 1.0)) + 1.5;
      for (var x = 0.0; x <= w; x += 2) {
        wave.lineTo(x, level + math.sin(x / w * math.pi * 3 + phase) * amp);
      }
      wave
        ..lineTo(w, h)
        ..close();
      canvas.drawPath(
        wave,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withValues(alpha: 0.75), color],
          ).createShader(Rect.fromLTRB(0, level, w, bottom)),
      );
      // Bubbles.
      final rnd = math.Random(4);
      for (var i = 0; i < 7; i++) {
        final start = 0.25 + rnd.nextDouble() * 0.4;
        final p = _seg(t, start, start + 0.35);
        if (p <= 0 || p >= 1) continue;
        final x = cx + (rnd.nextDouble() - 0.5) * bottomHalf * 1.6;
        final y = bottom - (bottom - level) * p;
        canvas.drawCircle(
          Offset(x + math.sin(p * 8) * 3, y),
          2 + rnd.nextDouble() * 3,
          Paint()..color = Colors.white.withValues(alpha: 0.7 * (1 - p)),
        );
      }
      canvas.restore();
    }

    // Splash ring where the drop lands.
    final splash = _seg(t, 0.2, 0.45);
    if (splash > 0 && splash < 1) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = color.withValues(alpha: 1 - splash);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx, bottom - 6),
          width: 20 + 60 * splash,
          height: 6 + 14 * splash,
        ),
        paint,
      );
    }

    canvas.drawPath(
      glass,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = look.ink.withValues(alpha: 0.75),
    );
    // Shine on the glass.
    canvas.drawLine(
      Offset(cx - topHalf + 10, top + 14),
      Offset(cx - bottomHalf + 8, top + (bottom - top) * 0.45),
      Paint()
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..color = Colors.white.withValues(alpha: 0.6),
    );
    _sparkles(canvas, size, start: 0.7, count: 4, color: color);
  }

  void _drawDrop(Canvas canvas, Offset c, double r, Color color) {
    final path = Path()
      ..moveTo(c.dx, c.dy - r * 1.8)
      ..quadraticBezierTo(
        c.dx + r * 1.1,
        c.dy - r * 0.2,
        c.dx + r,
        c.dy + r * 0.3,
      )
      ..arcToPoint(Offset(c.dx - r, c.dy + r * 0.3), radius: Radius.circular(r))
      ..quadraticBezierTo(c.dx - r * 1.1, c.dy - r * 0.2, c.dx, c.dy - r * 1.8)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  /// A crescent moon rocks gently while Z's float up and stars twinkle.
  void _sleep(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final c = Offset(w * 0.45, h * 0.55);
    final r = w * 0.27;
    final appear = Curves.easeOutBack.transform(_seg(t, 0, 0.3));
    final rock = math.sin(t * math.pi * 3) * 0.12 * (1 - _seg(t, 0.7, 1));
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(rock);
    canvas.scale(appear);
    final moon = Path.combine(
      PathOperation.difference,
      Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: r)),
      Path()..addOval(
        Rect.fromCircle(
          center: Offset(r * 0.55 * forward, -r * 0.35),
          radius: r * 0.85,
        ),
      ),
    );
    canvas.drawPath(
      moon,
      Paint()
        ..shader = LinearGradient(
          colors: [const Color(0xFFFFD66B), const Color(0xFFFFB443)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: r)),
    );
    canvas.restore();

    // Stars twinkle around the moon.
    final stars = [
      Offset(w * 0.78, h * 0.22),
      Offset(w * 0.2, h * 0.18),
      Offset(w * 0.86, h * 0.62),
      Offset(w * 0.12, h * 0.8),
    ];
    for (final (i, s) in stars.indexed) {
      final p = _seg(t, 0.15 + i * 0.08, 0.5 + i * 0.08);
      if (p <= 0) continue;
      final tw = 0.6 + 0.4 * math.sin(t * math.pi * 8 + i);
      _star(
        canvas,
        Offset(w / 2 + (s.dx - w / 2) * forward, s.dy),
        5 + 3 * tw * p,
        color.withValues(alpha: p),
      );
    }

    // Z's drift up and forward.
    for (var i = 0; i < 3; i++) {
      final p = _seg(t, 0.25 + i * 0.15, 0.85 + i * 0.05);
      if (p <= 0 || p >= 1) continue;
      final x = c.dx + forward * (r * 0.9 + 30 * p + i * 6);
      final y = c.dy - r * 0.6 - 60 * p - i * 4;
      final tp = TextPainter(
        text: TextSpan(
          text: 'z',
          style: TextStyle(
            fontFamily: 'Fredoka',
            fontWeight: FontWeight.w700,
            fontSize: 16.0 + i * 6,
            color: color.withValues(alpha: math.sin(p * math.pi)),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
    }
  }

  /// A book opens, a page turns, and sparkles rise from it.
  void _reading(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, base = h * 0.78;
    final open = Curves.easeOutBack.transform(_seg(t, 0, 0.3));
    final pageW = w * 0.36 * open, pageH = h * 0.42;
    final cover = Paint()..color = color;
    final paper = Paint()..color = Colors.white;
    final line = Paint()
      ..color = look.muted.withValues(alpha: 0.35)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Cover behind the pages.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
          cx - pageW - 6,
          base - pageH + 4,
          cx + pageW + 6,
          base + 8,
        ),
        const Radius.circular(8),
      ),
      cover,
    );
    Path page(double dir) => Path()
      ..moveTo(cx, base - pageH + 12)
      ..quadraticBezierTo(
        cx + dir * pageW * 0.5,
        base - pageH - 4,
        cx + dir * pageW,
        base - pageH + 6,
      )
      ..lineTo(cx + dir * pageW, base)
      ..quadraticBezierTo(cx + dir * pageW * 0.5, base - 12, cx, base + 2)
      ..close();
    for (final dir in [-1.0, 1.0]) {
      canvas.drawPath(page(dir), paper);
      canvas.drawPath(
        page(dir),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = look.ink.withValues(alpha: 0.15),
      );
      for (var i = 1; i <= 4; i++) {
        final y = base - pageH + 12 + i * pageH / 6;
        canvas.drawLine(
          Offset(cx + dir * 10, y),
          Offset(cx + dir * (pageW - 10), y - 3),
          line,
        );
      }
    }

    // One page flips over the spine, in reading direction.
    final flip = Curves.easeInOut.transform(_seg(t, 0.3, 0.7));
    if (flip > 0 && flip < 1) {
      final dir = forward * math.cos(flip * math.pi);
      canvas.drawPath(
        page(dir),
        Paint()
          ..color = Color.lerp(
            Colors.white,
            const Color(0xFFF4F0EA),
            (1 - dir.abs()),
          )!,
      );
    }

    _sparkles(
      canvas,
      size,
      start: 0.45,
      count: 6,
      color: color,
      fromY: base - pageH,
    );
  }

  /// A gold medal swings in on its ribbon and catches the light.
  void _sport(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final drop = Curves.bounceOut.transform(_seg(t, 0, 0.4));
    final swing = math.sin(t * math.pi * 4) * 0.25 * (1 - _seg(t, 0.2, 0.9));
    final pivot = Offset(w / 2, 0);
    canvas.save();
    canvas.translate(pivot.dx, pivot.dy - h * 0.6 * (1 - drop));
    canvas.rotate(swing);
    // Ribbon.
    final ribbonL = Path()
      ..moveTo(-26, 0)
      ..lineTo(-8, 0)
      ..lineTo(10, h * 0.5)
      ..lineTo(-8, h * 0.5)
      ..close();
    final ribbonR = Path()
      ..moveTo(26, 0)
      ..lineTo(8, 0)
      ..lineTo(-10, h * 0.5)
      ..lineTo(8, h * 0.5)
      ..close();
    canvas.drawPath(ribbonL, Paint()..color = const Color(0xFF3D9BFF));
    canvas.drawPath(ribbonR, Paint()..color = const Color(0xFFF2547D));
    // Medal.
    final mc = Offset(0, h * 0.64);
    final r = w * 0.22;
    canvas.drawCircle(mc, r + 5, Paint()..color = const Color(0xFFE09A12));
    canvas.drawCircle(
      mc,
      r,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFFFE27A), Color(0xFFF2B01E)],
        ).createShader(Rect.fromCircle(center: mc, radius: r)),
    );
    _star(canvas, mc, r * 0.55, Colors.white.withValues(alpha: 0.9));
    // Light sweeps across the medal.
    final sweep = _seg(t, 0.45, 0.75);
    if (sweep > 0 && sweep < 1) {
      canvas.save();
      canvas.clipPath(Path()..addOval(Rect.fromCircle(center: mc, radius: r)));
      final x = mc.dx - r * 1.5 + r * 3 * sweep;
      canvas.drawPath(
        Path()
          ..moveTo(x, mc.dy - r)
          ..lineTo(x + 14, mc.dy - r)
          ..lineTo(x - 6, mc.dy + r)
          ..lineTo(x - 20, mc.dy + r)
          ..close(),
        Paint()..color = Colors.white.withValues(alpha: 0.7),
      );
      canvas.restore();
    }
    canvas.restore();
    _sparkles(
      canvas,
      size,
      start: 0.35,
      count: 6,
      color: color,
      fromY: h * 0.64,
    );
  }

  /// Hearts float up from the middle while a big heart beats.
  void _family(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final c = Offset(w / 2, h * 0.58);
    final pop = Curves.elasticOut.transform(_seg(t, 0, 0.45));
    final beat = 1 + 0.08 * math.sin(_seg(t, 0.4, 1) * math.pi * 4);
    _heart(canvas, c, w * 0.26 * pop * beat, color);
    final rnd = math.Random(7);
    for (var i = 0; i < 8; i++) {
      final start = 0.1 + i * 0.07;
      final p = _seg(t, start, start + 0.55);
      if (p <= 0 || p >= 1) continue;
      final dx = (rnd.nextDouble() - 0.5) * w * 0.8;
      final x =
          c.dx + dx * Curves.easeOut.transform(p) + math.sin(p * 9 + i) * 6;
      final y = c.dy - h * 0.55 * p;
      final colors = [color, const Color(0xFFFF8A3D), const Color(0xFF7C5CFF)];
      _heart(
        canvas,
        Offset(x, y),
        7 + rnd.nextDouble() * 7,
        colors[i % 3].withValues(alpha: math.sin(p * math.pi)),
      );
    }
  }

  /// A check draws itself in a circle and confetti bursts around it.
  void _confetti(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final c = Offset(w / 2, h / 2);
    final r = w * 0.26;
    final pop = Curves.elasticOut.transform(_seg(t, 0, 0.4));
    canvas.drawCircle(c, r * pop, Paint()..color = color);
    final draw = Curves.easeOut.transform(_seg(t, 0.15, 0.45));
    if (draw > 0) {
      final check = Path()
        ..moveTo(c.dx - r * 0.42, c.dy + r * 0.02)
        ..lineTo(c.dx - r * 0.1, c.dy + r * 0.34)
        ..lineTo(c.dx + r * 0.46, c.dy - r * 0.3);
      final metric = check.computeMetrics().first;
      canvas.drawPath(
        metric.extractPath(0, metric.length * draw),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 9
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = Colors.white,
      );
    }
    final burst = _seg(t, 0.1, 0.95);
    if (burst > 0 && burst < 1) {
      final rnd = math.Random(11);
      final colors = look.memberColors;
      for (var i = 0; i < 26; i++) {
        final angle = rnd.nextDouble() * math.pi * 2;
        final speed = 0.6 + rnd.nextDouble() * 0.6;
        final dist = w * 0.55 * speed * Curves.easeOutCubic.transform(burst);
        final fall = 40 * burst * burst;
        final p =
            c + Offset(math.cos(angle) * dist, math.sin(angle) * dist + fall);
        canvas.save();
        canvas.translate(p.dx, p.dy);
        canvas.rotate(burst * 10 * (rnd.nextBool() ? 1 : -1) + angle);
        final paint = Paint()
          ..color = colors[i % colors.length].withValues(
            alpha: 1 - _seg(burst, 0.7, 1),
          );
        if (i.isEven) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset.zero, width: 10, height: 5),
              const Radius.circular(2),
            ),
            paint,
          );
        } else {
          canvas.drawCircle(Offset.zero, 3.5, paint);
        }
        canvas.restore();
      }
    }
  }

  Paint _stroke(Color color, double width) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..color = color;

  /// Draws the first [p] (0 to 1) of [path].
  void _drawPartial(Canvas canvas, Path path, double p, Paint paint) {
    if (p <= 0) return;
    for (final metric in path.computeMetrics()) {
      canvas.drawPath(metric.extractPath(0, metric.length * p), paint);
    }
  }

  /// A heart beats twice while a heartbeat line runs across it.
  void _health(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final c = Offset(w / 2, h * 0.5);
    final pop = Curves.elasticOut.transform(_seg(t, 0, 0.35));
    final beat = _seg(t, 0.35, 0.95);
    final pulse = 1 + 0.12 * math.pow(math.sin(beat * math.pi * 4), 8);
    _heart(canvas, c, w * 0.26 * pop * pulse, color);
    final y = c.dy;
    final line = Path()..moveTo(w * 0.04, y);
    final pts = [
      [0.30, 0.0],
      [0.38, -0.05],
      [0.44, 0.22],
      [0.52, -0.34],
      [0.60, 0.12],
      [0.66, 0.0],
      [0.96, 0.0],
    ];
    for (final p in pts) {
      line.lineTo(w * p[0], y + h * p[1]);
    }
    final lineDir = forward;
    canvas.save();
    if (lineDir < 0) {
      canvas.translate(w, 0);
      canvas.scale(-1, 1);
    }
    _drawPartial(
      canvas,
      line,
      Curves.easeInOut.transform(_seg(t, 0.2, 0.75)),
      _stroke(Colors.white, 4.5),
    );
    canvas.restore();
    _sparkles(canvas, size, start: 0.6, count: 4, color: color, fromY: h * 0.3);
  }

  /// A chain snaps in the middle and its links fly apart.
  void _breakHabit(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final c = Offset(w / 2, h / 2);
    final appear = Curves.easeOutBack.transform(_seg(t, 0, 0.25));
    final snap = Curves.easeOutCubic.transform(_seg(t, 0.38, 0.75));
    final shake = t < 0.38 && t > 0.2 ? math.sin(t * 120) * 2 : 0.0;
    final linkW = w * 0.34, linkH = h * 0.2;
    final paint = _stroke(look.muted.withValues(alpha: 0.9), 9);
    void link(double dx, double angle) {
      canvas.save();
      canvas.translate(c.dx + dx + shake, c.dy);
      canvas.rotate(angle);
      canvas.scale(appear);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: linkW, height: linkH),
          Radius.circular(linkH / 2),
        ),
        paint,
      );
      canvas.restore();
    }

    link(-linkW * 0.38 - snap * w * 0.14, -snap * 0.5);
    link(linkW * 0.38 + snap * w * 0.14, snap * 0.5);
    // Sparks fly out of the break.
    if (snap > 0 && snap < 1) {
      final rnd = math.Random(3);
      for (var i = 0; i < 10; i++) {
        final a = rnd.nextDouble() * math.pi * 2;
        final d = w * 0.35 * snap;
        final p = c + Offset(math.cos(a) * d, math.sin(a) * d);
        canvas.drawLine(
          p,
          p + Offset(math.cos(a) * 8, math.sin(a) * 8),
          _stroke(color.withValues(alpha: 1 - snap), 3),
        );
      }
    }
    // A "free" burst ring.
    final ring = _seg(t, 0.4, 0.8);
    if (ring > 0 && ring < 1) {
      canvas.drawCircle(
        c,
        w * 0.1 + w * 0.3 * ring,
        _stroke(color.withValues(alpha: 1 - ring), 3),
      );
    }
  }

  /// An apple bounces in and its leaf unfurls.
  void _nutrition(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final drop = Curves.bounceOut.transform(_seg(t, 0, 0.45));
    final c = Offset(w / 2, h * 0.58 - h * 0.6 * (1 - drop));
    final r = w * 0.25;
    final apple = Path()
      ..moveTo(c.dx, c.dy - r * 0.75)
      ..cubicTo(
        c.dx + r * 0.6,
        c.dy - r * 1.15,
        c.dx + r * 1.35,
        c.dy - r * 0.6,
        c.dx + r * 1.05,
        c.dy + r * 0.35,
      )
      ..cubicTo(
        c.dx + r * 0.8,
        c.dy + r * 1.1,
        c.dx + r * 0.25,
        c.dy + r * 1.05,
        c.dx,
        c.dy + r * 0.85,
      )
      ..cubicTo(
        c.dx - r * 0.25,
        c.dy + r * 1.05,
        c.dx - r * 0.8,
        c.dy + r * 1.1,
        c.dx - r * 1.05,
        c.dy + r * 0.35,
      )
      ..cubicTo(
        c.dx - r * 1.35,
        c.dy - r * 0.6,
        c.dx - r * 0.6,
        c.dy - r * 1.15,
        c.dx,
        c.dy - r * 0.75,
      )
      ..close();
    canvas.drawPath(
      apple,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.3, -0.4),
          colors: [Color(0xFFFF7A6B), Color(0xFFE5383B)],
        ).createShader(Rect.fromCircle(center: c, radius: r * 1.2)),
    );
    // Shine.
    canvas.drawOval(
      Rect.fromCenter(
        center: c + Offset(-r * 0.45, -r * 0.25),
        width: r * 0.28,
        height: r * 0.5,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.55),
    );
    // Stem.
    canvas.drawLine(
      c + Offset(0, -r * 0.7),
      c + Offset(r * 0.08, -r * 1.15),
      _stroke(const Color(0xFF6D4C41), 4),
    );
    // Leaf grows and wiggles.
    final grow = Curves.elasticOut.transform(_seg(t, 0.35, 0.8));
    final wiggle = math.sin(t * math.pi * 6) * 0.15 * (1 - _seg(t, 0.7, 1));
    canvas.save();
    canvas.translate(c.dx + r * 0.1, c.dy - r * 1.05);
    canvas.rotate(-0.5 + wiggle);
    canvas.scale(grow);
    final leaf = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(r * 0.35, -r * 0.35, r * 0.8, 0)
      ..quadraticBezierTo(r * 0.35, r * 0.3, 0, 0)
      ..close();
    canvas.drawPath(leaf, Paint()..color = color);
    canvas.restore();
    _sparkles(
      canvas,
      size,
      start: 0.45,
      count: 5,
      color: color,
      fromY: h * 0.4,
    );
  }

  /// Soap bubbles float up, wobble and pop.
  void _selfCare(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final rnd = math.Random(21);
    for (var i = 0; i < 9; i++) {
      final start = i * 0.06;
      final p = _seg(t, start, start + 0.6);
      if (p <= 0) continue;
      final r = 8 + rnd.nextDouble() * 16;
      final x0 = w * (0.2 + rnd.nextDouble() * 0.6);
      final x = x0 + math.sin(p * math.pi * 3 + i) * 8;
      final y = h * 0.95 - h * 0.8 * Curves.easeOut.transform(p);
      final popping = _seg(p, 0.85, 1);
      if (popping >= 1) continue;
      final rr = r * (1 + popping * 0.5);
      final alpha = 1 - popping;
      final c = Offset(x, y);
      canvas.drawCircle(
        c,
        rr,
        Paint()
          ..shader = RadialGradient(
            colors: [
              color.withValues(alpha: 0.05 * alpha),
              color.withValues(alpha: 0.25 * alpha),
              const Color(0xFFB388FF).withValues(alpha: 0.45 * alpha),
            ],
            stops: const [0.5, 0.85, 1],
          ).createShader(Rect.fromCircle(center: c, radius: rr)),
      );
      canvas.drawCircle(
        c,
        rr,
        _stroke(color.withValues(alpha: 0.7 * alpha), 1.5),
      );
      canvas.drawCircle(
        c + Offset(-rr * 0.35, -rr * 0.35),
        rr * 0.22,
        Paint()..color = Colors.white.withValues(alpha: 0.85 * alpha),
      );
    }
    _sparkles(
      canvas,
      size,
      start: 0.55,
      count: 4,
      color: color,
      fromY: h * 0.35,
    );
  }

  /// A lotus opens its petals over calm ripples.
  void _mindfulness(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final base = Offset(w / 2, h * 0.68);
    // Ripples.
    for (var i = 0; i < 3; i++) {
      final p = _seg(t, 0.1 + i * 0.2, 0.75 + i * 0.1);
      if (p <= 0 || p >= 1) continue;
      canvas.drawOval(
        Rect.fromCenter(
          center: base + const Offset(0, 8),
          width: w * 0.3 + w * 0.6 * p,
          height: 14 + 22 * p,
        ),
        _stroke(color.withValues(alpha: 0.6 * (1 - p)), 2.5),
      );
    }
    final open = Curves.easeOutBack.transform(_seg(t, 0.1, 0.65));
    final petalH = h * 0.42, petalW = w * 0.15;
    Path petal() => Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(petalW, -petalH * 0.5, 0, -petalH)
      ..quadraticBezierTo(-petalW, -petalH * 0.5, 0, 0)
      ..close();
    final angles = [-1.1, -0.55, 0.55, 1.1, 0.0];
    for (final (i, a) in angles.indexed) {
      canvas.save();
      canvas.translate(base.dx, base.dy);
      canvas.rotate(a * open);
      final shade = i == 4 ? 1.0 : (a.abs() > 1 ? 0.55 : 0.78);
      canvas.drawPath(
        petal(),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.lerp(color, Colors.white, 0.1)!.withValues(alpha: shade),
              Color.lerp(
                color,
                const Color(0xFFFFB3D1),
                0.6,
              )!.withValues(alpha: shade),
            ],
          ).createShader(Rect.fromLTWH(-petalW, -petalH, petalW * 2, petalH)),
      );
      canvas.restore();
    }
    // Glow dot rising above the flower.
    final glow = _seg(t, 0.5, 1);
    if (glow > 0) {
      canvas.drawCircle(
        base - Offset(0, petalH + 14 + 10 * glow),
        5,
        Paint()
          ..color = const Color(0xFFFFD66B)
              .withValues(alpha: math.sin(glow * math.pi)),
      );
    }
  }

  /// Two arms wrap around a heart in a hug.
  void _familyCare(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final c = Offset(w / 2, h * 0.48);
    final pop = Curves.elasticOut.transform(_seg(t, 0, 0.4));
    final beat = 1 + 0.06 * math.sin(_seg(t, 0.5, 1) * math.pi * 4);
    _heart(canvas, c, w * 0.2 * pop * beat, color);
    final hug = Curves.easeOutCubic.transform(_seg(t, 0.2, 0.6));
    final r = w * 0.36;
    final armPaint = _stroke(const Color(0xFFF2A65A), 10);
    final sweep = math.pi * 0.62 * hug;
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      math.pi * 0.95,
      -sweep,
      false,
      armPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      math.pi * 0.05,
      sweep,
      false,
      armPaint,
    );
    // Hands at the ends of the arms.
    if (hug > 0) {
      final hand = Paint()..color = const Color(0xFFF2A65A);
      for (final a in [math.pi * 0.95 - sweep, math.pi * 0.05 + sweep]) {
        canvas.drawCircle(c + Offset(math.cos(a), math.sin(a)) * r, 9, hand);
      }
    }
    // Small hearts rise after the hug closes.
    final rnd = math.Random(9);
    for (var i = 0; i < 4; i++) {
      final p = _seg(t, 0.55 + i * 0.06, 0.95 + i * 0.02);
      if (p <= 0 || p >= 1) continue;
      final x = c.dx + (rnd.nextDouble() - 0.5) * w * 0.7;
      _heart(
        canvas,
        Offset(x, c.dy - r * 0.6 - 40 * p),
        6,
        color.withValues(alpha: math.sin(p * math.pi)),
      );
    }
  }

  /// A warm bowl slides up and steam curls out of it.
  void _familyMeals(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final rise = Curves.easeOutBack.transform(_seg(t, 0, 0.35));
    final rimY = h * 0.6 + h * 0.4 * (1 - rise);
    final cx = w / 2, bw = w * 0.36;
    // Food peeking over the rim.
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, rimY), width: bw * 2, height: 18),
      Paint()..color = const Color(0xFFFFD08A),
    );
    for (final (i, dx) in [-0.45, 0.0, 0.42].indexed) {
      canvas.drawCircle(
        Offset(cx + bw * dx, rimY - 4),
        7,
        Paint()
          ..color = [
            const Color(0xFF6DBE45),
            const Color(0xFFE5383B),
            const Color(0xFFF2B01E),
          ][i],
      );
    }
    final bowl = Path()
      ..moveTo(cx - bw, rimY)
      ..quadraticBezierTo(cx - bw, rimY + h * 0.3, cx, rimY + h * 0.3)
      ..quadraticBezierTo(cx + bw, rimY + h * 0.3, cx + bw, rimY)
      ..close();
    canvas.drawPath(bowl, Paint()..color = color);
    canvas.drawLine(
      Offset(cx - bw * 0.6, rimY + h * 0.08),
      Offset(cx - bw * 0.3, rimY + h * 0.18),
      _stroke(Colors.white.withValues(alpha: 0.5), 4),
    );
    // Steam.
    for (var i = 0; i < 3; i++) {
      final p = _seg(t, 0.3 + i * 0.1, 0.9 + i * 0.03);
      if (p <= 0 || p >= 1) continue;
      final x = cx + (i - 1) * bw * 0.5;
      final steam = Path()..moveTo(x, rimY - 10);
      for (var s = 1; s <= 12; s++) {
        final f = s / 12;
        steam.lineTo(
          x + math.sin(f * math.pi * 2 + t * 10 + i) * 6,
          rimY - 10 - f * h * 0.4,
        );
      }
      _drawPartial(
        canvas,
        steam,
        Curves.easeOut.transform(p),
        _stroke(look.muted.withValues(alpha: 0.5 * math.sin(p * math.pi)), 4),
      );
    }
  }

  /// A house draws itself, its windows light up and it sparkles clean.
  void _homeTasks(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final l = w * 0.22,
        r = w * 0.78,
        top = h * 0.2,
        eave = h * 0.45,
        bottom = h * 0.88;
    final house = Path()
      ..moveTo(l, bottom)
      ..lineTo(l, eave)
      ..lineTo(w / 2, top)
      ..lineTo(r, eave)
      ..lineTo(r, bottom)
      ..close();
    final draw = Curves.easeInOut.transform(_seg(t, 0, 0.45));
    final fill = _seg(t, 0.35, 0.55);
    if (fill > 0) {
      canvas.drawPath(
        house,
        Paint()..color = color.withValues(alpha: 0.18 * fill),
      );
    }
    _drawPartial(canvas, house, draw, _stroke(color, 6));
    // Door.
    if (fill > 0) {
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTRB(w / 2 - 12, bottom - 34 * fill, w / 2 + 12, bottom),
          topLeft: const Radius.circular(10),
          topRight: const Radius.circular(10),
        ),
        Paint()..color = color,
      );
    }
    // Windows light up one after the other.
    for (final (i, x) in [l + 14.0, r - 34.0].indexed) {
      final on = Curves.easeOut.transform(
        _seg(t, 0.5 + i * 0.1, 0.65 + i * 0.1),
      );
      final rect = Rect.fromLTWH(x, eave + 10, 20, 20);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        Paint()
          ..color = Color.lerp(
            color.withValues(alpha: 0.25),
            const Color(0xFFFFD166),
            on,
          )!,
      );
      if (on > 0) {
        canvas.drawCircle(
          rect.center,
          18 * on,
          Paint()..color = const Color(0xFFFFD166).withValues(alpha: 0.25 * on),
        );
      }
    }
    _sparkles(
      canvas,
      size,
      start: 0.6,
      count: 5,
      color: const Color(0xFFFFB443),
      fromY: top + 20,
    );
  }

  /// A checklist ticks its items one by one.
  void _work(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final slide = Curves.easeOutBack.transform(_seg(t, 0, 0.3));
    final board = Rect.fromLTRB(
      w * 0.22,
      h * 0.1 + h * 0.3 * (1 - slide),
      w * 0.78,
      h * 0.94 + h * 0.3 * (1 - slide),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(board, const Radius.circular(14)),
      Paint()..color = color,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(board.deflate(8), const Radius.circular(8)),
      Paint()..color = Colors.white,
    );
    // Clip at the top.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(board.center.dx, board.top + 4),
          width: w * 0.22,
          height: 14,
        ),
        const Radius.circular(6),
      ),
      Paint()..color = look.ink.withValues(alpha: 0.75),
    );
    for (var i = 0; i < 3; i++) {
      final y = board.top + 34 + i * (board.height - 50) / 3;
      final startX = forward > 0 ? board.left + 18 : board.right - 18;
      final box = Rect.fromCenter(
        center: Offset(startX, y),
        width: 16,
        height: 16,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(box, const Radius.circular(4)),
        _stroke(look.muted.withValues(alpha: 0.6), 2),
      );
      canvas.drawLine(
        Offset(startX + forward * 18, y),
        Offset(startX + forward * (board.width - 54), y),
        _stroke(look.muted.withValues(alpha: 0.3), 4),
      );
      final tick = Curves.easeOut.transform(
        _seg(t, 0.35 + i * 0.15, 0.5 + i * 0.15),
      );
      final check = Path()
        ..moveTo(box.left + 2, box.center.dy)
        ..lineTo(box.center.dx - 1, box.bottom - 2)
        ..lineTo(box.right + 6, box.top - 6);
      _drawPartial(canvas, check, tick, _stroke(look.done, 4));
    }
  }

  /// Gold coins drop into a jar one after another.
  void _finance(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, top = h * 0.36, bottom = h * 0.94, half = w * 0.27;
    final jar = Rect.fromLTRB(cx - half, top, cx + half, bottom);
    canvas.drawRRect(
      RRect.fromRectAndRadius(jar, const Radius.circular(18)),
      Paint()..color = color.withValues(alpha: 0.15),
    );
    // Coins already in the jar.
    var landed = 0;
    for (var i = 0; i < 4; i++) {
      final p = _seg(t, 0.08 + i * 0.13, 0.28 + i * 0.13);
      if (p <= 0) continue;
      final restY = bottom - 14 - landed * 12.0;
      final y = Curves.bounceOut.transform(p) * (restY + 20) - 20;
      if (p >= 1) landed++;
      _coin(
        canvas,
        Offset(cx + (i.isEven ? -6 : 6), y),
        w * 0.12,
        p >= 1 ? 0 : p * 6,
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(jar, const Radius.circular(18)),
      _stroke(color, 5),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, top), width: half * 1.6, height: 12),
        const Radius.circular(6),
      ),
      Paint()..color = color,
    );
    _sparkles(
      canvas,
      size,
      start: 0.65,
      count: 4,
      color: const Color(0xFFF2B01E),
      fromY: top,
    );
  }

  void _coin(Canvas canvas, Offset c, double r, double spin) {
    final squash = math.cos(spin).abs().clamp(0.25, 1.0);
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.scale(1, squash * 0.55 + 0.45 * squash);
    canvas.drawCircle(Offset.zero, r, Paint()..color = const Color(0xFFE09A12));
    canvas.drawCircle(
      Offset.zero,
      r * 0.8,
      Paint()..color = const Color(0xFFFFCF3F),
    );
    canvas.restore();
  }

  /// The sun rises over green hills and a little tree pops up.
  void _outdoor(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final rise = Curves.easeOutCubic.transform(_seg(t, 0.05, 0.55));
    final sun = Offset(
      w * 0.5 + forward * w * 0.12,
      h * 0.75 - h * 0.45 * rise,
    );
    // Rays.
    final rays = _seg(t, 0.3, 1);
    for (var i = 0; i < 10; i++) {
      final a = i * math.pi / 5 + t * 1.5;
      final inner = w * 0.15,
          outer = w * (0.19 + 0.04 * math.sin(t * 12 + i)) * (0.4 + 0.6 * rays);
      if (rays <= 0) break;
      canvas.drawLine(
        sun + Offset(math.cos(a), math.sin(a)) * inner,
        sun + Offset(math.cos(a), math.sin(a)) * (inner + outer * 0.6),
        _stroke(const Color(0xFFFFC233).withValues(alpha: rays), 4),
      );
    }
    canvas.drawCircle(sun, w * 0.12, Paint()..color = const Color(0xFFFFC233));
    // Hills in front of the sun.
    final back = Path()
      ..moveTo(0, h)
      ..lineTo(0, h * 0.72)
      ..quadraticBezierTo(w * 0.3, h * 0.52, w * 0.62, h * 0.72)
      ..lineTo(w * 0.62, h)
      ..close();
    final front = Path()
      ..moveTo(w * 0.3, h)
      ..quadraticBezierTo(w * 0.65, h * 0.55, w, h * 0.68)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(back, Paint()..color = const Color(0xFF8BD17C));
    canvas.drawPath(front, Paint()..color = color);
    // Tree pops up on the front hill.
    final tree = Curves.elasticOut.transform(_seg(t, 0.45, 0.9));
    if (tree > 0) {
      final base = Offset(w * 0.5 - forward * w * 0.22, h * 0.8);
      canvas.drawLine(
        base,
        base - Offset(0, 18 * tree),
        _stroke(const Color(0xFF6D4C41), 5),
      );
      canvas.drawCircle(
        base - Offset(0, 28 * tree),
        14 * tree,
        Paint()..color = const Color(0xFF2E8B57),
      );
    }
  }

  /// Paint splats land in bright colors and a brush stroke sweeps across.
  void _art(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    const colors = [
      Color(0xFFFF5C8A),
      Color(0xFF3D9BFF),
      Color(0xFFFFC233),
      Color(0xFF22B455),
    ];
    final spots = [
      Offset(w * 0.3, h * 0.32),
      Offset(w * 0.7, h * 0.3),
      Offset(w * 0.32, h * 0.7),
      Offset(w * 0.7, h * 0.68),
    ];
    for (var i = 0; i < 4; i++) {
      final p = Curves.elasticOut.transform(_seg(t, i * 0.1, 0.35 + i * 0.1));
      if (p <= 0) continue;
      final c = Offset(w / 2 + (spots[i].dx - w / 2) * forward, spots[i].dy);
      final rnd = math.Random(i + 30);
      final r = w * 0.13 * p;
      // A wobbly round splat: smooth curves through jittered points.
      const n = 10;
      final pts = [
        for (var k = 0; k < n; k++)
          c +
              Offset(
                    math.cos(k / n * math.pi * 2),
                    math.sin(k / n * math.pi * 2),
                  ) *
                  (r * (0.8 + rnd.nextDouble() * 0.35)),
      ];
      Offset mid(int k) => (pts[k % n] + pts[(k + 1) % n]) / 2;
      final blob = Path()..moveTo(mid(0).dx, mid(0).dy);
      for (var k = 1; k <= n; k++) {
        final m = mid(k);
        blob.quadraticBezierTo(pts[k % n].dx, pts[k % n].dy, m.dx, m.dy);
      }
      blob.close();
      canvas.drawPath(blob, Paint()..color = colors[i]);
      // Droplets.
      for (var k = 0; k < 3; k++) {
        final a = rnd.nextDouble() * math.pi * 2;
        canvas.drawCircle(
          c + Offset(math.cos(a), math.sin(a)) * r * 1.4,
          3 * p,
          Paint()..color = colors[i],
        );
      }
    }
    // Brush stroke.
    final stroke = Path()
      ..moveTo(w * 0.12, h * 0.55)
      ..cubicTo(w * 0.35, h * 0.35, w * 0.6, h * 0.75, w * 0.88, h * 0.45);
    canvas.save();
    if (forward < 0) {
      canvas.translate(w, 0);
      canvas.scale(-1, 1);
    }
    _drawPartial(
      canvas,
      stroke,
      Curves.easeInOut.transform(_seg(t, 0.45, 0.8)),
      _stroke(color, 9),
    );
    canvas.restore();
  }

  /// Two puzzle pieces slide together and click.
  void _hobbies(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final s = w * 0.3;
    final c = Offset(w / 2, h / 2);
    final slide = Curves.easeOutBack.transform(_seg(t, 0.05, 0.5));
    Path piece({required bool tab}) {
      final knob = s * 0.2;
      final p = Path()
        ..moveTo(0, 0)
        ..lineTo(s, 0)
        ..lineTo(s, s * 0.32);
      if (tab) {
        p.arcToPoint(
          Offset(s, s * 0.68),
          radius: Radius.circular(knob),
          clockwise: true,
        );
      } else {
        p.arcToPoint(
          Offset(s, s * 0.68),
          radius: Radius.circular(knob),
          clockwise: false,
        );
      }
      p
        ..lineTo(s, s)
        ..lineTo(0, s)
        ..close();
      return p;
    }

    final gap = (1 - slide) * w * 0.4;
    canvas.save();
    canvas.translate(c.dx - s - gap, c.dy - s / 2);
    canvas.drawPath(piece(tab: true), Paint()..color = color);
    canvas.restore();
    canvas.save();
    canvas.translate(c.dx + s + gap, c.dy - s / 2);
    canvas.scale(-1, 1);
    canvas.drawPath(
      piece(tab: false),
      Paint()..color = const Color(0xFFF2B01E),
    );
    canvas.restore();
    // Click flash.
    final click = _seg(t, 0.42, 0.7);
    if (click > 0 && click < 1) {
      for (var i = 0; i < 8; i++) {
        final a = i * math.pi / 4;
        final from =
            c + Offset(math.cos(a), math.sin(a)) * (s * 0.9 + 20 * click);
        canvas.drawLine(
          from,
          from + Offset(math.cos(a), math.sin(a)) * 10,
          _stroke(color.withValues(alpha: 1 - click), 3),
        );
      }
    }
    _sparkles(
      canvas,
      size,
      start: 0.55,
      count: 4,
      color: color,
      fromY: c.dy - s / 2,
    );
  }

  /// Draws [emoji] centred on [c]. Colour emoji ignore the text colour, so
  /// see-through emoji are drawn on a faded layer.
  void _emoji(
    Canvas canvas,
    String emoji,
    Offset c,
    double size, {
    double scale = 1,
    double scaleY = 1,
    double angle = 0,
    double opacity = 1,
  }) {
    if (scale <= 0 || opacity <= 0) return;
    final painter = TextPainter(
      text: TextSpan(
        text: emoji,
        style: TextStyle(
          fontSize: size,
          height: 1,
          fontFamilyFallback: const ['Noto Color Emoji'],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(angle);
    canvas.scale(scale, scale * scaleY);
    if (opacity < 1) {
      canvas.saveLayer(
        null,
        Paint()..color = Color.fromRGBO(0, 0, 0, opacity.clamp(0.0, 1.0)),
      );
    }
    painter.paint(canvas, Offset(-painter.width / 2, -painter.height / 2));
    if (opacity < 1) canvas.restore();
    canvas.restore();
    painter.dispose();
  }

  /// A habit's own picture, moving the way its [Scene] says.
  void _scene(Canvas canvas, Size size, Scene scene) {
    final w = size.width, h = size.height;
    final c = Offset(w / 2, h * 0.54);
    final extra = scene.extra;
    // A soft glow in the category's colour behind every picture.
    final glow = Curves.easeOutBack.transform(_seg(t, 0, 0.3));
    canvas.drawCircle(
      c,
      w * 0.36 * glow,
      Paint()..color = color.withValues(alpha: 0.14),
    );
    switch (scene.motion) {
      case Motion.pop:
        _emoji(
          canvas,
          scene.emoji,
          c,
          70,
          scale: Curves.elasticOut.transform(_seg(t, 0, 0.4)),
          angle: math.sin(t * 14) * 0.12 * (1 - _seg(t, 0.3, 0.8)),
        );
        _burst(canvas, c, extra, start: 0.18);
      case Motion.ban:
        _ban(canvas, c, scene);
      case Motion.bounce:
        final drop = Curves.bounceOut.transform(_seg(t, 0, 0.5));
        final landing = _seg(t, 0.13, 0.5);
        final squash =
            1 - 0.18 * math.sin(landing * math.pi * 3).abs() * (1 - landing);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(c.dx, c.dy + 42),
            width: 70 * drop,
            height: 10 * drop,
          ),
          Paint()..color = color.withValues(alpha: 0.25),
        );
        _emoji(
          canvas,
          scene.emoji,
          Offset(c.dx, c.dy - h * 0.7 * (1 - drop)),
          66,
          scaleY: squash,
        );
        _burst(canvas, c, extra, start: 0.45, count: 5);
      case Motion.float:
        final rise = Curves.easeOutCubic.transform(_seg(t, 0, 0.6));
        _emoji(
          canvas,
          scene.emoji,
          Offset(c.dx + math.sin(t * math.pi * 3) * 6, c.dy + 26 * (1 - rise)),
          66,
          scale: Curves.easeOutBack.transform(_seg(t, 0, 0.3)),
          angle: math.sin(t * math.pi * 2) * 0.08,
        );
        for (var i = 0; i < 5; i++) {
          final p = _seg(t, 0.12 + i * 0.1, 0.62 + i * 0.1);
          if (p <= 0 || p >= 1) continue;
          final side = i.isEven ? 1 : -1;
          _emoji(
            canvas,
            extra ?? '✨',
            Offset(
              c.dx + side * (34 + i * 4) + math.sin(p * math.pi * 2) * 8,
              c.dy + 20 - 85 * p,
            ),
            16 + i * 2,
            opacity: math.sin(p * math.pi),
          );
        }
      case Motion.wiggle:
        final shake = _seg(t, 0.15, 0.8);
        _emoji(
          canvas,
          scene.emoji,
          c,
          68,
          scale: Curves.easeOutBack.transform(_seg(t, 0, 0.2)),
          angle:
              math.sin(shake * math.pi * 14) * 0.35 * math.sin(shake * math.pi),
        );
        for (var i = 0; i < 6; i++) {
          final p = _seg(t, 0.2 + i * 0.08, 0.5 + i * 0.08);
          if (p <= 0 || p >= 1) continue;
          final side = i.isEven ? 1 : -1;
          _emoji(
            canvas,
            extra ?? '✨',
            Offset(
              c.dx + side * (30 + 40 * p),
              c.dy - 10 - 50 * p + 40 * p * p,
            ),
            16,
            opacity: 1 - p,
          );
        }
      case Motion.travel:
        // The emoji face the start of the line, so they come in from the
        // end of it.
        final move = Curves.easeOutBack.transform(_seg(t, 0, 0.5));
        final x = c.dx + (w * 0.75) * (1 - move);
        final moving = 1 - _seg(t, 0.4, 0.55);
        final hop = math.sin(_seg(t, 0.6, 0.78) * math.pi) * 14;
        for (var i = 1; i <= 3; i++) {
          final p = _seg(t, 0.05 + i * 0.05, 0.7);
          _emoji(
            canvas,
            extra ?? '💨',
            Offset(x + 30 + i * 22, c.dy + 22 - i * 3),
            18 - i * 2,
            opacity: (1 - p) * moving,
          );
        }
        _emoji(
          canvas,
          scene.emoji,
          Offset(
            x,
            c.dy - (math.sin(t * math.pi * 10).abs() * 6 * moving) - hop,
          ),
          68,
        );
        if (t > 0.6) {
          _sparkles(
            canvas,
            size,
            start: 0.6,
            count: 4,
            color: color,
            fromY: c.dy - 20,
          );
        }
      case Motion.grow:
        final ground = c.dy + 38;
        final line = Curves.easeOut.transform(_seg(t, 0, 0.2));
        canvas.drawLine(
          Offset(c.dx - 50 * line, ground),
          Offset(c.dx + 50 * line, ground),
          Paint()
            ..color = color.withValues(alpha: 0.5)
            ..strokeWidth = 5
            ..strokeCap = StrokeCap.round,
        );
        final grow = Curves.elasticOut.transform(_seg(t, 0.12, 0.6));
        canvas.save();
        canvas.translate(c.dx, ground);
        canvas.scale(0.4 + 0.6 * grow, grow);
        _emoji(canvas, scene.emoji, const Offset(0, -36), 70);
        canvas.restore();
        for (var i = 0; i < 4; i++) {
          final p = Curves.easeOutBack.transform(
            _seg(t, 0.45 + i * 0.07, 0.7 + i * 0.07),
          );
          final a = -math.pi * (0.15 + i * 0.233);
          _emoji(
            canvas,
            extra ?? '✨',
            Offset(c.dx + math.cos(a) * 58, ground - 30 + math.sin(a) * 50),
            18,
            scale: p,
          );
        }
      case Motion.rain:
        var bump = 0.0;
        for (var i = 0; i < 6; i++) {
          final s = 0.12 + i * 0.08;
          final p = _seg(t, s, s + 0.22);
          final landed = _seg(t, s + 0.22, s + 0.3);
          bump += math.sin(landed * math.pi) * 0.08;
          if (p <= 0 || p >= 1) continue;
          final x = c.dx + (i.isEven ? -1 : 1) * (6 + i * 3);
          _emoji(
            canvas,
            extra ?? '✨',
            Offset(x, c.dy - 80 + 85 * Curves.easeIn.transform(p)),
            20,
            angle: p * math.pi * (i.isEven ? 1 : -1),
          );
        }
        _emoji(
          canvas,
          scene.emoji,
          Offset(c.dx, c.dy + 20),
          64,
          scale: Curves.easeOutBack.transform(_seg(t, 0, 0.2)) + bump,
        );
        _sparkles(
          canvas,
          size,
          start: 0.7,
          count: 4,
          color: color,
          fromY: c.dy,
        );
      case Motion.orbit:
        final appear = _seg(t, 0.15, 0.35);
        final leave = 1 - _seg(t, 0.75, 0.9);
        for (var i = 0; i < 5; i++) {
          final a = t * math.pi * 2.4 * forward + i * math.pi * 2 / 5;
          _emoji(
            canvas,
            extra ?? '❤️',
            c + Offset(math.cos(a) * 58, math.sin(a) * 46),
            18,
            scale: Curves.easeOutBack.transform(appear),
            opacity: leave,
          );
        }
        _emoji(
          canvas,
          scene.emoji,
          c,
          64,
          scale:
              Curves.elasticOut.transform(_seg(t, 0, 0.4)) *
              (1 + 0.06 * math.sin(t * math.pi * 6)),
        );
      case Motion.spin:
        _emoji(
          canvas,
          scene.emoji,
          c,
          68,
          scale: Curves.elasticOut.transform(_seg(t, 0, 0.4)),
          angle:
              math.pi *
              2 *
              forward *
              Curves.easeOutCubic.transform(_seg(t, 0, 0.6)),
        );
        _burst(canvas, c, extra, start: 0.5);
      case Motion.pulse:
        double beat(double at) => math.sin(_seg(t, at, at + 0.12) * math.pi);
        final beats = [0.25, 0.48];
        for (final at in beats) {
          final p = _seg(t, at, at + 0.45);
          if (p <= 0 || p >= 1) continue;
          canvas.drawCircle(
            c,
            36 + 40 * p,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4 * (1 - p)
              ..color = color.withValues(alpha: 0.6 * (1 - p)),
          );
        }
        _emoji(
          canvas,
          scene.emoji,
          c,
          66,
          scale:
              Curves.easeOutBack.transform(_seg(t, 0, 0.22)) +
              0.18 * (beat(0.25) + beat(0.48)),
        );
        for (var i = 0; i < 3; i++) {
          final p = _seg(t, 0.3 + i * 0.12, 0.75 + i * 0.12);
          if (p <= 0 || p >= 1) continue;
          _emoji(
            canvas,
            extra ?? '✨',
            Offset(c.dx + (i - 1) * 30, c.dy - 30 - 55 * p),
            16,
            opacity: math.sin(p * math.pi),
          );
        }
    }
  }

  /// Throws [extra] (or sparkles) out from [c] in a ring.
  void _burst(
    Canvas canvas,
    Offset c,
    String? extra, {
    required double start,
    int count = 7,
  }) {
    final p = _seg(t, start, start + 0.45);
    if (p <= 0 || p >= 1) return;
    for (var i = 0; i < count; i++) {
      final a = -math.pi / 2 + i * math.pi * 2 / count;
      final d = 30 + 46 * Curves.easeOutCubic.transform(p);
      final at = c + Offset(math.cos(a) * d, math.sin(a) * d);
      if (extra == null) {
        _star(canvas, at, 6 * (1 - p) + 2, color.withValues(alpha: 1 - p));
      } else {
        _emoji(canvas, extra, at, 18, opacity: 1 - p * p);
      }
    }
  }

  /// The habit's picture appears, its [Scene.extra] puffs out of it, then a
  /// red "no" sign draws over it and a green tick says you held out.
  void _ban(Canvas canvas, Offset c, Scene scene) {
    const red = Color(0xFFE53935);
    final banned = _seg(t, 0.55, 0.68);
    final shake = math.sin(_seg(t, 0.62, 0.8) * math.pi * 6) * 5;
    final extra = scene.extra;
    if (extra != null) {
      for (var i = 0; i < 3; i++) {
        final p = _seg(t, 0.12 + i * 0.1, 0.55 + i * 0.1);
        if (p <= 0) continue;
        _emoji(
          canvas,
          extra,
          Offset(
            c.dx + 22 + math.sin(p * math.pi * 2 + i) * 8,
            c.dy - 20 - 50 * p,
          ),
          16 + 8 * p,
          opacity: math.sin(p.clamp(0.0, 1.0) * math.pi) * (1 - banned),
        );
      }
    }
    _emoji(
      canvas,
      scene.emoji,
      c + Offset(shake, 0),
      62,
      scale: Curves.easeOutBack.transform(_seg(t, 0, 0.25)),
      opacity: 1 - 0.3 * banned,
    );
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..color = red;
    const r = 52.0;
    canvas.drawArc(
      Rect.fromCircle(center: c + Offset(shake, 0), radius: r),
      -math.pi / 2,
      math.pi * 2 * Curves.easeInOut.transform(_seg(t, 0.28, 0.55)),
      false,
      ring,
    );
    if (banned > 0) {
      final from =
          c + Offset(shake, 0) + Offset.fromDirection(-math.pi * 0.75, r);
      final to = c + Offset(shake, 0) + Offset.fromDirection(math.pi * 0.25, r);
      canvas.drawLine(
        from,
        Offset.lerp(from, to, Curves.easeOut.transform(banned))!,
        ring,
      );
    }
    // A green tick: you held out.
    final tick = Curves.elasticOut.transform(_seg(t, 0.7, 0.95));
    if (tick > 0) {
      final at = c + Offset(forward * 44, 40);
      canvas.drawCircle(
        at,
        16 * tick,
        Paint()..color = const Color(0xFF2E9E5B),
      );
      final path = Path()
        ..moveTo(at.dx - 7 * tick, at.dy)
        ..lineTo(at.dx - 2 * tick, at.dy + 5 * tick)
        ..lineTo(at.dx + 7 * tick, at.dy - 5 * tick);
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = Colors.white,
      );
    }
  }

  void _sparkles(
    Canvas canvas,
    Size size, {
    required double start,
    required int count,
    required Color color,
    double? fromY,
  }) {
    final rnd = math.Random(count * 13);
    for (var i = 0; i < count; i++) {
      final s = start + i * 0.04;
      final p = _seg(t, s, s + 0.35);
      if (p <= 0 || p >= 1) continue;
      final x = size.width * (0.15 + rnd.nextDouble() * 0.7);
      final y = (fromY ?? size.height * 0.5) - 50 * p - rnd.nextDouble() * 20;
      _star(
        canvas,
        Offset(x, y),
        4 + 4 * math.sin(p * math.pi),
        color.withValues(alpha: math.sin(p * math.pi)),
      );
    }
  }

  /// A four-pointed sparkle.
  void _star(Canvas canvas, Offset c, double r, Color color) {
    final path = Path()
      ..moveTo(c.dx, c.dy - r)
      ..quadraticBezierTo(c.dx, c.dy, c.dx + r, c.dy)
      ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy + r)
      ..quadraticBezierTo(c.dx, c.dy, c.dx - r, c.dy)
      ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy - r)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _heart(Canvas canvas, Offset c, double r, Color color) {
    final path = Path()
      ..moveTo(c.dx, c.dy + r * 0.9)
      ..cubicTo(
        c.dx - r * 1.6,
        c.dy - r * 0.1,
        c.dx - r * 0.7,
        c.dy - r * 1.3,
        c.dx,
        c.dy - r * 0.45,
      )
      ..cubicTo(
        c.dx + r * 0.7,
        c.dy - r * 1.3,
        c.dx + r * 1.6,
        c.dy - r * 0.1,
        c.dx,
        c.dy + r * 0.9,
      )
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(CelebrationPainter old) =>
      old.t != t ||
      old.kind != kind ||
      old.scene != scene ||
      old.color != color;
}
