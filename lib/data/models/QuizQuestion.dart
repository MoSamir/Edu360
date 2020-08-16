import 'package:edu360/data/apis/helpers/ApiParseKeys.dart';

class QuizQuestion {
  int questionId , correctAnswer;
  String questionBody ;
  List<String> questionAnswers  = List();
  QuizQuestion({this.correctAnswer , this.questionAnswers , this.questionBody , this.questionId});


  static QuizQuestion fromJson(singleQuestionJson){

    List<String> answers = List();
    for(int i = 0 ; i < 4 ; i++){
      answers.add(singleQuestionJson['${ApiParseKeys.ANSWER_NO}${i+1}'].toString());
    }

    return QuizQuestion(
     correctAnswer: singleQuestionJson[ApiParseKeys.CORRECT_ANSWER_INDEX] -1 ,
     questionAnswers: answers,
     questionBody: singleQuestionJson[ApiParseKeys.QUESTION]
    );
  }

  static List<QuizQuestion> fromListJson(List<dynamic> questionsListJson) {
    List<QuizQuestion> questions = List();
    for(int i = 0 ; i < questionsListJson.length ; i++){
      questions.add(QuizQuestion.fromJson(questionsListJson[i]));
    }
    return questions;
  }
}