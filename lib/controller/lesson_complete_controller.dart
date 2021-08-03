import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geiger_edu/controller/lesson_controller.dart';
import 'package:geiger_edu/controller/quiz_controller.dart';
import 'package:geiger_edu/screens/home_screen.dart';
import 'package:geiger_edu/widgets/lesson/quiz_results_group.dart';
import 'package:get/get.dart';

class LessonCompleteController extends GetxController {
  final QuizController quizController = Get.find();
  final LessonController lessonController = Get.find();

  //** LESSON COMPLETE SCREEN **
  final String icon1 = "assets/img/congratulations_icon.svg";
  final String icon2 = "assets/img/trophy_icon.svg";

  DateTime? selectedDate;

  /// navigate to home screen after finish lesson button press
  void onFinishLessonPressed() {
    Get.to(() => HomeScreen());
  }

  /// create quiz result elements to visualise correct / false answers
  List<Widget> getQuizResultsGroups() {
    List<Widget> quizResultsGroups = [];
    if (lessonController.getCurrentLesson().hasQuiz) {
      for (var question in quizController.questions) {
        quizResultsGroups.add(QuizResultsGroup(answeredQuestion: question));
      }
    }
    return quizResultsGroups;
  }

  /// function for datepicker
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
