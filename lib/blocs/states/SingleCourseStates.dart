import 'package:edu360/blocs/events/SingleCourseEvents.dart';
import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/data/models/ErrorViewModel.dart';

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
