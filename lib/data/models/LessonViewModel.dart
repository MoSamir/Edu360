import 'QuizQuestion.dart';

class LessonViewModel {

  String videoURL , documentURL , lessonLearning;
  int lessonId , quizMark ;
  bool flashCards ;
  List<QuizQuestion> quizQuestions = List();

  LessonViewModel(
      this.videoURL, this.quizMark , this.flashCards ,this.lessonId ,this.documentURL, this.lessonLearning, this.quizQuestions);
}