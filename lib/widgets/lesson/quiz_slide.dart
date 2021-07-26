import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geiger_edu/model/lessonObj.dart';
import 'package:geiger_edu/model/quiz/question.dart';
import 'package:geiger_edu/screens/lesson_complete_screen.dart';
import 'package:geiger_edu/screens/quiz_results_screen.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/services/lesson_loader.dart';
import 'package:geiger_edu/widgets/lesson/question_group.dart';
import 'package:html/parser.dart';
import 'package:string_validator/string_validator.dart';

import '../../model/quiz/answer.dart';
import 'package:geiger_edu/globals.dart' as globals;

class QuizSlide extends StatefulWidget {
  final Lesson lesson;

  QuizSlide({required this.lesson});

  @override
  State<StatefulWidget> createState() => _QuizSlideState();
}

class _QuizSlideState extends State<QuizSlide> {
  List<Question> _questions = [];
  var _mainQuestion = "";
  late Future<List<Widget>> _questionGroups;
  List<Answer> _selectedAnswers = [];
  int _score = 0;

  @override
  initState() {
    super.initState();
    _questionGroups = _getQuestionGroups();
  }

  Future<List<String>> _getQuizPath() async {
    var filePaths = LessonLoader.getQuizPath(context, widget.lesson.path);
    print(filePaths);
    return filePaths;
  }

  /* get questions and answers from quiz html file */
  Future<List<Question>> _getQuiz() async {
    var quizPath = await _getQuizPath();
    var doc =
        parse(await DefaultAssetBundle.of(context).loadString(quizPath.first));

    _mainQuestion = doc.getElementsByTagName("p").first.innerHtml;

    var formElems = doc.getElementsByTagName("form");

    List<Question> subQuestions = [];
    for (var fe in formElems) {
      var p = fe.getElementsByTagName("p").first;
      var subQuestion = p.innerHtml;

      List<Answer> answers = [];
      var inputFields = fe.getElementsByTagName("input");
      var labelFields = fe.getElementsByTagName("label");
      for (int i = 0; i < labelFields.length; i++) {
        var ifld = inputFields[i];
        var lfld = labelFields[i];
        var value = toBoolean(ifld.attributes["value"]!);
        var answer = lfld.innerHtml;
        print(answer.toString() + value.toString());
        Answer a = Answer(answer: answer, value: value);
        answers.add(a);
      }
      var sq = Question(question: subQuestion, answers: answers);
      subQuestions.add(sq);
    }
    _selectedAnswers =
        List.filled(subQuestions.length, Answer.getDefaultAnswer());
    return subQuestions;
  }

  // create QuestionGroup for each question
  Future<List<Widget>> _getQuestionGroups() async {
    List<Question> questions = await _getQuiz();
    _questions = questions;
    List<QuestionGroup> questionGroups = [];
    for (int i = 0; i < questions.length; i++) {
      var question = questions[i];
      var questionGroup = QuestionGroup(
          questionIndex: i,
          question: question,
          answerSelectedCallback: _addSelectedAnswer);
      questionGroups.add(questionGroup);
    }
    print(questionGroups.length);
    return questionGroups;
  }

  /* save selected answer */
  void _addSelectedAnswer(int questionIndex, int selectionIndex) {
    // print(answer.answer);
    var question = _questions[questionIndex];
    question.setSelectionIndex(selectionIndex);
  }

  /* check if an answer was selected for all questions */
  bool _checkAnswers() {
    for (var question in _questions) {
      if (question.selectionIndex == -1) return false;
    }
    return true;
  }

  /* evaluate answers */
  int _evaluateAnswers() {
    for (var answer in _selectedAnswers) {
      if (answer.value) {
        _score += 25;
      }
    }
    return _score;
  }


  void _finishQuiz() {
    if (!widget.lesson.completed && _checkAnswers()) {
      var score = _evaluateAnswers();
       globals.answeredQuestions = _questions;

      // TODO: PUT IN DEDICATED FUNCTIONS: write points and lesson completion to DB, also check if it was already completed before
      var lesson = widget.lesson;
      lesson.completed = true;
      DB.getLessonBox().put(lesson.lessonId, lesson);
      DB.modifyUserScore(score);
      globals.completedLessons++;

      Navigator.pushNamed(
          context,
          LessonCompleteScreen.routeName
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Widget>>(
          future: _questionGroups,
          builder:
              (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
            List<Widget> children;

            if (snapshot.hasData) {
              children = [
                Center(child: Text(_mainQuestion)),
                /* add QuestionGroups */
                for (var qg in snapshot.data!) qg,
                Spacer(),
                ElevatedButton(
                    onPressed: _finishQuiz, child: Text("Finish Quiz"))
              ];
            } else {
              children = const <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ];
            }
            return ListView.builder(
                itemCount: children.length,
                itemBuilder: (context, index) {
                  return children[index];
                });
          }));
  }
}
