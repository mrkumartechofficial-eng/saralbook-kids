import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/question.dart';

const List<Color> _palette = [
  Color(0xFF42A5F5),
  Color(0xFFFFB300),
  Color(0xFFEC407A),
  Color(0xFF26A69A),
  Color(0xFFFF7043),
  Color(0xFF7E57C2),
];

/// Draws one of the 8 shapes in code (no image files needed).
class ShapeView extends StatelessWidget {
  const ShapeView({super.key, required this.kind, this.color, this.size = 80});

  final ShapeKind kind;
  final int? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = color != null ? Color(color!) : _palette[kind.index % _palette.length];
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _ShapePainter(kind, c)),
    );
  }
}

class _ShapePainter extends CustomPainter {
  _ShapePainter(this.kind, this.color);

  final ShapeKind kind;
  final Color color;

  Path _path(double w, double h) {
    final p = Path();
    switch (kind) {
      case ShapeKind.circle:
        p.addOval(Rect.fromLTWH(w * .05, h * .05, w * .9, h * .9));
      case ShapeKind.square:
        p.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(w * .12, h * .12, w * .76, h * .76),
            Radius.circular(w * .06)));
      case ShapeKind.rectangle:
        p.addRRect(RRect.fromRectAndRadius(
            Rect.fromLTWH(w * .04, h * .2, w * .92, h * .6),
            Radius.circular(w * .05)));
      case ShapeKind.oval:
        p.addOval(Rect.fromLTWH(w * .03, h * .2, w * .94, h * .6));
      case ShapeKind.triangle:
        p
          ..moveTo(w * .5, h * .08)
          ..lineTo(w * .94, h * .88)
          ..lineTo(w * .06, h * .88)
          ..close();
      case ShapeKind.diamond:
        p
          ..moveTo(w * .5, h * .04)
          ..lineTo(w * .92, h * .5)
          ..lineTo(w * .5, h * .96)
          ..lineTo(w * .08, h * .5)
          ..close();
      case ShapeKind.star:
        final cx = w / 2;
        final cy = h * .54;
        final outer = w * .48;
        final inner = outer * .45;
        for (var i = 0; i < 10; i++) {
          final rad = i.isEven ? outer : inner;
          final ang = -math.pi / 2 + i * math.pi / 5;
          final x = cx + rad * math.cos(ang);
          final y = cy + rad * math.sin(ang);
          if (i == 0) {
            p.moveTo(x, y);
          } else {
            p.lineTo(x, y);
          }
        }
        p.close();
      case ShapeKind.heart:
        p
          ..moveTo(w * .5, h * .88)
          ..cubicTo(w * -.02, h * .55, w * .08, h * .08, w * .5, h * .30)
          ..cubicTo(w * .92, h * .08, w * 1.02, h * .55, w * .5, h * .88)
          ..close();
    }
    return p;
  }

  @override
  void paint(Canvas canvas, Size s) {
    final path = _path(s.width, s.height);
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.black26,
    );
  }

  @override
  bool shouldRepaint(covariant _ShapePainter old) =>
      old.kind != kind || old.color != color;
}
