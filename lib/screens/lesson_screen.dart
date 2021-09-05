import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/io_controller.dart';
import 'package:geiger_edu/widgets/lesson/lesson_container.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:get/get.dart';

/// LessonScreen Widget.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class LessonScreen extends StatelessWidget {
  static const routeName = '/lessonscreen';

  final IOController ioController = Get.find();
  final LessonController lessonController = Get.find();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: ioController.getSlidePaths(
            context, lessonController.currentLesson.path),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasData) {
            return LessonContainer();
          } else
            return Container(color: Colors.white);
        });
  }
}
