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

class LessonCompleteScreen extends StatefulWidget {
  static const routeName = '/lessoncompletescreen';

  final LessonController lessonController = Get.find();

  LessonCompleteScreen();

  @override
  State<StatefulWidget> createState() => _LessonCompleteScreenState();
}

class _LessonCompleteScreenState extends State<LessonCompleteScreen> {
  static const String icon1 = "assets/img/congratulations_icon.svg";
  static const String icon2 = "assets/img/trophy_icon.svg";
  DateTime? _selectedDate;

  void _onFinishLessonPressed() {
    Navigator.pushNamed(context, HomeScreen.routeName);
  }

  List<Widget> getQuizResultsGroups() {
    List<Widget> quizResultsGroups = [];
    // TODO: don't do this step if lesson has no quiz
    for (var question in widget.lessonController.answeredQuestions) {
      quizResultsGroups.add(QuizResultsGroup(answeredQuestion: question));
    }
    return quizResultsGroups;
  }

  Future<void> _selectDate() async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.utc(2100, 12, 31));
    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }
  }

  Widget build(BuildContext context) {
    List<Widget> quizResultsGroups = getQuizResultsGroups();

    return Scaffold(
      appBar: AppBar(leading: Container(), title: Text("Complete!")),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Congratulations!"),
            SvgPicture.asset(
              icon1,
            ),
            SvgPicture.asset(
              icon2,
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
                onPressed: _selectDate,
                child: Text("Set Reminder")),
            if (_selectedDate != null) Text(_selectedDate.toString()),
            Center(
                child: ElevatedButton(
                    onPressed: _onFinishLessonPressed, child: const Text("Finish Lesson"))),
            if (widget.lessonController.answeredQuestions.isNotEmpty)
              Expanded(
                child: SizedBox(
                    child: ListView.builder(
                        itemCount: widget.lessonController.answeredQuestions.length,
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
