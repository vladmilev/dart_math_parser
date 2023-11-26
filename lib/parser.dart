import 'package:dart_math_parser/lexeme.dart';
import 'package:dart_math_parser/lexeme_buffer.dart';

class Parser {
  String _expressionText;
  final Map<String, int>? _variables;

  Parser(this._expressionText, [this._variables]);

  @override
  String toString() {
    return 'Parser{expressionText: $_expressionText, variables: $_variables}';
  }

  int execute() {
    _variables?.forEach((key, value) {
      _expressionText = _expressionText.replaceAll(key, value.toString());
    });

    List<Lexeme> lexemes = lexAnalyze(_expressionText);
    LexemeBuffer lexemeBuffer = LexemeBuffer(lexemes);
    return expr(lexemeBuffer);
  }

  List<Lexeme> lexAnalyze(String expText) {
    List<Lexeme> lexemes = [];

    int pos = 0;
    while (pos < expText.length) {
      String c = expText[pos];
      switch (c) {
        case '(':
          lexemes.add(Lexeme(LexemeType.leftBracket, c));
          pos++;
          continue;
        case ')':
          lexemes.add(Lexeme(LexemeType.rightBracket, c));
          pos++;
          continue;
        case '+':
          lexemes.add(Lexeme(LexemeType.opPlus, c));
          pos++;
          continue;
        case '-':
          lexemes.add(Lexeme(LexemeType.opMinus, c));
          pos++;
          continue;
        case '*':
          lexemes.add(Lexeme(LexemeType.opMultiply, c));
          pos++;
          continue;
        case '/':
          lexemes.add(Lexeme(LexemeType.opDivide, c));
          pos++;
          continue;
        default:
          if (null != int.tryParse(c)) {
            String sb = '';
            do {
              sb += c;
              pos++;
              if (pos >= expText.length) {
                break;
              }
              c = expText[pos];
            } while (null != int.tryParse(c));
            lexemes.add(Lexeme(LexemeType.number, sb));
          } else {
            if (c != ' ') {
              throw Exception("Unexpected character: $c");
            }
            pos++;
          }
      }
    }
    lexemes.add(Lexeme(LexemeType.eof, ""));
    return lexemes;
  }

  int expr(LexemeBuffer lexemes) {
    Lexeme lexeme = lexemes.next();
    if (lexeme.type == LexemeType.eof) {
      return 0;
    } else {
      lexemes.back();
      return plusminus(lexemes);
    }
  }

  int plusminus(LexemeBuffer lexemes) {
    int value = multdiv(lexemes);
    while (true) {
      Lexeme lexeme = lexemes.next();
      switch (lexeme.type) {
        case LexemeType.opPlus:
          value += multdiv(lexemes);
          break;
        case LexemeType.opMinus:
          value -= multdiv(lexemes);
          break;
        case LexemeType.eof:
        case LexemeType.rightBracket:
          lexemes.back();
          return value;
        default:
          throw Exception(
              "Unexpected token: ${lexeme.value.toString()}  at position: ${lexemes.getPos().toString()}");
      }
    }
  }

  int multdiv(LexemeBuffer lexemes) {
    int value = factor(lexemes);
    while (true) {
      Lexeme lexeme = lexemes.next();
      switch (lexeme.type) {
        case LexemeType.opMultiply:
          value *= factor(lexemes);
          break;
        case LexemeType.opDivide:
          int factorLexemes = factor(lexemes);
          value = (0 == factorLexemes) ? 0 : value ~/ factorLexemes;
          break;
        case LexemeType.eof:
        case LexemeType.rightBracket:
        case LexemeType.opPlus:
        case LexemeType.opMinus:
          lexemes.back();
          return value;
        default:
          throw Exception(
              "Unexpected token: ${lexeme.value}  at position: ${lexemes.getPos().toString()}");
      }
    }
  }

  int factor(LexemeBuffer lexemes) {
    Lexeme lexeme = lexemes.next();
    switch (lexeme.type) {
      case LexemeType.number:
        return int.parse(lexeme.value);
      case LexemeType.leftBracket:
        int value = plusminus(lexemes);
        lexeme = lexemes.next();
        if (lexeme.type != LexemeType.rightBracket) {
          throw Exception(
              "Unexpected token: ${lexeme.value} at position: ${lexemes.getPos().toString()}");
        }
        return value;
      default:
        throw Exception(
            "Unexpected token: ${lexeme.value.toString()} at position: ${lexemes.getPos().toString()}");
    }
  }
}