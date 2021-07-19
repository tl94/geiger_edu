import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/widgets/lesson/LessonContainer.dart';

class LessonScreen extends StatefulWidget {
  static const routeName = '/lessonscreen';
  static const bckColor = const Color(0xFF5dbcd2); //0xFFedb879

  final String lessonPath;

  LessonScreen({required this.lessonPath}) : super();

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
    var filePaths = manifestMap.keys
        .where((String key) => key.contains(widget.lessonPath))
        .where((String key) => key.contains('.html'))
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
      return new LessonContainer(slidePaths: _slidePaths);
    }
  }
}
