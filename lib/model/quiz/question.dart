import '../../model/quiz/answer.dart';

/// This class models a question object of a quiz.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class Question {
  String question;
  List<Answer> answers;
  int selectionIndex = -1;

  /// Question object constructor.
  Question({required this.question, required this.answers});

  /// This method sets the index of the selected answer.
  ///
  /// @param index Index of the selected answer
  setSelectionIndex(int index) {
    selectionIndex = index;
  }
}