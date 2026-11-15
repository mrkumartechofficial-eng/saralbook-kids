import 'package:flutter/material.dart';

import '../../models/question.dart';
import '../theme/app_theme.dart';
import 'shape_view.dart';

/// Draws a [Visual]: a shape, colour swatch, emoji picture and/or big text.
class VisualView extends StatelessWidget {
  const VisualView(this.v, {super.key, this.size = 80, required this.lang});

  final Visual v;
  final double size;
  final String lang;

  Widget _emoji(String emoji) {
    if (emoji.contains(' ')) {
      final parts = emoji.split(' ').where((s) => s.isNotEmpty).toList();
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: size * 3.2),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 4,
          runSpacing: 2,
          children: [
            for (final s in parts)
              Text(s, style: TextStyle(fontSize: size * 0.38)),
          ],
        ),
      );
    }
    return Text(emoji, style: TextStyle(fontSize: size * 0.8));
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    if (v.shape != null) {
      children.add(ShapeView(kind: v.shape!, color: v.color, size: size));
    } else if (v.color != null) {
      children.add(Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Color(v.color!),
          borderRadius: BorderRadius.circular(size * .22),
          border: Border.all(color: Colors.black26, width: 2),
        ),
      ));
    }
    if (v.emoji != null) children.add(_emoji(v.emoji!));
    if (v.text != null) {
      final hasOther = children.isNotEmpty;
      if (hasOther) children.add(const SizedBox(height: 4));
      children.add(ConstrainedBox(
        constraints: BoxConstraints(maxWidth: size * 3.2),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            v.text!.of(lang),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: hasOther ? size * 0.32 : size * 0.6,
              fontWeight: FontWeight.w900,
              color: AppColors.ink,
            ),
          ),
        ),
      ));
    }
    return Column(mainAxisSize: MainAxisSize.min, children: children);
  }
}
