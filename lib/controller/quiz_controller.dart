import 'package:flutter/cupertino.dart';
import 'package:geiger_edu/model/quiz/answer.dart';
import 'package:geiger_edu/model/quiz/question.dart';
import 'package:geiger_edu/screens/lesson_complete_screen.dart';
import 'package:geiger_edu/services/db.dart';
import 'package:geiger_edu/controller/io_controller.dart';
import 'package:geiger_edu/widgets/lesson/question_group.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:string_validator/string_validator.dart';

import 'lesson_controller.dart';

class QuizController extends GetxController {
  final LessonController lessonController = Get.find();
  final IOController ioController = Get.find();

  //** QUIZ STATE **
  List<Question> questions = [];
  var introText = "";
  List<Widget> questionGroups = [];
  List<Question> answeredQuestions = [];
  List<Answer> selectedAnswers = [];
  int score = 0;


  void initializeQuiz() {
    questions = [];
    introText = "";
    questionGroups = [];
    selectedAnswers = [];
    score = 0;
  }

  Future<List<String>> getQuizPath(BuildContext context) async {
    var lessonPath = ioController.getLocalizedLessonPath(lessonController.currentLesson.path);
    RegExp regExp = RegExp(lessonPath + "quiz\*");
    List<String> filePaths =
        await ioController.getDirectoryFilePaths(context, regExp);
    return filePaths;
  }

  /* get questions and answers from quiz html file */
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
        print(answer.toString() + value.toString());
        Answer a = Answer(answer: answer, value: value);
        answers.add(a);
      }
      var sq = Question(question: question, answers: answers);
      questions.add(sq);
    }
    this.questions = questions;
    selectedAnswers = List.filled(questions.length, Answer.getDefaultAnswer());
    return questions;
  }

  // create QuestionGroup for each question
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
    print(questionGroups.length);
    return questionGroups;
  }

  /* save selected answer */
  void addSelectedAnswer(int questionIndex, int selectionIndex) {
    // print(answer.answer);
    var question = questions[questionIndex];
    question.setSelectionIndex(selectionIndex);
  }

  /* check if an answer was selected for all questions */
  bool checkAnswers() {
    for (var question in questions) {
      if (question.selectionIndex == -1) return false;
    }
    return true;
  }

  /* evaluate answers */
  int evaluateAnswers() {
    for (var answer in selectedAnswers) {
      if (answer.value) {
        score += 25;
      }
    }
    return score;
  }

  void finishQuiz() {
    if (!lessonController.getLesson().completed) {
      if (checkAnswers()) {
        var score = evaluateAnswers();
        answeredQuestions = questions;

        lessonController.setLessonCompleted();
        DB.modifyUserScore(score);
      }
    }
    Get.to(() => LessonCompleteScreen());
  }
}