import '../../model/quiz/answer.dart';

class Question {
  String question;
  List<Answer> answers;
  int selectionIndex = -1;

  Question({required this.question, required this.answers});

  setSelectionIndex(int index) {
    selectionIndex = index;
  }
}