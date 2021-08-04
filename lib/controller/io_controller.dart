import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:geiger_edu/controller/settings_controller.dart';
import 'package:geiger_edu/model/difficultyObj.dart';
import 'package:geiger_edu/model/lessonCategoryObj.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:get/get.dart';

import '../services/db.dart';

class IOController extends GetxController {

  SettingsController settingsController = Get.find();

  void loadLessonData(BuildContext context) async {
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
  Future<void> loadLessons(BuildContext context) async {
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

      var directoryPath = getDirectoryFromFilePath(path, 'lesson_meta.json');

      var maxIndex = await getNumberOfLessonSlides(context, directoryPath);
      var hasQuiz = jsonData['hasQuiz'];

      var apiUrl = 'unknown';

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
      if (!isLessonPresent(lesson)) {
        DB.getLessonBox().put(lesson.lessonId, lesson);
      }
    }
  }

  bool isLessonPresent(Lesson lesson) {
    return DB.getLessonBox().containsKey(lesson.lessonId);
  }

  /* loads lesson categories from lesson_category_meta.json files */
  Future<void> loadLessonCategories(BuildContext context) async {
    var lessonCategoryMetaFiles =
    await getAssetFiles(context, "lesson_category_meta.json");
    for (var path in lessonCategoryMetaFiles) {
      var file = await DefaultAssetBundle.of(context).loadString(path);
      var jsonData = await json.decode(file);
      var lessonCategoryId = jsonData['lessonCategoryId'];
      var title = Map<String, String>.from(jsonData['title']);
      var directoryPath = getDirectoryFromFilePath(path, 'lesson_category_meta.json');
      LessonCategory lc = LessonCategory(
          lessonCategoryId: lessonCategoryId,
          title: title,
          path: directoryPath);
      DB.getLessonCategoryBox().put(lc.lessonCategoryId, lc);
    }
  }

  Future<List<String>> getDirectoryFilePaths(
      BuildContext context, RegExp regExp) async {
    var manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    Map<String, dynamic> manifestMap = json.decode(manifestContent);
    var filePaths =
        manifestMap.keys.where((String key) => regExp.hasMatch(key)).toList();
    return filePaths;
  }

  Future<List<String>> getAssetFiles(
      BuildContext context, String filename) async {
    var manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    Map<String, dynamic> manifestMap = json.decode(manifestContent);
    String regExStr = r'.*' + filename;
    RegExp regExp = RegExp(regExStr);
    var files =
        manifestMap.keys.where((String key) => regExp.hasMatch(key)).toList();
    return files;
  }

  String getDirectoryFromFilePath(String filePath, String fileName) {
    String directory = filePath.replaceFirst(RegExp(fileName), '');
    return directory;
  }

  ///
  Future<List<String>> getSlidePaths(
      BuildContext context, String lessonPath) async {
    List<String> filePaths = await getLessonSlidePaths(context, lessonPath);
    return filePaths;
  }

  Future<List<String>> getLessonSlidePaths(
      BuildContext context, String lessonPath) async {
    lessonPath = getLocalizedLessonPath(lessonPath);
    RegExp regExp = RegExp(lessonPath + "slide_\*");
    List<String> filePaths = await getDirectoryFilePaths(context, regExp);
    return filePaths;
  }

  String getLocalizedLessonPath(String lessonPath) {
    return lessonPath + settingsController.language + '/';
  }

  Future<int> getNumberOfLessonSlides(
      BuildContext context, String lessonPath) async {
    var slidePaths = await getLessonSlidePaths(context, lessonPath);
    return slidePaths.length;
  }
}