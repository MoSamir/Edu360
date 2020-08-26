import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/data/models/LessonViewModel.dart';

abstract class SingleCourseEvents {}

class CompleteLesson extends SingleCourseEvents{
  final LessonViewModel lesson;
  final bool flashCard ;
  final double quizGrade;
  CompleteLesson({this.lesson, this.flashCard , this.quizGrade});
}
class SubscribeCourse extends SingleCourseEvents{
  final CourseViewModel course ;
  SubscribeCourse({this.course});
}

class FetchCourseInformation extends SingleCourseEvents{
  final CourseViewModel course ;
  FetchCourseInformation({this.course});
}

class FetchLessonInformation extends SingleCourseEvents{
  final int lessonId ;
  FetchLessonInformation({this.lessonId});
}