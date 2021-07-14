import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/shims/dart_ui.dart';
import 'package:geiger_edu/widgets/SlideContainer.dart';

import 'package:html/parser.dart';

class LessonContainer extends StatefulWidget {
  final List<String> slidePaths;

  LessonContainer({required this.slidePaths}) : super();

  _LessonContainerState createState() => _LessonContainerState();
}

class _LessonContainerState extends State<LessonContainer> {
  var _title = "";
  var _slideIndex = 0;
  List<Widget> _slides = [];
  final _pageController = new PageController();
  static const _buttonColor = Color.fromRGBO(0, 0, 0, 0.2);

  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  @override
  initState() {
    super.initState();
    _getSlides();
    _getLessonTitle(context);
  }

  List<Widget> _getSlides() {
    List<String> slidePaths = widget.slidePaths;
    List<Widget> slides = [];
    for (var sp in slidePaths) {
      SlideContainer slide = new SlideContainer(slidePath: sp);
      slides.add(slide);
    }
    setState(() {
      _slides = slides;
    });
    return _slides;
  }

  String _getCurrentSlidePath() {
    var pageNumber = _slideIndex;
    print(pageNumber);
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
    setState(() {
      _title = title;
    });
    return title;
  }

  Future<String> _getSlideTitle() async {
    var doc = parse(await DefaultAssetBundle.of(context)
        .loadString(_getCurrentSlidePath()));
    var elems = doc.getElementsByTagName("title");
    var title;
    for (var e in elems) {
      var content = e.innerHtml;
      title = content;
    }
    return title;
  }

  Future<VoidCallback?> _onSlideChanged(int page) async {
    setState(() {
      _slideIndex = page;
    });
    var title;
    if (_slideIndex == 0) {
      title = await _getLessonTitle(context);
    } else {
      title = await _getSlideTitle();
    }
    setState(() {
      _title = title;
    });
    return null;
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
                  color: Colors.white,
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
