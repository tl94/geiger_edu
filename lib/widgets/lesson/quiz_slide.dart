import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/controller/quiz_controller.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/model/quiz/question.dart';
import 'package:geiger_edu/screens/lesson_complete_screen.dart';
import 'package:geiger_edu/screens/quiz_results_screen.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/widgets/lesson/question_group.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:string_validator/string_validator.dart';

import '../../model/quiz/answer.dart';
import 'package:geiger_edu/globals.dart' as globals;

class QuizSlide extends StatelessWidget {

  final QuizController quizController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Widget>>(
          future: quizController.getQuestionGroups(context),
          builder:
              (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
            List<Widget> children;

            if (snapshot.hasData) {
              children = [
                Center(child: Text(quizController.introText)),
                /* add QuestionGroups */
                for (var qg in snapshot.data!) qg,
                Spacer(),
                ElevatedButton(
                    onPressed: quizController.finishQuiz, child: Text("Finish Quiz"))
              ];
            } else {
              children = <Widget>[
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60,
                        height: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      )
                    ],
                  ),
                )

              ];
            }
            return ListView.builder(
                itemCount: children.length,
                itemBuilder: (context, index) {
                  return children[index];
                });
          }));
  }
}
