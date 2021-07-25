import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geiger_edu/globals.dart' as globals;
import 'package:geiger_edu/model/lessonCategoryObj.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/model/difficultyObj.dart';
import 'package:geiger_edu/services/util.dart';

class LessonLoader {
  static void loadLessonData(BuildContext context) async {
    // print("loading lesson data");

    await loadLessons(context);
    await loadLessonCategories(context);
    /*var lessonCategoryMetaFiles =
        await getAssetFiles(context, "lesson_category_meta.json");
    print(lessonCategoryMetaFiles.length);
    for (var s in lessonCategoryMetaFiles) {
      print(s);
    }

    var lessonMetaFiles = await getAssetFiles(context, "lesson_meta.json");
    print(lessonMetaFiles.length);
    for (var s in lessonMetaFiles) {
      print(s);
    }*/

    /*var htmlFiles = await getAssetFiles(context, ".html");
    for (var s in lessonMetaFiles) {
      print(s);
    }*/
  }

  /* loads lessons from lesson_meta.json files
  *  recommended is set to false by default
  *  lastIndex is set to 0 by default */
  static Future<void> loadLessons(BuildContext context) async {
    var lessonMetaFiles = await getAssetFiles(context, "lesson_meta.json");
    for (var path in lessonMetaFiles) {
      var file = await DefaultAssetBundle.of(context).loadString(path);
      var jsonData = await json.decode(file);

      var lessonId = jsonData['lessonId'];
      var lessonCategoryId = jsonData['lessonCategoryId'];
      var title = Map<String, String>.from(jsonData['title']);

      var motivation = Map<String, String>.from(jsonData['motivation']);
      var duration = jsonData['duration'];
      var difficulty = Difficulty.values[jsonData['difficulty']];

      var directoryPath = Util.getDirectoryFromFilePath(path, 'lesson_meta.json');

      var maxIndex = await getNumberOfLessonSlides(context, directoryPath);
      var hasQuiz = jsonData['hasQuiz'];

      var apiUrl = 'unknown';
/*

      print(lessonId);
      print(lessonCategoryId);
      print(title);
      print(motivation);
      print(duration);
      print(difficulty);
      print(directoryPath);
      print(maxIndex);
      print(hasQuiz);
      print(apiUrl);
*/

      Lesson lesson = Lesson(
          lessonId: lessonId,
          lessonCategoryId: lessonCategoryId,
          title: title,
          motivation: motivation,
          duration: duration,
          difficulty: difficulty,
          maxIndex: maxIndex,
          hasQuiz: hasQuiz,
          path: directoryPath,
          apiUrl: apiUrl);
      DB.getLessonBox().put(lesson.lessonId, lesson);
    }
  }

  static String getLocalizedLessonPath(String lessonPath) {
    return lessonPath + globals.language + '/';
  }

  static Future<List<String>> getLessonSlidePaths(BuildContext context, String lessonPath) async {
    lessonPath = getLocalizedLessonPath(lessonPath);
    RegExp regExp = RegExp(lessonPath + "slide_\*");
    List<String> filePaths = await Util.getDirectoryFilePaths(context, regExp);
    return filePaths;
  }

  static Future<List<String>> getQuizPath(BuildContext context, String lessonPath) async {
    lessonPath = getLocalizedLessonPath(lessonPath);
    RegExp regExp = RegExp(lessonPath + "quiz\*");
    List<String> filePaths = await Util.getDirectoryFilePaths(context, regExp);
    return filePaths;
  }

  static Future<int> getNumberOfLessonSlides(
      BuildContext context, String lessonPath) async {
    var slidePaths = await getLessonSlidePaths(context, lessonPath);
    return slidePaths.length;
  }

  /* loads lesson categories from lesson_category_meta.json files */
  static Future<void> loadLessonCategories(BuildContext context) async {
    var lessonCategoryMetaFiles =
        await getAssetFiles(context, "lesson_category_meta.json");
    for (var path in lessonCategoryMetaFiles) {
      var file = await DefaultAssetBundle.of(context).loadString(path);
      var jsonData = await json.decode(file);
      var lessonCategoryId = jsonData['lessonCategoryId'];
      var title = Map<String, String>.from(jsonData['title']);
      var directoryPath = Util.getDirectoryFromFilePath(path, 'lesson_category_meta.json');
      LessonCategory lc = LessonCategory(
          lessonCategoryId: lessonCategoryId,
          title: title,
          path: directoryPath);
      DB.getLessonCategoryBox().put(lc.lessonCategoryId, lc);
    }
  }

  static Future<List<String>> getAssetFiles(
      BuildContext context, String filename) async {
    var manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    Map<String, dynamic> manifestMap = json.decode(manifestContent);
/*    for (var k in manifestMap.keys) {
      print(k);
    }*/
    String regExStr = r'.*' + filename;
    // print(regExStr);
    RegExp regExp = RegExp(regExStr);
    var metafiles =
        manifestMap.keys.where((String key) => regExp.hasMatch(key)).toList();
    // print(regExp.pattern);
    return metafiles;
  }

  static void test() async {
    String filename = "lesson_category_meta.json";
    String s = "sfsefefef/fniebqiueifuqi/lesson_category_meta.json";
    RegExp regExp = RegExp(r'.*lesson_category_meta.json');
    RegExp regExp2 = RegExp(r'.*' + filename);
    print(regExp.hasMatch(s));
    print(regExp2.hasMatch(s));
  }
}
