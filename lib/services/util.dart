import 'package:flutter_svg/parser.dart';

class Util {

  static void checkSvg(String svgString) {
    final SvgParser parser = SvgParser();
    try {
      parser.parse(svgString, warningsAsErrors: true);
      print('SVG is supported');
    } catch (e) {
      print('SVG contains unsupported features');
    }
  }
}