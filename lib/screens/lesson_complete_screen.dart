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
      appBar: AppBar(leading: Container(), title: Text("Complete!")),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Congratulations!"),
            SvgPicture.asset(
              lessonCompleteController.icon1,
            ),
            SvgPicture.asset(
              lessonCompleteController.icon2,
            ),
            Column(children: [
              Center(child: Text('+' + quizController.score.toString())),
              Center(
                child: Text("Learn-Score"),
              )
            ]),
            Text(
                "If you now and in the future follow all the recommendations given in this tutorial your passwords will be safe."),
            Text(
                "It is recommended that you revisit this lesson in the future to keep practising."),
            Text("Remind me:"),
            ElevatedButton(
                onPressed: () => lessonCompleteController.selectDate(context),
                child: Text("Set Reminder")),
            if (lessonCompleteController.selectedDate != null)
              Text(lessonCompleteController.selectDate.toString()),
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      lessonCompleteController.onFinishLessonPressed(context);
    },
    child: const Text("Finish Lesson"))),
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
