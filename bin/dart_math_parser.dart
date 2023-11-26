import 'package:dart_math_parser/parser.dart';

void main(List<String> arguments) {
  print(Parser("10*5+4/2-1").execute());
  print(Parser("(x*3-5)/5", {"x": 10}).execute());
  print(Parser("3*x+15/(3+2)", {"x": 10}).execute());
}
