import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geiger_edu/widgets/lesson/question.dart';

import 'answer.dart';

class QuestionGroup extends StatefulWidget {

  final int questionIndex;
  final Question question;
  final Function(int, Answer) answerSelectedCallback;

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
              print(answer.answer);
              _selectionIndex = i;
              print(_selectionIndex);
              widget.answerSelectedCallback(i, answer);
            },
            child: Text(answer.answer)
        );
        buttons.add(button);
      }
    print("BUTTONS GENERATED");
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