import 'package:edu360/data/apis/helpers/ApiParseKeys.dart';

import 'QuizQuestion.dart';

class LessonViewModel {

  String videoURL , documentURL , lessonLearning;
  int lessonId , quizMark ;
  String lessonNameEn, lessonNameAr ;
  bool flashCards ;
  List<QuizQuestion> quizQuestions = List();

  LessonViewModel({
      this.videoURL, this.quizMark , this.lessonNameAr , this.lessonNameEn ,this.flashCards ,this.lessonId ,this.documentURL, this.lessonLearning, this.quizQuestions});

  static List<LessonViewModel> fromListJson(List<dynamic> lessonsJsonList) {
    List<LessonViewModel> lessons = List();

    for(int i = 0 ; i < lessonsJsonList.length ; i++){
      lessons.add(fromJson(lessonsJsonList[i]));
    }
    return lessons;
  }

  static LessonViewModel fromJson(lessonJson) {

    return LessonViewModel(
      lessonId: lessonJson[ApiParseKeys.LESSON_ID] ?? 0,
      documentURL: lessonJson[ApiParseKeys.LESSON_DOC] ?? '',
      flashCards: lessonJson[ApiParseKeys.LESSON_FLASH_CARD] ?? false ,
      lessonLearning: lessonJson[ApiParseKeys.LESSON_LEARNING] ?? '',
      videoURL: lessonJson[ApiParseKeys.LESSON_VIDEO_URL] ?? '',
      quizQuestions: List(),
      lessonNameAr: lessonJson[ApiParseKeys.LESSON_NAME_AR] ?? '',
      quizMark: lessonJson[ApiParseKeys.QUIZ_MARK] ?? 0,
      lessonNameEn: lessonJson[ApiParseKeys.LESSON_NAME_EN] ?? ''
    );



  }
}