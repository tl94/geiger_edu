import 'dart:convert';

import 'package:flutter/cupertino.dart';
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

  static Future<List<String>> getDirectoryFilePaths(
      BuildContext context, RegExp regExp) async {
    var manifestContent =
    await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    Map<String, dynamic> manifestMap = json.decode(manifestContent);
    var filePaths =
    manifestMap.keys.where((String key) => regExp.hasMatch(key)).toList();
    return filePaths;
  }

  static String getDirectoryFromFilePath(String filePath, String fileName) {
    String directory = filePath.replaceFirst(RegExp(fileName), '');
    return directory;
  }
}