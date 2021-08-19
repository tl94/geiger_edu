import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/io_controller.dart';
import 'package:geiger_edu/controller/settings_controller.dart';
import 'package:geiger_edu/model/lessonCategoryObj.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/screens/lesson_complete_screen.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/widgets/lesson/quiz_slide.dart';
import 'package:geiger_edu/widgets/lesson/slide_container.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';

/// This class handles the business logic of a lesson.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class LessonController extends GetxController {
  SettingsController settingsController = Get.find();
  IOController ioController = Get.find();

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


  /// This method gets the current lesson.
  Lesson getCurrentLesson() {
    return currentLesson;
  }

  /// This method gets the current lesson of the user.
  Lesson? getCurrentLessonFromDB() {
    return DB.getDefaultUser()!.currentLesson;
  }

  /// This method saves the current lesson to the user.
  void saveCurrentLesson() {
    DB.saveCurrentLesson(currentLesson);
  }

  /// This method starts a lesson.
  ///
  /// @param context The build context of the parent widget
  /// @param lesson The lesson to be set as active
  Future<void> setLesson(BuildContext context, Lesson lesson) async {
    currentLesson = lesson;
    currentLessonSlideIndex(0);
    slidePaths = await ioController.getSlidePaths(context, currentLesson.path);
    slideTitles = await getSlideTitles(context);
    pageController = getLessonPageController();
    currentPageNotifier = ValueNotifier<int>(currentLessonSlideIndex.value);
    getSlides();
    isOnFirstSlide(isOnFirstPage());
    isOnLastSlide(isOnLastPage());

    saveCurrentLesson();
  }

  /// This method starts the last selected lesson.
  ///
  /// @param context The build context of the parent widget
  Future<bool> continueLesson(BuildContext context) async {
    var currentLessonFromDB = getCurrentLessonFromDB();
    var currentLessonIsNull = currentLessonFromDB == null;
    if (!currentLessonIsNull) {
      currentLesson = currentLessonFromDB!;
      currentLessonSlideIndex(currentLesson.lastIndex);
      slidePaths =
          await ioController.getSlidePaths(context, currentLesson.path);
      slideTitles = await getSlideTitles(context);
      pageController = getLessonPageController();
      currentPageNotifier = ValueNotifier<int>(currentLessonSlideIndex.value);
      print(currentPageNotifier.toString());
      getSlides();
      isOnFirstSlide(isOnFirstPage());
      isOnLastSlide(isOnLastPage());
    }
    return currentLessonIsNull;
  }

  ///** LessonContainer functions **///

  /// This method gets the corresponding slides of a lesson.
  List<Widget> getSlides() {
    List<Widget> newSlides = [];
    for (var sp in slidePaths) {
      SlideContainer slide = SlideContainer(
        slidePath: sp,
      );
      newSlides.add(slide);
    }
    if (currentLesson.hasQuiz) {
      newSlides.add(QuizSlide());
    }
    slides = newSlides;
    print(slides.length);
    return slides;
  }

  /// This method gets the title of a lesson.
  String getLessonTitle(BuildContext context) {
    return currentLesson.title[settingsController.language]!;
  }

  /// This method gets the subtitle of a slide.
  ///
  /// @param context The build context of the parent widget
  /// @param slidePath The path of the slide
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

  /// This method gets the subtitle of a slide.
  ///
  /// @param context The build context of the parent widget
  Future<List<String>> getSlideTitles(BuildContext context) async {
    List<String> newSlideTitles = [];
    newSlideTitles.add(getLessonTitle(context));
    for (int i = 1; i < slidePaths.length; i++) {
      newSlideTitles.add(await getSlideTitle(context, slidePaths[i]));
    }
    if (currentLesson.hasQuiz) newSlideTitles.add("Quiz");
    currentTitle.value = newSlideTitles[currentLessonSlideIndex.value];
    slideTitles = newSlideTitles;
    return slideTitles;
  }

  /// This method gets the page controller of the current slide.
  PageController getLessonPageController() {
    return PageController(initialPage: currentLessonSlideIndex.value);
  }

  /// This method checks if the slide is the first slide.
  bool isOnFirstPage() {
    return currentLessonSlideIndex.value == 0;
  }

  /// This method checks if the slide is the last slide.
  bool isOnLastPage() {
    return currentLessonSlideIndex.value + 1 == slides.length;
  }

  /// This method updates the navigation buttons.
  void updateNavigatorButtons() {
    isOnFirstSlide(isOnFirstPage());
    isOnLastSlide(isOnLastPage());
  }

  /// This method updates the values on slide change.
  ///
  /// @param page The index of the current page
  Future<VoidCallback?> onSlideChanged(int page) async {
    currentLessonSlideIndex.value = page;
    currentLesson.lastIndex = page;
    currentPageNotifier.value = page;
    currentTitle(slideTitles[page]);
    saveCurrentLesson();
    updateNavigatorButtons();
  }

  /// This method navigates to the previous page.
  void previousPage() async {
    if (!isOnFirstSlide.value) {
      await pageController.previousPage(duration: _kDuration, curve: _kCurve);
    }
  }

  /// This method navigates to the next page.
  void nextPage() async {
    if (!isOnLastSlide.value) {
      await pageController.nextPage(duration: _kDuration, curve: _kCurve);
    } else {
      if (!currentLesson.hasQuiz) {
        setLessonCompleted();
        Get.to(() => LessonCompleteScreen());
      }
    }
  }

  /// This method sets the current lesson completed.
  void setLessonCompleted() {
    currentLesson.lastIndex = 0;
    if (!currentLesson.completed) {
      currentLesson.completed = true;
      DB.getLessonBox().put(currentLesson.lessonId, currentLesson);
      incrementCompletedLessons();
      updateIndicator();
    }
    saveCurrentLesson();
  }

  ///** GEIGER INDICATOR ** ///
  int completedLessons = 0;
  int maxLessons = 0;
  var completedLessonPercentage = 0.0.obs;
  var label = ''.obs;

  /// This method counts the overall lessons available, the completed ones and
  /// sets them accordingly.
  void setLessonNumbers() {
    completedLessons = DB.getLessonBox().values.where((lesson) => lesson.completed).length;
    maxLessons = DB.getLessonBox().values.length;
  }

  /// HELPER METHODS ///

  /// This method gets the completed lessons.
  int getCompletedLessons() {
    return completedLessons;
  }

  /// This method gets the maximum number of lessons.
  int getNumberOfLessons() {
    return maxLessons;
  }

  /// This method increments the completed lessons.
  void incrementCompletedLessons() {
    completedLessons++;
  }

  /// This method updates the GEIGER indicator values.
  void updateIndicator() {
    completedLessonPercentage(completedLessons == 0 ? 0 : (completedLessons / maxLessons));
    if (completedLessonPercentage.value < 0.25 && completedLessonPercentage.value >= 0) label('IndicatorLow'.tr);
    if (completedLessonPercentage.value < 0.5 && completedLessonPercentage.value > 0.25) label('IndicatorMedium'.tr);
    if (completedLessonPercentage.value < 0.75 && completedLessonPercentage.value > 0.5) label('IndicatorGood'.tr);
    if (completedLessonPercentage.value <= 1 && completedLessonPercentage.value > 0.75) label('IndicatorExcellent'.tr);
  }
}