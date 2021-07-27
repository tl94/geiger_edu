import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/screens/lesson_complete_screen.dart';
import 'package:get/get.dart';
import 'package:page_view_indicators/step_page_indicator.dart';

class LessonContainer extends StatefulWidget {
  final LessonController lessonController = Get.find();

  final Lesson lesson;
  final List<String> slidePaths;
  final int initialPage;

  LessonContainer(
      {required this.lesson, required this.slidePaths, this.initialPage = 0})
      : super();

  _LessonContainerState createState() => _LessonContainerState();
}

class _LessonContainerState extends State<LessonContainer> {
  late final PageController _pageController;
  late final ValueNotifier<int> _currentPageNotifier;
  static const _buttonColor = Color.fromRGBO(0, 0, 0, 0.2);

  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.ease;

  @override
  initState() {
    super.initState();
    _currentPageNotifier = ValueNotifier<int>(
        widget.lessonController.currentLessonSlideIndex.value);
    _pageController = widget.lessonController.getLessonPageController();
  }

  Future<VoidCallback?> _onSlideChanged(int page) async {
    _currentPageNotifier.value = page;
    widget.lessonController.currentLessonSlideIndex.value = page;
    widget.lessonController
        .currentTitle(widget.lessonController.slideTitles[page]);
    widget.lessonController.updateNavigatorButtons();
  }

  void _previousPage() async {
    widget.lessonController.currentLessonSlideIndex--;
    _currentPageNotifier.value--;
    await _pageController.previousPage(duration: _kDuration, curve: _kCurve);
  }

  void _nextPage() async {
    // TODO: don't allow this if the lesson has a quiz
    _currentPageNotifier.value++;
    widget.lessonController.currentLessonSlideIndex++;
    if (widget.lessonController.isOnLastSlide.value &&
        !widget.lessonController.currentLesson.hasQuiz) {
      Navigator.pushNamed(context, LessonCompleteScreen.routeName);
    }
    await _pageController.nextPage(duration: _kDuration, curve: _kCurve);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Obx(() => Text(widget.lessonController.currentTitle.value))),
        body: Container(
            child: Column(children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: StepPageIndicator(
                  itemCount: widget.lessonController.slides.length,
                  currentPageNotifier: _currentPageNotifier,
                  size: 16,
                  onPageSelected: (int index) {
                    _pageController.jumpToPage(index);
                  },
                ),
              ))
            ],
          ),
          Expanded(
              child: Stack(
            children: [
              PageView(
                controller: _pageController,
                children: widget.lessonController.slides,
                onPageChanged: _onSlideChanged,
                allowImplicitScrolling: true,
              ),
              Obx(() {
                if (!widget.lessonController.isOnFirstSlide.value) {
                  return Align(
                      alignment: Alignment.centerLeft,
                      child: Material(
                          color: Colors.transparent,
                          child: Ink(
                              decoration: const ShapeDecoration(
                                color: _buttonColor,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.chevron_left),
                                onPressed: () => _previousPage(),
                              ))));
                } else
                  return SizedBox.shrink();
              }),
              Obx(() {
                if (!widget.lessonController.isOnLastSlide.value) {
                  return Align(
                      alignment: Alignment.centerRight,
                      child: Material(
                          color: Colors.transparent,
                          child: Ink(
                              decoration: const ShapeDecoration(
                                color: _buttonColor,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.chevron_right),
                                onPressed: () => _nextPage(),
                              ))));
                } else return SizedBox.shrink();
              }),
            ],
          ))
        ])));
  }
}
