class QuizQuestion {
  int questionId ;
  String questionBody , correctAnswer;
  List<String> questionAnswers  = List();
  QuizQuestion({this.correctAnswer , this.questionAnswers , this.questionBody , this.questionId});
}