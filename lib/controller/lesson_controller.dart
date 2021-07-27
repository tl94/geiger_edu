import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/settings_controller.dart';
import 'package:geiger_edu/model/difficultyObj.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/model/quiz/question.dart';
import 'package:get/get.dart';

import 'global_controller.dart';

class LessonController extends GetxController {

  SettingsController settingsController = Get.put(SettingsController());

  //** LESSON SELECTION **
  List<Lesson> lessons = [];

  //** GEIGER INDICATOR **
  int completedLessons = 0;
  int maxLessons = 0;

  //** LESSON STATE **
  int currentLessonSlideIndex = 0;

  String categoryTitle = '';

  Lesson currentLesson = Lesson(
      lessonId: "LPW001",
      lessonCategoryId: '',
      title: {"eng": "Password Safety", "ger": "Passwortsicherheit"},
      completed: true,
      recommended: false,
      lastIndex: 0,
      maxIndex: 5,
      motivation: {
        "eng": "Improve your password security!",
        "ger": "Verbessere deine Passwortsicherheit!"
      },
      difficulty: Difficulty.beginner,
      duration: 5,
      apiUrl: '',
      path: 'assets/lesson/password/password_safety/',
      hasQuiz: true);

  List<String> slidePaths = [];

//** QUIZ STATE **
  List<Question> answeredQuestions = [];

  ///
  Future<List<String>> getSlidePaths(BuildContext context) async {
    List<String> filePaths = await getLessonSlidePaths(context, currentLesson.path);
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

  Future<List<String>> getDirectoryFilePaths(
      BuildContext context, RegExp regExp) async {
    var manifestContent =
    await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    Map<String, dynamic> manifestMap = json.decode(manifestContent);
    var filePaths =
    manifestMap.keys.where((String key) => regExp.hasMatch(key)).toList();
    return filePaths;
  }

  Future<int> getNumberOfLessonSlides(
      BuildContext context, String lessonPath) async {
    var slidePaths = await getLessonSlidePaths(context, lessonPath);
    return slidePaths.length;
  }
}