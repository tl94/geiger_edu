import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/screens/lesson_complete_screen.dart';
import 'package:geiger_edu/widgets/lesson/SlideContainer.dart';
import 'package:geiger_edu/widgets/lesson/quiz_slide.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:page_view_indicators/step_page_indicator.dart';

class LessonContainer extends StatefulWidget {
  final LessonController lessonController = Get.find();

  final Lesson lesson;
  final List<String> slidePaths;
  final int initialPage;

  LessonContainer(
      {required this.lesson, required this.slidePaths, this.initialPage = 0})
      : super();

  _LessonContainerState createState() =>
      _LessonContainerState();
}

class _LessonContainerState extends State<LessonContainer> {
  late final PageController _pageController;
  late final ValueNotifier<int> _currentPageNotifier;
  static const _buttonColor = Color.fromRGBO(0, 0, 0, 0.2);

  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.ease;

  _LessonContainerState();

  @override
  initState() {
    super.initState();
    _currentPageNotifier = ValueNotifier<int>(widget.lessonController.currentLessonSlideIndex);
    _pageController = PageController(initialPage: widget.lessonController.currentLessonSlideIndex);
  }

 /* List<Widget> _getSlides() {
    List<String> slidePaths = widget.slidePaths;
    List<Widget> slides = [];
    for (var sp in slidePaths) {
      SlideContainer slide = new SlideContainer(
        slidePath: sp,
        title: 'dddd',
      );
      slides.add(slide);
    }
    if (widget.lesson.hasQuiz) {
      slides.add(QuizSlide(lesson: widget.lesson));
    }
    _slides = slides;
    return _slides;
  }*/


/*  Future<String> _getLessonTitle(BuildContext context) async {
    var firstSlidePath = widget.slidePaths.first;
    var doc =
        parse(await DefaultAssetBundle.of(context).loadString(firstSlidePath));
    var elems = doc.getElementsByTagName("meta");
    var title;
    for (var e in elems) {
      var content = e.attributes["content"];
      if (content != null) title = content;
    }
    return title;
  }*/

/*  Future<String> _getSlideTitle(String slidePath) async {
    var doc = parse(await DefaultAssetBundle.of(context).loadString(slidePath));
    var elems = doc.getElementsByTagName("title");
    var title;
    for (var e in elems) {
      var content = e.innerHtml;
      title = content;
    }
    return title;
  }*/

/*  Future<List<String>> _getSlideTitles() async {
    List<String> slideTitles = [];
    var slidePaths = widget.slidePaths;
    slideTitles.add(await _getLessonTitle(context));
    for (int i = 1; i < slidePaths.length; i++) {
      slideTitles.add(await _getSlideTitle(slidePaths[i]));
    }
    slideTitles.add("Quiz");
    setState(() {
      _slideTitles = slideTitles;
      _title = slideTitles[0];
    });
    return slideTitles;
  }*/

  Future<VoidCallback?> _onSlideChanged(int page) async {
    _currentPageNotifier.value = page;
    widget.lessonController.currentTitle(widget.lessonController.slideTitles[page]);
  }

  bool _isOnFirstPage() {
    return _currentPageNotifier.value == 0;
  }

  bool _isOnLastPage() {
    return _currentPageNotifier.value + 1 == widget.lessonController.slides.length;
  }

  void _previousPage() async {
    _currentPageNotifier.value--;
    await _pageController.previousPage(duration: _kDuration, curve: _kCurve);
  }

  void _nextPage() async {
    // TODO: don't allow this if the lesson has a quiz
    if (_isOnLastPage() && !widget.lessonController.currentLesson.hasQuiz) {
      Navigator.pushNamed(context, LessonCompleteScreen.routeName);
    }
    _currentPageNotifier.value++;
    await _pageController.nextPage(duration: _kDuration, curve: _kCurve);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Obx (() => Text(widget.lessonController.currentTitle.value))),
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
              if (!_isOnFirstPage())
                Align(
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
                            )))),
              if (!_isOnLastPage())
                Align(
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
                            )))),
            ],
          ))
        ])));
  }
}
