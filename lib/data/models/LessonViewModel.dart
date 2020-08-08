import 'package:edu360/data/apis/helpers/ApiParseKeys.dart';
import 'package:edu360/utilities/ParserHelpers.dart';

import 'QuizQuestion.dart';

class LessonViewModel {

  String videoURL , documentURL , lessonLearningAr , lessonLearningEn;
  int lessonId , quizMark ;
  String lessonNameEn, lessonNameAr ;
  bool flashCards , isCompleted;
  List<QuizQuestion> quizQuestions = List();
  List<String> lessonFlashCards = List();

  LessonViewModel({
      this.videoURL, this.quizMark , this.lessonFlashCards, this.lessonLearningAr ,this.isCompleted , this.lessonLearningEn , this.lessonNameAr , this.lessonNameEn ,this.flashCards ,this.lessonId ,this.documentURL,  this.quizQuestions});

  static List<LessonViewModel> fromListJson(List<dynamic> lessonsJsonList) {
    List<LessonViewModel> lessons = List();

    for(int i = 0 ; i < lessonsJsonList.length ; i++){
      lessons.add(fromJson(lessonsJsonList[i]));
    }
    return lessons;
  }

  static LessonViewModel fromJson(lessonJson) {

    List<String> flashCards = List();
    for(int i = 0 ; i < 5 ; i++){
      if(lessonJson['${ApiParseKeys.LESSON_FLASH_CARD}${i+1}'] !=null){
        flashCards.add(lessonJson['${ApiParseKeys.LESSON_FLASH_CARD}${i+1}'].toString());
      }
    }

    List<QuizQuestion> quiz = List();
    if(lessonJson[ApiParseKeys.LESSON_QUIZ_QUESTIONS] is List) {
      quiz.addAll(QuizQuestion.fromListJson(lessonJson[ApiParseKeys.LESSON_QUIZ_QUESTIONS]));
    }


    print("**************************************");
    print("Lesson From Json => $lessonJson");
    print("**************************************");

    return LessonViewModel(
      lessonId: lessonJson[ApiParseKeys.LESSON_ID] ?? 0,
      documentURL: ParserHelper.parseURL(lessonJson[ApiParseKeys.LESSON_DOC]) ?? '',
      flashCards: lessonJson[ApiParseKeys.LESSON_FLASH_CARD] ?? false ,
      lessonLearningEn: lessonJson[ApiParseKeys.LESSON_LEARNING_EN] ?? '',
      lessonLearningAr: lessonJson[ApiParseKeys.LESSON_LEARNING_AR] ?? '',
      videoURL: ParserHelper.parseURL(lessonJson[ApiParseKeys.LESSON_VIDEO_URL]) ?? '',
      isCompleted: lessonJson[ApiParseKeys.LESSON_COMPLETED] ?? false,
      lessonFlashCards: flashCards,
      quizQuestions: quiz,
      lessonNameAr: lessonJson[ApiParseKeys.LESSON_NAME_AR] ?? '',
      quizMark: lessonJson[ApiParseKeys.QUIZ_MARK] ?? 0,
      lessonNameEn: lessonJson[ApiParseKeys.LESSON_NAME_EN] ?? ''
    );



  }
}