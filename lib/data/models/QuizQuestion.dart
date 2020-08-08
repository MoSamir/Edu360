class QuizQuestion {
  int questionId ;
  String questionBody , correctAnswer;
  List<String> questionAnswers  = List();
  QuizQuestion({this.correctAnswer , this.questionAnswers , this.questionBody , this.questionId});


  static QuizQuestion fromJson(singleQuestionJson){
    return QuizQuestion();
  }

  static List<QuizQuestion> fromListJson(List<dynamic> questionsListJson) {
    List<QuizQuestion> questions = List();
    for(int i = 0 ; i < questionsListJson.length ; i++){
      questions.add(QuizQuestion.fromJson(questionsListJson[i]));
    }
    return questions;
  }
}