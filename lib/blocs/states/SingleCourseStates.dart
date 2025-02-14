import 'package:edu360/blocs/events/SingleCourseEvents.dart';
import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/data/models/ErrorViewModel.dart';
import 'package:edu360/data/models/LessonViewModel.dart';

abstract class SingleCourseStates {}
class CourseLoadingStates extends SingleCourseStates{}

class LoadingCourseFailed extends SingleCourseStates{
  final ErrorViewModel error;
  final SingleCourseEvents failureEvent ;
  LoadingCourseFailed({this.error , this.failureEvent});
}
class CourseInformationLoaded extends SingleCourseStates{
  final CourseViewModel course;
  CourseInformationLoaded({this.course});
}




class LessonInformationLoaded extends SingleCourseStates{
  final LessonViewModel lesson;
  LessonInformationLoaded({this.lesson});
}

class LessonInformationLoadingFailed extends SingleCourseStates{
  final ErrorViewModel error;
  final SingleCourseEvents failureEvent ;
  LessonInformationLoadingFailed({this.error , this.failureEvent});
}

class SubscriptionSuccess extends SingleCourseStates{}
class SubscriptionFailed extends SingleCourseStates{

  final ErrorViewModel error;
  final SingleCourseEvents failureEvent ;
  SubscriptionFailed({this.error , this.failureEvent});
}

class LessonCompleted extends SingleCourseStates{}
class LessonLoadingState extends SingleCourseStates{}
class LessonCompletionFailed extends SingleCourseStates{
  final ErrorViewModel error;
  final SingleCourseEvents failureEvent ;
  LessonCompletionFailed({this.error , this.failureEvent});
}