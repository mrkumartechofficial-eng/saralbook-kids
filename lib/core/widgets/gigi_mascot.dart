import 'package:flutter/material.dart';

/// GIGI - the friendly baby owl mascot, drawn in code (original artwork).
class GigiMascot extends StatefulWidget {
  const GigiMascot({super.key, this.size = 120, this.animate = true});

  final double size;
  final bool animate;

  @override
  State<GigiMascot> createState() => _GigiMascotState();
}

class _GigiMascotState extends State<GigiMascot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, -8 * Curves.easeInOut.transform(_controller.value)),
        child: child,
      ),
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(painter: _GigiPainter()),
      ),
    );
  }
}

class _GigiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width;
    final h = s.height;
    final body = Paint()..color = const Color(0xFFA98BFF);
    final wing = Paint()..color = const Color(0xFF8D6BEF);
    final belly = Paint()..color = const Color(0xFFFFF9ED);
    final white = Paint()..color = Colors.white;
    final dark = Paint()..color = const Color(0xFF3B2A63);
    final orange = Paint()..color = const Color(0xFFFFAA65);
    final cheek = Paint()..color = const Color(0x99FF91B5);

    // Ear tufts
    final left = Path()
      ..moveTo(w * .16, h * .24)
      ..lineTo(w * .10, h * .02)
      ..lineTo(w * .38, h * .13)
      ..close();
    final right = Path()
      ..moveTo(w * .84, h * .24)
      ..lineTo(w * .90, h * .02)
      ..lineTo(w * .62, h * .13)
      ..close();
    canvas.drawPath(left, body);
    canvas.drawPath(right, body);

    // Feet
    canvas.drawOval(Rect.fromLTWH(w * .28, h * .92, w * .17, h * .07), orange);
    canvas.drawOval(Rect.fromLTWH(w * .55, h * .92, w * .17, h * .07), orange);

    // Body and belly
    canvas.drawOval(Rect.fromLTWH(w * .08, h * .08, w * .84, h * .86), body);
    canvas.drawOval(Rect.fromLTWH(w * .26, h * .52, w * .48, h * .40), belly);

    // Wings
    canvas.drawOval(Rect.fromLTWH(0, h * .46, w * .22, h * .36), wing);
    canvas.drawOval(Rect.fromLTWH(w * .78, h * .46, w * .22, h * .36), wing);

    // Eyes
    for (final dx in [.32, .68]) {
      canvas.drawCircle(Offset(w * dx, h * .38), w * .16, white);
      canvas.drawCircle(Offset(w * dx + w * .01, h * .39), w * .08, dark);
      canvas.drawCircle(Offset(w * dx + w * .035, h * .36), w * .025, white);
    }

    // Cheeks
    canvas.drawCircle(Offset(w * .2, h * .53), w * .05, cheek);
    canvas.drawCircle(Offset(w * .8, h * .53), w * .05, cheek);

    // Beak
    final beak = Path()
      ..moveTo(w * .44, h * .47)
      ..lineTo(w * .56, h * .47)
      ..lineTo(w * .5, h * .59)
      ..close();
    canvas.drawPath(beak, orange);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
