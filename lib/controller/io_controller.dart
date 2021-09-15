import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:geiger_edu/controller/settings_controller.dart';
import 'package:geiger_edu/model/difficultyObj.dart';
import 'package:geiger_edu/model/lessonCategoryObj.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:get/get.dart';

import '../services/db.dart';

/// This class handles general io operations e.g. for lessons or other assets.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class IOController extends GetxController {
  SettingsController settingsController = Get.find();

  /// This method loads all lesson data from assets.
  ///
  /// @param context BuildContext of parent Widget
  void loadLessonData(BuildContext context) async {
    await loadLessons(context);
    await loadLessonCategories(context);
  }

  /// This method loads lessons from assets.
  /// recommended is set to false by default, lastIndex is set to 0 by default.
  ///
  /// @param context BuildContext of parent Widget
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

  /// This method checks if a lesson is present in database.
  ///
  /// @param lesson Lesson to be evaluated
  bool isLessonPresent(Lesson lesson) {
    return DB.getLessonBox().containsKey(lesson.lessonId);
  }

  /// This method loads lesson categories from lesson_category_meta.json files.
  ///
  /// @param context BuildContext of parent Widget
  Future<void> loadLessonCategories(BuildContext context) async {
    var lessonCategoryMetaFiles =
        await getAssetFiles(context, "lesson_category_meta.json");
    for (var path in lessonCategoryMetaFiles) {
      var file = await DefaultAssetBundle.of(context).loadString(path);
      var jsonData = await json.decode(file);
      var lessonCategoryId = jsonData['lessonCategoryId'];
      var title = Map<String, String>.from(jsonData['title']);
      var directoryPath =
          getDirectoryFromFilePath(path, 'lesson_category_meta.json');
      LessonCategory lc = LessonCategory(
          lessonCategoryId: lessonCategoryId,
          title: title,
          path: directoryPath);
      DB.getLessonCategoryBox().put(lc.lessonCategoryId, lc);
    }
  }

  /// This method returns assets file paths for a given directory regex.
  ///
  /// @param context BuildContext of parent Widget
  /// @param regExp RegularExpression to be utilised
  Future<List<String>> getDirectoryFilePaths(
      BuildContext context, RegExp regExp) async {
    var manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    Map<String, dynamic> manifestMap = json.decode(manifestContent);
    var filePaths =
        manifestMap.keys.where((String key) => regExp.hasMatch(key)).toList();
    return filePaths;
  }

  /// This method returns a list of asset file paths for given filename.
  ///
  /// @param context BuildContext of parent Widget
  /// @param filename Name of the asset file
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

  /// This method returns directory path from full file path.
  ///
  /// @param filePath Whole file path
  /// @param fileName Name of the file in question
  String getDirectoryFromFilePath(String filePath, String fileName) {
    String directory = filePath.replaceFirst(RegExp(fileName), '');
    return directory;
  }

  /// This method returns paths for slides of a lesson.
  ///
  /// @param context BuildContext of parent Widget
  /// @param lessonPath Path of the lesson
  Future<List<String>> getSlidePaths(
      BuildContext context, String lessonPath) async {
    List<String> filePaths = await getLessonSlidePaths(context, lessonPath);
    return filePaths;
  }

  /// This method returns paths for slides of a lesson.
  ///
  /// @param context BuildContext of parent Widget
  /// @param lessonPath Path of the lesson
  Future<List<String>> getLessonSlidePaths(
      BuildContext context, String lessonPath) async {
    lessonPath = getLocalizedLessonPath(lessonPath);
    RegExp regExp = RegExp(lessonPath + "slide_\*");
    List<String> filePaths = await getDirectoryFilePaths(context, regExp);
    return filePaths;
  }

  /// This method returns the path for lesson with correct language.
  ///
  /// @param lessonPath Path of the lesson
  String getLocalizedLessonPath(String lessonPath) {
    return lessonPath + settingsController.language + '/';
  }

  /// This method returns number of slides in a lesson.
  ///
  /// @param context BuildContext of parent Widget
  /// @param lessonPath Path of the lesson
  Future<int> getNumberOfLessonSlides(
      BuildContext context, String lessonPath) async {
    var slidePaths = await getLessonSlidePaths(context, lessonPath);
    return slidePaths.length;
  }

  /// This method deletes a file from disk.
  ///
  /// @param file File to be deleted
  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Error in getting access to the file.
    }
  }
}
