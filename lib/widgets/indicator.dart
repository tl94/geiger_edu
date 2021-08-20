import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/global_controller.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:get/get.dart';

/// Indicator Widget.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class Indicator extends StatelessWidget {
  final LessonController lessonController = Get.find();

  final double height;

  Indicator({required this.height}) : super();

  @override
  Widget build(BuildContext context) {
    var txtColor = GlobalController.txtColor;

    return Obx(() => (Container(
          height: 200,
          width: 200,
          child: Column(children: [
            Text("IndicatorYourProgress".tr,
                style: TextStyle(fontSize: 20, color: txtColor)),
            SizedBox(height: 10),
            Container(
                height: height,
                width: height,
                child: Stack(alignment: Alignment.center, children: [
                  Align(
                      alignment: Alignment(0, -.4),
                      child: Text(
                          (lessonController.completedLessonPercentage * 100)
                                  .toStringAsFixed(0) +
                              "%",
                          style: TextStyle(fontSize: 20, color: txtColor))),
                  RotationTransition(
                      turns: AlwaysStoppedAnimation(
                          lessonController.completedLessonPercentage * 0.49),
                      //0.49 is the value for the indicator to reach the other side
                      //0.12 //0.24 //0.37 //0.49
                      child: Image.asset("assets/img/indicator/indicator.png",
                          width: 150)),
                  Image.asset("assets/img/indicator/tiles.png", width: 150),
                  Align(
                      alignment: Alignment(0, 0.1),
                      child: Text(lessonController.label.value)),
                ])),
          ]),
        )));
  }
}
