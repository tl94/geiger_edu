import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geiger_edu/controller/lesson_complete_controller.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/controller/quiz_controller.dart';
import 'package:get/get.dart';

/// LessonCompleteScreen Widget.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class LessonCompleteScreen extends StatelessWidget {
  static const routeName = '/lessoncompletescreen';

  final LessonController lessonController = Get.find();
  final QuizController quizController = Get.find();
  final LessonCompleteController lessonCompleteController = Get.find();

  Widget build(BuildContext context) {
    List<Widget> quizResultsGroups =
        lessonCompleteController.getQuizResultsGroups();

    return Scaffold(
        appBar: AppBar(
          leading: Container(),
          title: Text("LessonCompleteComplete".tr),
          centerTitle: true,
        ),
        body: Container(
            child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("LessonCompleteCongratulations".tr,
                    style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        lessonCompleteController.icon1,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            lessonCompleteController.icon2,
                            height: 52,
                          ),
                          Column(children: [
                            Text(
                                '+ ' +
                                    lessonCompleteController
                                        .calculateScore()
                                        .toString(),
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.w600)),
                            Text("LessonCompleteLearnScore".tr,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromRGBO(116, 142, 160, 1))),
                          ])
                        ],
                      )
                    ]),
                SizedBox(height: 20),
                Text("LessonCompleteText1".tr, style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                Text("LessonCompleteText2".tr, style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("LessonCompleteRemindMe".tr),
                    Obx(() {
                      if (lessonCompleteController.dateSelected.value)
                        return GestureDetector(
                          onTap: () =>
                              lessonCompleteController.selectDate(context),
                          child: Text(
                              lessonCompleteController.selectedDate!.day
                                      .toString() +
                                  "." +
                                  lessonCompleteController.selectedDate!.month
                                      .toString() +
                                  "." +
                                  lessonCompleteController.selectedDate!.year
                                      .toString(),
                              style:
                                  TextStyle(fontSize: 20, color: Colors.blue)),
                        );
                      return OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.5);
                              return Colors.green;
                            },
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(5.0))),
                        ),
                        onPressed: () =>
                            lessonCompleteController.selectDate(context),
                        child: Text('LessonCompleteSetReminder'.tr,
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                      );
                    }),
                  ],
                ),
                SizedBox(height: 20),
                Text("LessonCompleteQuiz".tr, style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                if (quizResultsGroups.isNotEmpty)
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: quizController.questions.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return quizResultsGroups[index];
                      }),
                SizedBox(height: 20),
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5);
                        return Colors.green;
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  onPressed: () {
                    lessonCompleteController.onFinishLessonPressed(context);
                  },
                  child: Text('LessonCompleteFinishLesson'.tr,
                      style: TextStyle(fontSize: 25, color: Colors.white)),
                ),
              ],
            ),
          ),
        )));
  }
}
