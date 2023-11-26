import 'package:dart_math_parser/lexeme.dart';

class LexemeBuffer {
  int pos = 0;
  List<Lexeme> lexemes;

  LexemeBuffer(this.lexemes);

  Lexeme next() {
    return lexemes[pos++];
  }

  void back() {
    pos--;
  }

  int getPos() {
    return pos;
  }
}