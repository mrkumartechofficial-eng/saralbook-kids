import '../models/question.dart';

/// Every generated question must pass this before a child ever sees it.
class QuestionValidator {
  static bool isValid(Question q) {
    if (q.choices.length < 2 || q.choices.length > 6) return false;
    if (q.answer < 0 || q.answer >= q.choices.length) return false;
    final keys = q.choices.map((c) => c.key).toSet();
    if (keys.length != q.choices.length) return false; // no duplicate options
    for (final c in q.choices) {
      final hasVisual = c.visual != null;
      final hasLabel = c.label != null && c.label!.en.isNotEmpty;
      if (!hasVisual && !hasLabel) return false;
    }
    return true;
  }
}
