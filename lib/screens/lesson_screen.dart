import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/services/lesson_loader.dart';
import 'package:geiger_edu/widgets/lesson/LessonContainer.dart';

import 'package:geiger_edu/globals.dart' as globals;

class LessonScreen extends StatefulWidget {
  static const routeName = '/lessonscreen';
  static const bckColor = const Color(0xFF5dbcd2); //0xFFedb879

  final Lesson lesson;
  final int initialPage;

  LessonScreen({required this.lesson, required this.initialPage}) : super();

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  List<String> _slidePaths = [];

  Future<List<String>> getSlidePaths(BuildContext context) async {
    List<String> filePaths = await LessonLoader.getLessonSlidePaths(context, widget.lesson.path);
    setState(() {
      _slidePaths = filePaths;
    });
    return filePaths;
  }

  @override
  Widget build(BuildContext context) {
    if (_slidePaths.isEmpty) {
      getSlidePaths(context);
      return new Container(color: Colors.white);
    } else {
      return new LessonContainer(lesson: widget.lesson, slidePaths: _slidePaths, initialPage: widget.initialPage);
    }
  }
}
