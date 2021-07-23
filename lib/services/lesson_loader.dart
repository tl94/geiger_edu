import 'dart:convert';

import 'package:flutter/material.dart';

class LessonLoader {

  static void doEverything(BuildContext context) async {
    print("DO EVERYTHING!");
    var lessonCategoryMetaFiles = await getAssetFiles(context, "category_meta.json");
    print(lessonCategoryMetaFiles.length);
    for (var s in lessonCategoryMetaFiles) {
      print(s);
    }

    var lessonMetaFiles = await getAssetFiles(context, "lesson_meta.json");
    print(lessonMetaFiles.length);
    for (var s in lessonMetaFiles) {
      print(s);
    }

    /*var htmlFiles = await getAssetFiles(context, ".html");
    for (var s in lessonMetaFiles) {
      print(s);
    }*/
  }

  static Future<void> loadLessons(BuildContext context) async {
    var lessonMetaFiles = await getAssetFiles(context, "lesson_meta.json");
    for (var path in lessonMetaFiles) {
      var file = await DefaultAssetBundle.of(context).loadString(path);
      var lessonData = await json.decode(file);
      print(lessonData['lessonId']);
      print(lessonData['lessonName']['eng']);
      print(lessonData['lessonName']['ger']);
      print(lessonData['motivation']['eng']);
      print(lessonData['motivation']['ger']);

    }
  }

  static Future<void> loadLessonCategories(BuildContext context) async {
    var lessonCategoryMetaFiles = await getAssetFiles(context, "category_meta.json");

  }

  static Future<List<String>> getAssetFiles(BuildContext context, String filename) async {
    var manifestContent = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    Map<String, dynamic> manifestMap = json.decode(manifestContent);
/*    for (var k in manifestMap.keys) {
      print(k);
    }*/
    String regExStr = r'.*' + filename;
    // print(regExStr);
    RegExp regExp = RegExp(regExStr);
    var metafiles = manifestMap.keys
        .where((String key) => regExp.hasMatch(key))
        .toList();
    // print(regExp.pattern);
    return metafiles;
  }

  static void test() async {
    String filename = "category_meta.json";
    String s = "sfsefefef/fniebqiueifuqi/category_meta.json";
    RegExp regExp = RegExp(r'.*category_meta.json');
    RegExp regExp2 = RegExp(r'.*' + filename);
    print(regExp.hasMatch(s));
    print(regExp2.hasMatch(s));

  }


}
