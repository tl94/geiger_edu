class Answer {
  String answer;
  bool value;

  Answer({required this.answer, required this.value});

  static Answer getDefaultAnswer() {
    return Answer(answer: "", value: false);
  }
}