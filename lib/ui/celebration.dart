import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/category.dart';
import '../models/family.dart';
import '../models/habit_library.dart';
import 'look.dart';

/// The little animation that plays when a habit is checked off.
enum Celebration { water, sleep, reading, sport, family, confetti }

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

/// Picks the animation from what the habit is about: its words first, then
/// its category, then whether the whole family shares it.
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
  if (category == BuiltInCategory.sleep || has(_sleepWords)) {
    return Celebration.sleep;
  }
  if (category == BuiltInCategory.study || has(_readingWords)) {
    return Celebration.reading;
  }
  if (category == BuiltInCategory.sport ||
      category == BuiltInCategory.outdoor ||
      has(_sportWords)) {
    return Celebration.sport;
  }
  if (habit.isFamily) return Celebration.family;
  return Celebration.confetti;
}

/// Plays [kind] in a floating bubble over the screen, then removes it. Taps
/// pass through, and nothing plays when the phone asks for reduced motion.
void celebrate(BuildContext context, Celebration kind, String caption) {
  if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return;
  final overlay = Overlay.maybeOf(context);
  if (overlay == null) return;
  HapticFeedback.mediumImpact();
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _CelebrationOverlay(
      kind: kind,
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
    required this.caption,
    required this.look,
    required this.onDone,
  });

  final Celebration kind;
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
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          // Pop in over the first 18%, fade out over the last 15%.
          final scaleIn = Curves.elasticOut.transform(
            (t / 0.3).clamp(0.0, 1.0),
          );
          final fade =
              1 - Curves.easeIn.transform(((t - 0.85) / 0.15).clamp(0.0, 1.0));
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
    );
  }
}

Color celebrationColor(Celebration kind, Look look) => switch (kind) {
  Celebration.water => const Color(0xFF2F9BFF),
  Celebration.sleep => const Color(0xFF6C5CE7),
  Celebration.reading => const Color(0xFFF2994A),
  Celebration.sport => const Color(0xFFF2B01E),
  Celebration.family => const Color(0xFFF2547D),
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
  });

  final Celebration kind;
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
    switch (kind) {
      case Celebration.water:
        _water(canvas, size);
      case Celebration.sleep:
        _sleep(canvas, size);
      case Celebration.reading:
        _reading(canvas, size);
      case Celebration.sport:
        _sport(canvas, size);
      case Celebration.family:
        _family(canvas, size);
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
      old.t != t || old.kind != kind || old.color != color;
}
