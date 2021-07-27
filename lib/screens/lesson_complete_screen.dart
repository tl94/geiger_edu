import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/globals.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/model/quiz/question.dart';
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:geiger_edu/widgets/lesson/quiz_results_group.dart';
import 'package:get/get.dart';

class LessonCompleteScreen extends StatelessWidget {
  static const routeName = '/lessoncompletescreen';

  final LessonController lessonController = Get.find();

  Widget build(BuildContext context) {
    List<Widget> quizResultsGroups = lessonController.getQuizResultsGroups();

    return Scaffold(
      appBar: AppBar(leading: Container(), title: Text("Complete!")),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Congratulations!"),
            SvgPicture.asset(
              lessonController.icon1,
            ),
            SvgPicture.asset(
              lessonController.icon2,
            ),
            Column(children: [
              Center(child: Text("+25")),
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
                onPressed: () => lessonController.selectDate(context),
                child: Text("Set Reminder")),
            if (lessonController.selectedDate != null) Text(lessonController.selectDate.toString()),
            Center(
                child: ElevatedButton(
                    onPressed: lessonController.onFinishLessonPressed, child: const Text("Finish Lesson"))),
            if (lessonController.answeredQuestions.isNotEmpty)
              Expanded(
                child: SizedBox(
                    child: ListView.builder(
                        itemCount: lessonController.answeredQuestions.length,
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
