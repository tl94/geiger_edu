import 'package:flutter/cupertino.dart';
import 'package:geiger_edu/controller/global_controller.dart';
import 'package:geiger_edu/controller/io_controller.dart';
import 'package:geiger_edu/model/quiz/answer.dart';
import 'package:geiger_edu/model/quiz/question.dart';
import 'package:geiger_edu/screens/lesson_complete_screen.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/widgets/lesson/question_group.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:string_validator/string_validator.dart';

import 'lesson_controller.dart';

/// This class handles the business logic of the quiz.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class QuizController extends GetxController {
  final LessonController lessonController = Get.find();
  final IOController ioController = Get.find();

  //** QUIZ STATE **
  List<Question> questions = [];
  var introText = "";
  List<Widget> questionGroups = [];
  int score = 0;

  /// This method initialises quiz state.
  void initializeQuiz() {
    questions = [];
    introText = "";
    questionGroups = [];
    score = 0;
  }

  /// This method gets the path for this lesson's quiz file.
  ///
  /// @param context The BuildContext of the parent widget
  Future<List<String>> getQuizPath(BuildContext context) async {
    var lessonPath = ioController
        .getLocalizedLessonPath(lessonController.currentLesson.path);
    RegExp regExp = RegExp(lessonPath + "quiz\*");
    List<String> filePaths =
        await ioController.getDirectoryFilePaths(context, regExp);
    return filePaths;
  }

  ///This method calculates the maximum score possible in the quiz and stores it in the DB.
  ///
  /// @param questions The list of questions in the current lesson's quiz
  void saveQuizMaxScore(List<Question> questions) {
    var maxScore = questions.length * GlobalController.baseQuizQuestionReward;
    var currentLesson = lessonController.getCurrentLesson();
    if (currentLesson.maxQuizScore != maxScore) {
      currentLesson.maxQuizScore = maxScore;
      DB.getLessonBox().put(currentLesson.lessonId, currentLesson);
    }
  }

  /// This method gets the questions and answers of the quiz from the html file.
  ///
  /// @param context The BuildContext of the parent widget
  Future<List<Question>> getQuiz(BuildContext context) async {
    initializeQuiz();
    var quizPath = await getQuizPath(context);
    var doc =
        parse(await DefaultAssetBundle.of(context).loadString(quizPath.first));

    introText = doc.getElementsByTagName("p").first.innerHtml;

    var formElems = doc.getElementsByTagName("form");

    List<Question> questions = [];
    for (var fe in formElems) {
      var p = fe.getElementsByTagName("p").first;
      var question = p.innerHtml;

      List<Answer> answers = [];
      var inputFields = fe.getElementsByTagName("input");
      var labelFields = fe.getElementsByTagName("label");
      for (int i = 0; i < labelFields.length; i++) {
        var ifld = inputFields[i];
        var lfld = labelFields[i];
        var value = toBoolean(ifld.attributes["value"]!);
        var answer = lfld.innerHtml;
        Answer a = Answer(answer: answer, value: value);
        answers.add(a);
      }
      var sq = Question(question: question, answers: answers);
      questions.add(sq);
    }
    this.questions = questions;
    saveQuizMaxScore(questions);
    return questions;
  }

  /// This method creates a QuestionGroup for each question.
  ///
  /// @param context The BuildContext of the parent widget
  Future<List<Widget>> getQuestionGroups(BuildContext context) async {
    List<Question> questions = await getQuiz(context);
    questions = questions;
    List<QuestionGroup> questionGroups = [];
    for (int i = 0; i < questions.length; i++) {
      var question = questions[i];
      var questionGroup = QuestionGroup(
          questionIndex: i,
          question: question,
          answerSelectedCallback: addSelectedAnswer);
      questionGroups.add(questionGroup);
    }
    this.questionGroups = questionGroups;
    return questionGroups;
  }

  /// This method sets for a question the index of the selects an answer.
  ///
  /// @param questionIndex The index of the question
  /// @param selectionIndex The index of the selection
  void addSelectedAnswer(int questionIndex, int selectionIndex) {
    var question = questions[questionIndex];
    question.setSelectionIndex(selectionIndex);
  }

  /// This method checks if an answer was selected for all questions.
  bool checkAnswers() {
    for (var question in questions) {
      if (question.selectionIndex == -1) return false;
    }
    return true;
  }

  /// This method evaluates the given answers.
  int evaluateAnswers() {
    for (var question in questions) {
      var answer = question.answers[question.selectionIndex];
      if (answer.value) {
        score += GlobalController.baseQuizQuestionReward;
      }
    }
    return score;
  }

  /// This method checks if all questions were answered, finishes the quiz,
  /// awards the score and moves on to the next screen.
  void finishQuiz() {
    if (checkAnswers()) {
      var score = evaluateAnswers();
      Get.to(() => LessonCompleteScreen());
    }
  }
}
