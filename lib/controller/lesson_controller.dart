import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/settings_controller.dart';
import 'package:geiger_edu/model/lessonCategoryObj.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/model/quiz/question.dart';
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:geiger_edu/screens/lesson_complete_screen.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/widgets/lesson/SlideContainer.dart';
import 'package:geiger_edu/widgets/lesson/quiz_results_group.dart';
import 'package:geiger_edu/widgets/lesson/quiz_slide.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';

class LessonController extends GetxController {
  SettingsController settingsController = Get.find();

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

  //** Quiz State **
  List<Question> answeredQuestions = [];

  //** LessonCompleteScreen State **
  final String icon1 = "assets/img/congratulations_icon.svg";
  final String icon2 = "assets/img/trophy_icon.svg";

  DateTime? selectedDate;

  //** Functions **



  Lesson getLesson() {
    return currentLesson;
  }

  Future<void> setLesson(BuildContext context, Lesson lesson) async {
    print("SET LESSON CALLED");
    currentLesson = lesson;
    currentLessonSlideIndex.value = 0;
    isOnFirstSlide.value = isOnFirstPage();
    isOnLastSlide.value = isOnLastPage();
    await getSlidePaths(context);
    await getSlideTitles(context);
    pageController = getLessonPageController();
    currentPageNotifier = ValueNotifier<int>(currentLessonSlideIndex.value);
    getSlides();
  }

  ///
  Future<List<String>> getSlidePaths(BuildContext context) async {
    List<String> filePaths =
        await getLessonSlidePaths(context, currentLesson.path);
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
      Get.to(LessonCompleteScreen());
      // Navigator.pushNamed(context, LessonCompleteScreen.routeName);
    }
    await pageController.nextPage(duration: _kDuration, curve: _kCurve);
  }

  //** LESSON COMPLETE SCREEN **
  void onFinishLessonPressed() {
    Get.to(() => HomeScreen());
  }

  List<Widget> getQuizResultsGroups() {
    List<Widget> quizResultsGroups = [];
    // TODO: don't do this step if lesson has no quiz
    for (var question in answeredQuestions) {
      quizResultsGroups.add(QuizResultsGroup(answeredQuestion: question));
    }
    return quizResultsGroups;
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.utc(2100, 12, 31));
    if (selectedDate != null) {
      selectedDate = newSelectedDate;
    }
  }

  //** LESSON NUMBERS **
  void calculateCompletedLessons() {
    maxLessons = DB.getLessonBox().values.length;
    completedLessons =
        DB.getLessonBox().values.where((lesson) => lesson.completed).length;
  }

  void incrementGeigerIndicator() {
    completedLessons++;
  }
}
