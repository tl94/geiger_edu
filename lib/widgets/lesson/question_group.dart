import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geiger_edu/model/quiz/question.dart';
import 'package:get/get.dart';

/// QuestionGroup Widget.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class QuestionGroup extends StatefulWidget {
  final int questionIndex;
  final Question question;
  final Function(int, int) answerSelectedCallback;

  QuestionGroup(
      {required this.questionIndex,
      required this.question,
      required this.answerSelectedCallback});

  @override
  State<StatefulWidget> createState() => _QuestionGroup();
}

class _QuestionGroup extends State<QuestionGroup> {
  List<Widget> _buttons = [];
  int _selectionIndex = -1;
  RxString _groupValue = ''.obs;

  initState() {
    super.initState();
    _buttons = _createAnswerButtons();
  }

  List<Widget> _createAnswerButtons() {
    var answers = widget.question.answers;
    List<Widget> buttons = [];

    for (int i = 0; i < answers.length; i++) {
      var answer = answers[i];
      var button =
          /*OutlinedButton(
          onPressed: () {
            _selectionIndex = i;
            widget.answerSelectedCallback(
                widget.questionIndex, _selectionIndex);
          },
          child: Text(answer.answer));*/
          Obx(() => Container(
                  child: ListTile(
                contentPadding: EdgeInsets.all(0),
                dense: true,
                leading: Radio(
                  value: answer.answer,
                  groupValue: _groupValue.value,
                  onChanged: (value) {
                    //_selectedGender(value.toString());
                    _groupValue(value.toString());
                    _selectionIndex = i;
                    widget.answerSelectedCallback(
                        widget.questionIndex, _selectionIndex);
                  },
                ),
                title: Text(
                  answer.answer,
                  style: TextStyle(fontSize: 17),
                ),
              )));

      buttons.add(button);
    }
    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.question.question, style: TextStyle(fontSize: 17)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buttons,
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
