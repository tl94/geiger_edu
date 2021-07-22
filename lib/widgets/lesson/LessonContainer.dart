import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui.dart';
import 'package:geiger_edu/widgets/lesson/SlideContainer.dart';
import 'package:geiger_edu/screens/lesson_complete_screen.dart';
import 'package:html/parser.dart';

class LessonContainer extends StatefulWidget {
  final String lessonPath;
  final List<String> slidePaths;
  final int initialPage;

  LessonContainer({required this.lessonPath, required this.slidePaths, this.initialPage = 0}) : super();

  _LessonContainerState createState() => _LessonContainerState(initialPage: initialPage);
}

class _LessonContainerState extends State<LessonContainer> {
  var _title = "";
  var _slideIndex = 0;
  List<Widget> _slides = [];
  List<String> _slideTitles = [];
  late final _pageController;
  static const _buttonColor = Color.fromRGBO(0, 0, 0, 0.2);

  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  final int initialPage;
  _LessonContainerState({this.initialPage = 0});

  @override
  initState() {
    super.initState();
    _pageController = new PageController(
        initialPage: initialPage
    );
    _getSlideTitles();
    _getSlides();
  }

  List<Widget> _getSlides() {
    List<String> slidePaths = widget.slidePaths;
    List<Widget> slides = [];
    for (var sp in slidePaths) {
      SlideContainer slide = new SlideContainer(slidePath: sp, title: 'dddd',);
      slides.add(slide);
    }
    slides.add(new LessonCompleteSlide(lessonPath: widget.lessonPath));
    setState(() {
      _slides = slides;
    });
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
    var title = _slideTitles[page];
    setState(() {
      _title = title;
    });
  }

  void _previousPage() async {
    await _pageController.previousPage(duration: _kDuration, curve: _kCurve);
  }

  void _nextPage() async {
    await _pageController.nextPage(duration: _kDuration, curve: _kCurve);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: _slides,
            onPageChanged: _onSlideChanged,
            allowImplicitScrolling: true,
          ),
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
                      ))))
        ],
      ),
    );
  }
}
