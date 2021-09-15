import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/controller/quiz_controller.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/widgets/lesson/quiz_results_group.dart';
import 'package:get/get.dart';

/// This class handles the interaction and creation of UI elements on the lesson.
/// complete screen.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class LessonCompleteController extends GetxController {
  final QuizController quizController = Get.find();
  final LessonController lessonController = Get.find();

  //** LESSON COMPLETE SCREEN **
  final String icon1 = "assets/img/congratulations_icon.svg";
  final String icon2 = "assets/img/trophy_icon.svg";

  DateTime? selectedDate;
  var dateSelected = false.obs;

  // difference between new and old score.
  int difference = 0;

  /// This method calculates the score to be displayed on the screen.
  int calculateScore() {
    var currentLesson = lessonController.currentLesson;
    var oldScore = currentLesson.lastQuizScore;
    var newScore = quizController.score;
    var difference = 0;
    if (newScore > oldScore) {
      difference = newScore - oldScore;
    }
    this.difference = difference;
    return difference;
  }

  /// This method navigates to home screen after a lesson is concluded.
  ///
  /// @param context BuildContext of parent Widget
  void onFinishLessonPressed(BuildContext context) {
    if (!lessonController.isMaxScoreReached() ||
        !lessonController.getCurrentLesson().completed) {
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
    selectedDate = null;
    dateSelected(false);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  /// This method creates a quiz result elements to visualise correct / false answers.
  List<Widget> getQuizResultsGroups() {
    List<Widget> quizResultsGroups = [];
    if (lessonController.getCurrentLesson().hasQuiz) {
      for (var question in quizController.questions) {
        quizResultsGroups.add(QuizResultsGroup(answeredQuestion: question));
      }
    }
    return quizResultsGroups;
  }

  /// This method opens datepicker and saves selected date.
  ///
  /// @param context BuildContext of parent Widget
  Future<void> selectDate(BuildContext context) async {
    dateSelected(false);
    final DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.utc(2100, 12, 31));
    if (newSelectedDate != null) {
      selectedDate = newSelectedDate;
      dateSelected(true);
    }
  }
}
