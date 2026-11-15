import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Light falling-confetti celebration.
class Confetti extends StatefulWidget {
  const Confetti({super.key});

  @override
  State<Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) => CustomPaint(
          painter: _ConfettiPainter(_c.value),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.t);

  final double t;

  static const List<Color> _colors = [
    Color(0xFF69C9FF),
    Color(0xFFA98BFF),
    Color(0xFFFFD85E),
    Color(0xFFFF91B5),
    Color(0xFF75DDB4),
    Color(0xFFFFAA65),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(3);
    for (var i = 0; i < 45; i++) {
      final x0 = rnd.nextDouble() * size.width;
      final speed = 0.5 + rnd.nextDouble();
      final phase = rnd.nextDouble();
      final y = (((t * speed) + phase) % 1.0) * (size.height + 40) - 20;
      final x = x0 + math.sin((t * 6) + i) * 14;
      final paint = Paint()..color = _colors[i % _colors.length];
      if (i.isEven) {
        canvas.drawCircle(Offset(x, y), 5, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset(x, y), width: 10, height: 6),
              const Radius.circular(2)),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => old.t != t;
}
