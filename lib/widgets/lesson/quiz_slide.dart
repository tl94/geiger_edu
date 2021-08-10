import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/quiz_controller.dart';
import 'package:get/get.dart';

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
                      onPressed: quizController.finishQuiz,
                      child: Text("QuizFinishQuiz".tr))
                ];
              } else {
                children = <Widget>[Container(color: Colors.white)];
              }
              return ListView.builder(
                  itemCount: children.length,
                  itemBuilder: (context, index) {
                    return children[index];
                  });
            }));
  }
}
