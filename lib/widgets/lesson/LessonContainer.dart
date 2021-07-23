import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui.dart';
import 'package:geiger_edu/screens/lesson_complete_screen.dart';
import 'package:geiger_edu/widgets/lesson/SlideContainer.dart';
import 'package:geiger_edu/widgets/lesson/quiz_slide.dart';
import 'package:html/parser.dart';
import 'package:page_view_indicators/step_page_indicator.dart';

class LessonContainer extends StatefulWidget {
  final String lessonPath;
  final List<String> slidePaths;
  final int initialPage;

  LessonContainer(
      {required this.lessonPath,
      required this.slidePaths,
      this.initialPage = 0})
      : super();

  _LessonContainerState createState() =>
      _LessonContainerState(initialPage: initialPage);
}

class _LessonContainerState extends State<LessonContainer> {
  var _title = "";
  var _slideIndex = 0;
  List<Widget> _slides = [];
  List<String> _slideTitles = [];
  late final PageController _pageController;
  late final ValueNotifier<int> _currentPageNotifier;
  static const _buttonColor = Color.fromRGBO(0, 0, 0, 0.2);

  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  final int initialPage;

  _LessonContainerState({this.initialPage = 0});

  @override
  initState() {
    super.initState();
    _slideIndex = initialPage;
    _currentPageNotifier = ValueNotifier<int>(initialPage);
    _pageController = PageController(initialPage: initialPage);
    _getSlideTitles();
    _getSlides();
  }

  List<Widget> _getSlides() {
    List<String> slidePaths = widget.slidePaths;
    List<Widget> slides = [];
    for (var sp in slidePaths) {
      SlideContainer slide = new SlideContainer(
        slidePath: sp,
        title: 'dddd',
      );
      slides.add(slide);
    }
    slides.add(QuizSlide(lessonPath: widget.lessonPath));
    _slides = slides;
    return _slides;
  }

  String _getCurrentSlidePath() {
    var pageNumber = _slideIndex;
    var currentSlide = widget.slidePaths[pageNumber];
    return currentSlide;
  }

  Future<String> _getLessonTitle(BuildContext context) async {
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
  }

  Future<String> _getSlideTitle(String slidePath) async {
    var doc = parse(await DefaultAssetBundle.of(context).loadString(slidePath));
    var elems = doc.getElementsByTagName("title");
    var title;
    for (var e in elems) {
      var content = e.innerHtml;
      title = content;
    }
    return title;
  }

  Future<List<String>> _getSlideTitles() async {
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
  }

  Future<VoidCallback?> _onSlideChanged(int page) async {
    _currentPageNotifier.value = page;
    var title = _slideTitles[page];
    setState(() {
      _title = title;
    });
  }

  bool _isOnFirstPage() {
    return _currentPageNotifier.value == 0;
  }

  bool _isOnLastPage() {
    return _currentPageNotifier.value + 1 == _slides.length;
  }

  void _previousPage() async {
    _currentPageNotifier.value--;
    await _pageController.previousPage(duration: _kDuration, curve: _kCurve);
  }

  void _nextPage() async {
    // TODO: don't allow this if the lesson has a quiz
    if (_isOnLastPage()) {
      Navigator.pushNamed(context, LessonCompleteScreen.routeName);
    }
    _currentPageNotifier.value++;
    await _pageController.nextPage(duration: _kDuration, curve: _kCurve);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: Container(
            child: Column(children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: StepPageIndicator(
                      itemCount: _slides.length,
                      currentPageNotifier: _currentPageNotifier,
                      size: 16,
                      onPageSelected: (int index) {
                          _pageController.jumpToPage(index);
                      },
                    ),
                  )
              )
            ],
          )
              ,
          Expanded(
              child: Stack(
            children: [
                PageView(
                  controller: _pageController,
                  children: _slides,
                  onPageChanged: _onSlideChanged,
                  allowImplicitScrolling: true,
                )
              ,
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
