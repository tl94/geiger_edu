import 'dart:io';

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
  var _title = "Passwords";
  List<Widget> _slides = [];
  final _pageController = new PageController();

  List<Widget> _getSlides() {
    if (_slides.isEmpty) {
      List<String> slidePaths = widget.slidePaths;
      List<Widget> slides = [];
      for (var sp in slidePaths) {
        SlideContainer slide = new SlideContainer(slidePath: sp);
        slides.add(slide);
      }
      _slides = slides;
    }
    return _slides;
  }

  String _getCurrentSlidePath() {
    var pageNumber = _pageController.page!.toInt();
    var currentSlide = widget.slidePaths[pageNumber];
    return currentSlide;
  }

  File _getCurrentSlideFile() {
    var currentSlidePath = _getCurrentSlidePath();
    File currentSlideFile = File(currentSlidePath);
    return currentSlideFile;
  }

  Future<String> _getLessonTitle(BuildContext context) async {
    var firstSlidePath = widget.slidePaths.first;
    var doc = parse(await DefaultAssetBundle.of(context).loadString(firstSlidePath));
    var elems = doc.getElementsByTagName("meta");
    var title;
    for (var e in elems) {
      var content = e.attributes["content"];
      if (content != null) title = content;
    }
    return title;
  }

  String _getSlideTitle() {
    var currentSlideFile = _getCurrentSlideFile();
    var doc = parse(currentSlideFile.readAsString());
    var elems = doc.getElementsByTagName("title");
    var title;
    for (var e in elems) {
      var content = e.attributes["content"];
      if (content != null) title = content;
    }
    return title;
  }

  VoidCallback? _onSlideChanged(int page) {
    setState(() {
      // TODO read title from slide
      _title = '_getLessonTitle();';
    });
    return null;
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text(_title)
      ),
      body: new PageView(
        controller: _pageController,
        children: _getSlides(),
        onPageChanged: _onSlideChanged,
        allowImplicitScrolling: true,
      ),
    );
  }
}
