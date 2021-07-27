import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/settings_controller.dart';
import 'package:geiger_edu/model/difficultyObj.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/model/quiz/question.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/widgets/lesson/SlideContainer.dart';
import 'package:geiger_edu/widgets/lesson/quiz_slide.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';

import 'global_controller.dart';

class LessonController extends GetxController {

  SettingsController settingsController = Get.put(SettingsController());

  //** LESSON SELECTION **
  List<Lesson> lessons = [];

  //** GEIGER INDICATOR **
  int completedLessons = 0;
  int maxLessons = 0;

  //** LESSON STATE **
  RxInt currentLessonSlideIndex = 0.obs;

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

  List<Widget> slides = [];
  RxString currentTitle = ''.obs;
  int currentSlideIndex = 0;
  List<String> slideTitles = [];
  RxBool isOnFirstSlide = false.obs;
  RxBool isOnLastSlide = false.obs;

  Lesson getLesson() {
    return currentLesson;
  }

  Future<void> setLesson(BuildContext context, Lesson lesson) async {
    currentLesson = lesson;
    currentLessonSlideIndex.value = 0;
    isOnFirstSlide.value = isOnFirstPage();
    isOnLastSlide.value = isOnLastPage();
    await getSlidePaths(context);
    await getSlideTitles(context);
    getSlides();
  }

  List<Lesson> getLessons() {
    return lessons;
  }

  void setLessons(List<Lesson> lessons) {
    this.lessons = lessons;
  }

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
    slidePaths = filePaths;
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

  //** LESSON CONTAINER **
  List<Widget> getSlides() {
    List<Widget> newSlides = [];
    for (var sp in slidePaths) {
      SlideContainer slide = new SlideContainer(
        slidePath: sp,
        title: 'dddd',
      );
      newSlides.add(slide);
    }
    print("HASQUIZ: " + currentLesson.hasQuiz.toString());
    if (currentLesson.hasQuiz) {
      newSlides.add(QuizSlide(lesson: currentLesson));
    }
    print(slides.length);
    slides = newSlides;
    return slides;
  }

/*  String _getCurrentSlidePath() {
    var pageNumber = slideIndex;
    var currentSlide = slidePaths[pageNumber];
    return currentSlide;
  }*/

  Future<String> getLessonTitle(BuildContext context) async {
    var firstSlidePath = slidePaths.first;
    var doc =
    parse(await DefaultAssetBundle.of(context).loadString(firstSlidePath));
    var elems = doc.getElementsByTagName("meta");
    var title;
    for (var e in elems) {
      var content = e.attributes["content"];
      if (content != null) title = content;
    }
    return title;
  }

  Future<String> getSlideTitle(BuildContext context, String slidePath) async {
    var doc = parse(await DefaultAssetBundle.of(context).loadString(slidePath));
    var elems = doc.getElementsByTagName("title");
    var title;
    for (var e in elems) {
      var content = e.innerHtml;
      title = content;
    }
    return title;
  }

  Future<List<String>> getSlideTitles(BuildContext context) async {
    List<String> newslideTitles = [];
    newslideTitles.add(await getLessonTitle(context));
    for (int i = 1; i < slidePaths.length; i++) {
      newslideTitles.add(await getSlideTitle(context, slidePaths[i]));
    }
    newslideTitles.add("Quiz");
    currentTitle.value = newslideTitles[0];
    slideTitles = newslideTitles;
    return slideTitles;
  }

  PageController getLessonPageController() {
    print(currentLessonSlideIndex.value);
    return PageController(initialPage: currentLessonSlideIndex.value);
  }

  bool isOnFirstPage() {
    return currentLessonSlideIndex.value == 0;
  }

  bool isOnLastPage() {
    return currentLessonSlideIndex.value + 1 == slides.length;
  }

  void updateNavigatorButtons() {
    isOnFirstSlide.value = isOnFirstPage();
    isOnLastSlide.value = isOnLastPage();
  }



//** QUIZ STATE **
  List<Question> answeredQuestions = [];





  //** LESSON NUMBERS **
  void runGeigerIndicator(){
    var tempCompletedLessons = 0;
    var tempMaxLessons = DB.getLessonBox().values.length;

    for(var lesson in DB.getLessonBox().values){
      if (lesson.completed) {
        tempCompletedLessons++;
      }
    }
    maxLessons = tempMaxLessons;
    completedLessons = tempCompletedLessons;
  }

  void incrementGeigerIndicator(){
    completedLessons++;
  }
}