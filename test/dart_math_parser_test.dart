import 'package:dart_math_parser/parser.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(Parser("10*5+4/2-1").execute(), 51);
    expect(Parser("(x*3-5)/5", {"x": 10}).execute(), 5);
    expect(Parser("3*x+15/(3+2)", {"x": 10}).execute(), 33);
  });
}
