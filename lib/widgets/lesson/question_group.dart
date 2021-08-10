import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geiger_edu/model/quiz/question.dart';

import '../../model/quiz/answer.dart';

class QuestionGroup extends StatefulWidget {

  final int questionIndex;
  final Question question;
  final Function(int, int) answerSelectedCallback;

  QuestionGroup({required this.questionIndex, required this.question, required this.answerSelectedCallback});

  @override
  State<StatefulWidget> createState() => _QuestionGroup();
}

class _QuestionGroup extends State<QuestionGroup> {

  List<ElevatedButton> _buttons = [];
  int _selectionIndex = -1;

  initState() {
    super.initState();
    _buttons = _createAnswerButtons();
  }

  List<ElevatedButton> _createAnswerButtons() {
      var answers = widget.question.answers;
      List<ElevatedButton> buttons = [];

      for (int i = 0; i < answers.length; i++) {
        var answer = answers[i];
        var button = ElevatedButton(
            onPressed: () {
              _selectionIndex = i;
              widget.answerSelectedCallback(widget.questionIndex, _selectionIndex);
            },
            child: Text(answer.answer)
        );
        buttons.add(button);
      }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(widget.question.question),
        ),
        Center(
          child: Column(
            children: _buttons,
          )
        )
      ],
    );
  }

}