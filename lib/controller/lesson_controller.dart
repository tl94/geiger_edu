import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/settings_controller.dart';
import 'package:geiger_edu/model/lessonCategoryObj.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/model/quiz/question.dart';
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:geiger_edu/screens/lesson_complete_screen.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/controller/io_controller.dart';
import 'package:geiger_edu/widgets/lesson/slide_container.dart';
import 'package:geiger_edu/widgets/lesson/quiz_results_group.dart';
import 'package:geiger_edu/widgets/lesson/quiz_slide.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';

class LessonController extends GetxController {
  SettingsController settingsController = Get.find();
  IOController ioController = Get.find();

  //** LESSON SELECTION **
 /* String categoryTitle = '';
  List<Lesson> lessons = [];
*/
  //** GEIGER INDICATOR **
  int completedLessons = 0;
  int maxLessons = 0;

  //** LESSON CATEGORIES **
  late List<LessonCategory> lessonCategories;

  //** LESSON STATE **


  late Lesson currentLesson;

  // LessonContainer State
  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.ease;

  late PageController pageController;
  late ValueNotifier<int> currentPageNotifier;
  RxInt currentLessonSlideIndex = 0.obs;
  List<String> slidePaths = [];
  List<Widget> slides = [];
  RxString currentTitle = ''.obs;
  List<String> slideTitles = [];
  RxBool isOnFirstSlide = false.obs;
  RxBool isOnLastSlide = false.obs;

  //** Functions **



  Lesson getLesson() {
    return currentLesson;
  }

  Future<void> setLesson(BuildContext context, Lesson lesson) async {
    print("SET LESSON CALLED");
    currentLesson = lesson;
    currentLessonSlideIndex(0);
    slidePaths = await ioController.getSlidePaths(context, lesson.path);
    slideTitles = await getSlideTitles(context);
    pageController = getLessonPageController();
    currentPageNotifier = ValueNotifier<int>(currentLessonSlideIndex.value);
    getSlides();
    isOnFirstSlide(isOnFirstPage());
    isOnLastSlide(isOnLastPage());
  }

  //TODO: Load currentLesson from DB
  void continueLesson(BuildContext context) {
    print("CONTINUE LESSON CALLED");
    // currentLesson = lesson;
    // // currentLessonSlideIndex(0);
    // slidePaths = await ioController.getSlidePaths(context, lesson.path);
    // slideTitles = await getSlideTitles(context);
    pageController = getLessonPageController();
    currentPageNotifier = ValueNotifier<int>(currentLessonSlideIndex.value);
    // getSlides();
    isOnFirstSlide(isOnFirstPage());
    isOnLastSlide(isOnLastPage());
  }



  //** LESSON CONTAINER **
  List<Widget> getSlides() {
    List<Widget> newSlides = [];
    for (var sp in slidePaths) {
      SlideContainer slide = SlideContainer(
        slidePath: sp,
      );
      newSlides.add(slide);
    }
    print("HASQUIZ: " + currentLesson.hasQuiz.toString());
    if (currentLesson.hasQuiz) {
      newSlides.add(QuizSlide());
    }
    slides = newSlides;
    print(slides.length);
    return slides;
  }

  String getLessonTitle (BuildContext context) {
    return currentLesson.title[settingsController.language]!;
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
    newslideTitles.add(getLessonTitle(context));
    for (int i = 1; i < slidePaths.length; i++) {
      newslideTitles.add(await getSlideTitle(context, slidePaths[i]));
    }
    if (currentLesson.hasQuiz) newslideTitles.add("Quiz");
    currentTitle.value = newslideTitles[0];
    slideTitles = newslideTitles;
    return slideTitles;
  }

  PageController getLessonPageController() {
    print("CURRENT SLIDE: " + currentLessonSlideIndex.toString());
    return PageController(initialPage: currentLessonSlideIndex.value);
  }

  bool isOnFirstPage() {
    return currentLessonSlideIndex.value == 0;
  }

  bool isOnLastPage() {
    return currentLessonSlideIndex.value + 1 == slides.length;
  }

  void updateNavigatorButtons() {
    isOnFirstSlide(isOnFirstPage());
    isOnLastSlide(isOnLastPage());
  }

  Future<VoidCallback?> onSlideChanged(int page) async {
    currentPageNotifier.value = page;
    currentLessonSlideIndex.value = page;
    currentTitle(slideTitles[page]);
    updateNavigatorButtons();
  }

  void previousPage() async {
    currentLessonSlideIndex--;
    currentPageNotifier.value--;
    await pageController.previousPage(duration: _kDuration, curve: _kCurve);
  }

  void nextPage() async {
    // TODO: don't allow this if the lesson has a quiz
    currentPageNotifier.value++;
    currentLessonSlideIndex++;
    if (isOnLastSlide.value && !currentLesson.hasQuiz) {
      setLessonCompleted();
      Get.to(() => LessonCompleteScreen());
      // Navigator.pushNamed(context, LessonCompleteScreen.routeName);
    } else {
      await pageController.nextPage(duration: _kDuration, curve: _kCurve);
    }
  }

  void setLessonCompleted() {
    if (!currentLesson.completed) {
      currentLesson.completed = true;
      DB.getLessonBox().put(currentLesson.lessonId, currentLesson);
      incrementCompletedLessons();
    }
  }

  //** LESSON NUMBERS **
  void getLessonNumbers() {
    completedLessons =
        DB.getLessonBox().values.where((lesson) => lesson.completed).length;
    maxLessons = DB.getLessonBox().values.length;
  }

  int getCompletedLessons() {
    return completedLessons;
  }

  int getNumberOfLessons() {
    return maxLessons;
  }

  void incrementCompletedLessons() {
    completedLessons++;
  }
}
