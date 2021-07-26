import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/services/lesson_loader.dart';
import 'package:geiger_edu/widgets/lesson/LessonContainer.dart';

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
  late Future<List<String>> _slidePaths;

  initState() {
    super.initState();
    _slidePaths = getSlidePaths(context);
  }

  Future<List<String>> getSlidePaths(BuildContext context) async {
    List<String> filePaths =
        await LessonLoader.getLessonSlidePaths(context, widget.lesson.path);
    return filePaths;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: _slidePaths,
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasData) {
            return LessonContainer(
                lesson: widget.lesson, slidePaths: snapshot.data!);
          } else
            return Container(color: Colors.white);
        });
  }
}
