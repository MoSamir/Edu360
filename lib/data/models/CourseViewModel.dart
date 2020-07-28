import 'package:edu360/data/apis/helpers/ApiParseKeys.dart';
import 'package:edu360/data/models/LessonViewModel.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
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

  static List<CourseViewModel> fromListJson(List<dynamic> coursesListJson) {
    List<CourseViewModel> coursesList = List();

    if(coursesListJson is List && coursesListJson.length > 0){
      for(int i = 0 ; i < coursesListJson.length ; i++){
        coursesList.add(CourseViewModel.fromJson(coursesListJson[i]));
      }
    }
    return coursesList;
  }
  static CourseViewModel fromJson(singleCourseJson) {
    List<String> gradesList = List();
    var target = singleCourseJson[ApiParseKeys.COURSE_GRADE];

    if((target is List ) == false){
      gradesList.add(target.toString());
    } else {
      for(int i = 0 ; i < target.length; i++){
        gradesList.add(target[i].toString());
      }
    }
    return CourseViewModel(
      targetClasses: gradesList,
      courseId: singleCourseJson[ApiParseKeys.COURSE_ID],
      courseField: StudyFieldViewModel(
        studyFieldNameAr: singleCourseJson[ApiParseKeys.COURSE_TITLE_AR],
        studyFieldNameEn: singleCourseJson[ApiParseKeys.COURSE_TITLE_EN],
      ),
      courseTitle: singleCourseJson[ApiParseKeys.COURSE_NAME_EN],
      courseImage: singleCourseJson[ApiParseKeys.COURSE_IMAGE_PATH],
      instructorName: singleCourseJson[ApiParseKeys.COURSE_TEACHER_NAME],
    );
  }
}