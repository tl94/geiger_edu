import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/widgets/lesson/LessonContainer.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:get/get.dart';

class LessonScreen extends StatelessWidget {
  static const routeName = '/lessonscreen';
  static const bckColor = const Color(0xFF5dbcd2); //0xFFedb879

  final LessonController lessonController = Get.find();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: lessonController.getSlidePaths(context),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasData) {
            return LessonContainer();
          } else
            return Container(color: Colors.white);
        });
  }
}
