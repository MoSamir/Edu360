import 'package:edu360/data/models/LessonViewModel.dart';
import 'package:edu360/data/models/StudyFieldViewModel.dart';

class CourseViewModel {

  String courseTitle ,  courseImage , instructorName;
  DateTime courseStartTime ;
  StudyFieldViewModel courseField ;
  int numberOfLessonsPerWeek , numberOfMonthsLeft  , courseId;
  double feesPerMonth ;
  List<String> targetClasses = List();
  List<String> courseOutcomes = List();
  List<LessonViewModel> courseLessons = List();

  CourseViewModel({this.courseTitle,  this.courseField ,this.courseImage ,this.courseOutcomes ,this.targetClasses, this.courseStartTime,
      this.numberOfLessonsPerWeek, this.numberOfMonthsLeft, this.courseId ,this.feesPerMonth , this.instructorName});
}