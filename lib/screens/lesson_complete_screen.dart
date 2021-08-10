import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geiger_edu/controller/lesson_complete_controller.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/controller/quiz_controller.dart';
import 'package:get/get.dart';

class LessonCompleteScreen extends StatelessWidget {
  static const routeName = '/lessoncompletescreen';

  final LessonController lessonController = Get.find();
  final QuizController quizController = Get.find();
  final LessonCompleteController lessonCompleteController = Get.find();

  Widget build(BuildContext context) {
    List<Widget> quizResultsGroups =
        lessonCompleteController.getQuizResultsGroups();

    return Scaffold(
      appBar: AppBar(leading: Container(), title: Text("LessonCompleteComplete".tr)),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("LessonCompleteCongratulations".tr),
            SvgPicture.asset(
              lessonCompleteController.icon1,
            ),
            SvgPicture.asset(
              lessonCompleteController.icon2,
            ),
            Column(children: [
              Center(child: Text('+' + quizController.score.toString())),
              Center(
                child: Text("LessonCompleteLearnScore".tr),
              )
            ]),
            Text(
                "LessonCompleteText1".tr),
            Text(
                "LessonCompleteText2".tr),
            Text("LessonCompleteRemindMe".tr),
            ElevatedButton(
                onPressed: () => lessonCompleteController.selectDate(context),
                child: Text("LessonCompleteSetReminder".tr)),
            if (lessonCompleteController.selectedDate != null)
              Text(lessonCompleteController.selectDate.toString()),
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      lessonCompleteController.onFinishLessonPressed(context);
    },
    child: Text("LessonCompleteFinishLesson".tr))),
            if (quizResultsGroups.isNotEmpty)
              Expanded(
                child: SizedBox(
                    child: ListView.builder(
                        itemCount: quizController.questions.length,
                        itemBuilder: (context, index) {
                          return Center(child: quizResultsGroups[index]);
                        })),
              )
          ],
        ),
      ),
    );
  }
}
