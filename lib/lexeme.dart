enum LexemeType {
  leftBracket,
  rightBracket,
  opPlus,
  opMinus,
  opMultiply,
  opDivide,
  number,
  eof;
}

class Lexeme {
  late LexemeType type;
  late String value;

  Lexeme(this.type, this.value);

  @override
  String toString() {
    return 'Lexeme{type: $type, value: $value}';
  }
}