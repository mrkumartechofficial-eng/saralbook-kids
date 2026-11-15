import 'bi.dart';

enum ShapeKind { circle, square, triangle, rectangle, star, heart, oval, diamond }

/// Something to show: an emoji picture, a drawn shape, a colour swatch, or text.
/// [color] is an ARGB int such as 0xFFE53935.
class Visual {
  const Visual({this.emoji, this.text, this.shape, this.color});

  final String? emoji;
  final Bi? text;
  final ShapeKind? shape;
  final int? color;

  String get key =>
      '${emoji ?? ''}|${text?.en ?? ''}|${shape?.name ?? ''}|${color ?? 0}';
}

/// One answer button.
class Choice {
  const Choice({this.visual, this.label});

  final Visual? visual;
  final Bi? label;

  String get key => '${visual?.key ?? ''}#${label?.en ?? ''}';
}

/// One question. Everything is stored in both languages (Bi), so switching
/// language during a question just re-draws it.
class Question {
  const Question({
    required this.instruction,
    this.stage,
    this.stageSeq,
    required this.choices,
    required this.answer,
    required this.hint,
    required this.speak,
  });

  final Bi instruction;
  final Visual? stage;
  final List<Visual>? stageSeq;
  final List<Choice> choices;
  final int answer;
  final Bi hint;
  final Bi speak;

  String get signature =>
      '${instruction.en}|${stage?.key ?? ''}|${stageSeq?.map((v) => v.key).join(',') ?? ''}|${choices[answer].key}';
}
