/// A text in both languages. Content is stored as Bi so the language can be
/// switched at any moment (even in the middle of a question).
class Bi {
  const Bi(this.en, this.hi);
  const Bi.same(String s)
      : en = s,
        hi = s;

  final String en;
  final String hi;

  String of(String code) => code == 'hi' ? hi : en;
}
