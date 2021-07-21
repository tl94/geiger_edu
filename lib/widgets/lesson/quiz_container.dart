import 'package:flutter/material.dart';
import 'package:geiger_edu/widgets/lesson/question.dart';
import 'package:geiger_edu/widgets/lesson/question_group.dart';
import 'package:html/parser.dart';
import 'package:string_validator/string_validator.dart';

import 'answer.dart';

class QuizContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuizContainerState();
}

class _QuizContainerState extends State<QuizContainer> {
  var _title = "Password Safety";
  var _mainQuestion = "";
  List<Question> _questions = [];
  List<Answer> _selectedAnswers = [];

  @override
  initState() {
    super.initState();
    _getQuizQuestions();
  }

  /* get questions and answers from quiz html files */
  Future<List<Question>> _getQuizQuestions() async {
    var doc = parse(await DefaultAssetBundle.of(context)
        .loadString("assets/lesson/password/password_safety/eng/quiz_0.html"));

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
    setState(() {
      _questions = subQuestions;
      _selectedAnswers =
          List.filled(subQuestions.length, Answer.getDefaultAnswer());
    });
    print("SUBQUESTIONS: " + subQuestions.length.toString());
    return subQuestions;
  }

  // create QuestionGroup for each question
  List<Widget> _createQuestionGroups() {
    List<QuestionGroup> questionGroups = [];
    for (int i = 0; i < _questions.length; i++) {
      var question = _questions[i];
      var questionGroup = QuestionGroup(
          questionIndex: i,
          question: question,
          answerSelectedCallback: _addSelectedAnswer);
      questionGroups.add(questionGroup);
    }
    return questionGroups;
  }

  /* save selected answer */
  void _addSelectedAnswer(int questionIndex, Answer answer) {
    // print(answer.answer);
    _selectedAnswers[questionIndex] = answer;
    // print("SELECTED ANSWER: " + answer.toString() + " AT " + _slideIndex.toString() + " ADDED");
  }

  // TODO: Probably needs proper compareTo function
  /* check if an answer was selected for all questions */
  bool _checkAnswers() {
    var defAnswer = Answer.getDefaultAnswer();
    for (var answer in _selectedAnswers) {
      if (answer == defAnswer) return false;
    }
    return true;
  }

  /* evaluate answers based on */
  int _evaluateAnswers() {
    var points = 0;
    for (var answer in _selectedAnswers) {
      if (answer.value) {
        points += 25;
      }
    }
    return points;
  }

  void _finishQuiz() {
    if (_checkAnswers()) {
      var points = _evaluateAnswers();
      // TODO: write points and lesson completion to DB, also check if it was already completed before


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Quiz: " + _title)),
        body: Column(
            children: [
              if (_mainQuestion != "") Center(child: Text(_mainQuestion)),
              /* add QuestionGroups */
              for (var qg in _createQuestionGroups()) qg,
              Spacer(),
              ElevatedButton(
                  onPressed: _finishQuiz,
                  child: Text("Finish Quiz"))
            ]
)
    );
  }
}
