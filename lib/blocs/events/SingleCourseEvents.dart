import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/data/models/LessonViewModel.dart';

abstract class SingleCourseEvents {}

class CompleteLesson extends SingleCourseEvents{
  final LessonViewModel lesson;
  CompleteLesson({this.lesson});
}
class SubscribeCourse extends SingleCourseEvents{
  final CourseViewModel course ;
  SubscribeCourse({this.course});
}

class FetchCourseInformation extends SingleCourseEvents{
  final CourseViewModel course ;
  FetchCourseInformation({this.course});
}

