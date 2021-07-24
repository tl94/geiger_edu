import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/model/quiz/question.dart';
import 'package:geiger_edu/widgets/lesson/question_group.dart';
import 'package:geiger_edu/widgets/lesson/quiz_results_group.dart';
import 'package:html/parser.dart';
import 'package:string_validator/string_validator.dart';

import '../model/quiz/answer.dart';import 'package:geiger_edu/globals.dart' as globals;

//TODO: UNUSED CLASS
class QuizResultsScreen extends StatelessWidget {
  static const routeName = '/quizresultsscreen';
  final Lesson lesson;
  final List<Question> answeredQuestions;

  QuizResultsScreen({required this.lesson, required this.answeredQuestions});

  List<Widget> getQuizResultsGroups() {
    List<Widget> quizResultsGroups = [];
    for (var question in answeredQuestions) {
      quizResultsGroups.add(QuizResultsGroup(answeredQuestion: question));
    }
    return quizResultsGroups;
  }

  @override
  Widget build(BuildContext context) {
    var quizResultsGroups = getQuizResultsGroups();
    return Scaffold(
        appBar: AppBar(title: Text("Quiz: " + lesson.title[globals.language]!)),
        body: ListView.builder(
        itemCount: answeredQuestions.length,
        itemBuilder: (context, index) {
          return quizResultsGroups[index];
        }));
  }
}