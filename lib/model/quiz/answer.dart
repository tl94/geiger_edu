/// This class models an answer object of the quiz.
///
/// @author Felix Mayer
/// @author Turan Ledermann

class Answer {
  String answer;
  bool value;

  /// Answer object constructor.
  Answer({required this.answer, required this.value});

  /// This method defines the default value of an answer.
  static Answer getDefaultAnswer() {
    return Answer(answer: "", value: false);
  }
}