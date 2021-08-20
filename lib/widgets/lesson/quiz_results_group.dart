import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geiger_edu/model/quiz/question.dart';

/// QuizResultsGroup Widget.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class QuizResultsGroup extends StatelessWidget {
  final Question answeredQuestion;

  QuizResultsGroup({required this.answeredQuestion});

  List<Widget> getMarkedAnswers() {
    List<Widget> answerContainers = [];
    var answers = answeredQuestion.answers;
    for (int i = 0; i < answers.length; i++) {
      var answer = answers[i];
      var answerContainer;
      if (i == answeredQuestion.selectionIndex) {
        if (answer.value) {
          answerContainer = Container(
            child: Text(answer.answer),
            decoration: BoxDecoration(
                color: Colors.yellow[100],
                border: Border.all(
                  color: Colors.green,
                  width: 5,
                )),
          );
        } else {
          answerContainer = Container(
            child: Text(answer.answer),
            decoration: BoxDecoration(
                color: Colors.yellow[100],
                border: Border.all(
                  color: Colors.red,
                  width: 5,
                )),
          );
        }
      } else {
        answerContainer = Container(
          child: Text(answer.answer),
        );
      }
      answerContainers.add(answerContainer);
    }
    return answerContainers;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Center(
            child: Text(answeredQuestion.question),
          ),
          Center(
              child: Column(
                  children: getMarkedAnswers()
              )
          )
        ]);
  }


}