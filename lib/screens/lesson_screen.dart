import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/widgets/lesson/LessonContainer.dart';

import 'package:geiger_edu/globals.dart' as globals;

class LessonScreen extends StatefulWidget {
  static const routeName = '/lessonscreen';
  static const bckColor = const Color(0xFF5dbcd2); //0xFFedb879

  final String lessonPath;
  final int initialPage;

  LessonScreen({required this.lessonPath, required this.initialPage}) : super();

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  List<String> _slidePaths = [];

  Future<List<String>> getSlidePaths(BuildContext context) async {
    List<String> filenames = [];
    var manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    Map<String, dynamic> manifestMap = json.decode(manifestContent);
    RegExp regExp = RegExp("slide_\*");
    var filePaths = manifestMap.keys
        .where((String key) => key.contains(widget.lessonPath))
        .where((String key) => regExp.hasMatch(key))
        .toList();
    setState(() {
      _slidePaths = filePaths;
    });
    return filenames;
  }

  @override
  Widget build(BuildContext context) {
    if (_slidePaths.isEmpty) {
      getSlidePaths(context);
      return new Container(color: Colors.white);
    } else {
      return new LessonContainer(lessonPath: widget.lessonPath, slidePaths: _slidePaths, initialPage: widget.initialPage);
    }
  }
}
