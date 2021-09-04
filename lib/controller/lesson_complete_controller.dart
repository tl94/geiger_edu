import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/controller/quiz_controller.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/widgets/lesson/quiz_results_group.dart';
import 'package:get/get.dart';

import 'global_controller.dart';

/// This class handles the interaction and creation of UI elements on the lesson.
/// complete screen
///
/// @author Felix Mayer
/// @author Turan Ledermann

//TODO: COMMENT THIS CLASS
class LessonCompleteController extends GetxController {
  final QuizController quizController = Get.find();
  final LessonController lessonController = Get.find();

  //** LESSON COMPLETE SCREEN **
  final String icon1 = "assets/img/congratulations_icon.svg";
  final String icon2 = "assets/img/trophy_icon.svg";

  DateTime? selectedDate;

  int difference = 0;

  /// calculate score to display on screen
  int calculateScore() {
    var currentLesson = lessonController.currentLesson;
    var oldScore = currentLesson.lastQuizScore;
    var newScore = quizController.score;
    var difference = 0;
    if (newScore > oldScore) {
      difference = newScore - oldScore;
    } else {
      difference = oldScore - newScore;
    }
    this.difference = difference;
    return difference;
  }

  /// navigate to home screen after finish lesson button press.
  void onFinishLessonPressed(BuildContext context) {
    if (!lessonController.isMaxScoreReached() || !lessonController.getCurrentLesson().completed) {
      lessonController.setLessonCompleted();
      var currentLesson = lessonController.currentLesson;
      var oldScore = currentLesson.lastQuizScore;
      var newScore = quizController.score;
      if (oldScore == 0 || newScore > oldScore) {
        currentLesson.lastQuizScore = newScore;
        DB.updateLesson(currentLesson);
        DB.addUserScore(difference);
      }
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  /// create quiz result elements to visualise correct / false answers.
  List<Widget> getQuizResultsGroups() {
    List<Widget> quizResultsGroups = [];
    if (lessonController.getCurrentLesson().hasQuiz) {
      for (var question in quizController.questions) {
        quizResultsGroups.add(QuizResultsGroup(answeredQuestion: question));
      }
    }
    return quizResultsGroups;
  }

  /// function for datepicker.
  Future<void> selectDate(BuildContext context) async {
    final DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.utc(2100, 12, 31));
    if (selectedDate != null) {
      selectedDate = newSelectedDate;
    }
  }
}
