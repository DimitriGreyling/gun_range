import 'dart:math' as math;

import 'package:flutter/material.dart';

class RadarBackground extends StatefulWidget {
  const RadarBackground({
    super.key,
    this.backgroundColor = const Color(0xFF02110D),
    this.gridColor = const Color(0xFF18D39B),
    this.sweepColor = const Color(0xFF34F5B5),
    this.dotCount = 28,
    this.sweepWidthRadians = 0.45,
    this.speed = const Duration(milliseconds: 2400),
    this.blur = 0.0,
  });

  final Color backgroundColor;
  final Color gridColor;
  final Color sweepColor;
  final int dotCount;
  final double sweepWidthRadians;
  final Duration speed;

  /// Optional backdrop blur. Keep at 0 for best performance.
  final double blur;

  @override
  State<RadarBackground> createState() => _RadarBackgroundState();
}

class _RadarBackgroundState extends State<RadarBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Offset> _dotFractions;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.speed)
      ..repeat();

    final r = math.Random(42);
    _dotFractions = List.generate(widget.dotCount, (_) {
      // Cluster dots mostly within the radar circle area.
      final angle = r.nextDouble() * 2 * math.pi;
      final radius = math.sqrt(r.nextDouble()) * 0.46; // 0..0.46 of min size
      final dx = 0.5 + math.cos(angle) * radius;
      final dy = 0.5 + math.sin(angle) * radius;
      return Offset(dx.clamp(0.0, 1.0), dy.clamp(0.0, 1.0));
    });
  }

  @override
  void didUpdateWidget(covariant RadarBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.speed != widget.speed) {
      _controller
        ..duration = widget.speed
        ..repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _RadarPainter(
              t: _controller.value,
              dotFractions: _dotFractions,
              backgroundColor: widget.backgroundColor,
              gridColor: widget.gridColor,
              sweepColor: widget.sweepColor,
              sweepWidthRadians: widget.sweepWidthRadians,
            ),
          );
        },
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({
    required this.t,
    required this.dotFractions,
    required this.backgroundColor,
    required this.gridColor,
    required this.sweepColor,
    required this.sweepWidthRadians,
  });

  final double t;
  final List<Offset> dotFractions;
  final Color backgroundColor;
  final Color gridColor;
  final Color sweepColor;
  final double sweepWidthRadians;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final center = size.center(Offset.zero);
    final minSide = math.min(size.width, size.height);
    final radius = minSide * 0.55;

    // Base fill
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = backgroundColor,
    );

    // Soft vignette / glow
    final glowRect = Rect.fromCircle(center: center, radius: radius * 1.15);
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          gridColor.withOpacity(0.10),
          backgroundColor.withOpacity(0.0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(glowRect);
    canvas.drawRect(Offset.zero & size, glowPaint);

    // Radar circle clip
    final circlePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));

    // Grid lines + rings
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = gridColor.withOpacity(0.22)
      ..strokeWidth = 1.0;

    for (final f in const [0.25, 0.5, 0.75, 1.0]) {
      canvas.drawCircle(center, radius * f, ringPaint);
    }

    final axisPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = gridColor.withOpacity(0.18)
      ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      axisPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      axisPaint,
    );

    // A few diagonal spokes
    for (final a in const [math.pi / 4, 3 * math.pi / 4]) {
      final dx = math.cos(a) * radius;
      final dy = math.sin(a) * radius;
      canvas.drawLine(
        Offset(center.dx - dx, center.dy - dy),
        Offset(center.dx + dx, center.dy + dy),
        axisPaint,
      );
    }

    // Sweep
    final sweepAngle = t * 2 * math.pi;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(sweepAngle);
    canvas.translate(-center.dx, -center.dy);

    final sweepRect = Rect.fromCircle(center: center, radius: radius);
    final sweepPaint = Paint()
      ..blendMode = BlendMode.plus
      ..shader = SweepGradient(
        startAngle: 0.0,
        endAngle: 2 * math.pi,
        colors: [
          sweepColor.withOpacity(0.0),
          sweepColor.withOpacity(0.30),
          sweepColor.withOpacity(0.0),
        ],
        stops: [
          0.0,
          (sweepWidthRadians / (2 * math.pi)).clamp(0.0, 1.0),
          ((sweepWidthRadians * 2) / (2 * math.pi)).clamp(0.0, 1.0),
        ],
      ).createShader(sweepRect);

    canvas.drawCircle(center, radius, sweepPaint);
    canvas.restore();

    // Faint scanline shimmer (subtle pulsing circle)
    final pulse = 0.10 + 0.05 * math.sin(t * 2 * math.pi);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = sweepColor.withOpacity(pulse),
    );

    // Dots (blips)
    canvas.save();
    canvas.clipPath(circlePath);

    for (final frac in dotFractions) {
      final p = Offset(frac.dx * size.width, frac.dy * size.height);

      final vx = p.dx - center.dx;
      final vy = p.dy - center.dy;
      final dotAngle = math.atan2(vy, vx);

      // Angular distance to sweep head (normalize to 0..pi)
      final delta = _smallestAngleBetween(dotAngle, sweepAngle);
      final hit = (1.0 - (delta / sweepWidthRadians)).clamp(0.0, 1.0);
      final intensity = math.pow(hit, 2).toDouble();

      const baseOpacity = 0.10;
      final boostOpacity = 0.55 * intensity;

      final r = 1.4 + 2.8 * intensity;

      final dotPaint = Paint()
        ..color = sweepColor.withOpacity(baseOpacity + boostOpacity)
        ..blendMode = BlendMode.plus;

      canvas.drawCircle(p, r, dotPaint);
    }

    canvas.restore();

    // Outer edge
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = gridColor.withOpacity(0.35),
    );
  }

  double _smallestAngleBetween(double a, double b) {
    final diff = (a - b).abs();
    const twoPi = 2 * math.pi;
    final wrapped = diff % twoPi;
    return math.min(wrapped, twoPi - wrapped);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return oldDelegate.t != t ||
        oldDelegate.dotFractions != dotFractions ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.gridColor != gridColor ||
        oldDelegate.sweepColor != sweepColor ||
        oldDelegate.sweepWidthRadians != sweepWidthRadians;
  }
}
