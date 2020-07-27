import 'package:edu360/blocs/events/CoursesEvents.dart';
import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/data/models/ErrorViewModel.dart';

abstract class CourseStates {}

class UserCoursesLoading extends CourseStates{}
class LoadUserSubscribedCoursesLoaded extends CourseStates{}
class LoadingCoursesFailed extends CourseStates{
  final ErrorViewModel error;
  final CoursesEvents failureEvent ;
  LoadingCoursesFailed({this.error , this.failureEvent});
}



