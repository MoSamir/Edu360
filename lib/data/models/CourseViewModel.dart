import 'package:edu360/data/apis/helpers/ApiParseKeys.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/apis/helpers/URL.dart';
import 'package:edu360/data/models/LessonViewModel.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
import 'package:edu360/data/models/StudyFieldViewModel.dart';
import 'package:edu360/utilities/ParserHelpers.dart';

class CourseViewModel {

  String courseTitle ,  courseImage , instructorName;
  DateTime courseStartTime ;
  StudyFieldViewModel courseField ;
  int numberOfLessonsPerWeek , numberOfMonthsLeft  , courseId;
  double feesPerMonth ;
  List<String> targetClasses = List();
  List<String> courseOutcomesEn = List() , courseOutcomesAr = List();
  List<LessonViewModel> courseLessons = List();
  bool isUserSubscribed ;


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseViewModel &&
          runtimeType == other.runtimeType &&
          courseId == other.courseId;

  @override
  int get hashCode => courseId.hashCode;

  CourseViewModel({this.courseTitle, this.isUserSubscribed , this.courseField ,this.courseImage ,this.courseOutcomesEn , this.courseOutcomesAr ,this.targetClasses, this.courseStartTime,
      this.numberOfLessonsPerWeek, this.numberOfMonthsLeft, this.courseId ,this.feesPerMonth , this.instructorName , this.courseLessons});

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

    print("---------Single Course Information => -----------------");
    print(singleCourseJson);
    print("-----------------------------");


    List<String> gradesList = List();
    var target = singleCourseJson[ApiParseKeys.COURSE_GRADE];
    if((target is List ) == false){
      gradesList.add(target.toString());
    }
    else {
      for(int i = 0 ; i < target.length; i++){
        gradesList.add(target[i].toString());
      }
    }

    List<LessonViewModel> courseLessons = List();
    try {
      if (singleCourseJson[ApiParseKeys.COURSE_LESSONS] != null &&
          singleCourseJson[ApiParseKeys.COURSE_LESSONS] is List) {
        courseLessons = LessonViewModel.fromListJson(
            singleCourseJson[ApiParseKeys.COURSE_LESSONS]);
      }
    } catch(exception){
      print("Exception Loading lessons => $exception");
    }




    DateTime courseEndDate = DateTime.parse(singleCourseJson[ApiParseKeys.COURSE_END_DATE] ?? DateTime.now().toString());
    DateTime courseStartDate = DateTime.parse(singleCourseJson[ApiParseKeys.COURSE_START_DATE]?? DateTime.now().toString());

    String imagePath = ParserHelper.parseURL(singleCourseJson[ApiParseKeys.COURSE_IMAGE_PATH])  ?? '';





    return CourseViewModel(
      courseLessons: courseLessons,
      targetClasses: gradesList,
     courseOutcomesEn: (singleCourseJson[ApiParseKeys.COURSE_OUTCOMES_EN]!= null) ? (singleCourseJson[ApiParseKeys.COURSE_OUTCOMES_EN]).split(',') : List(),
     courseOutcomesAr: (singleCourseJson[ApiParseKeys.COURSE_OUTCOMES_AR]!= null ) ?(singleCourseJson[ApiParseKeys.COURSE_OUTCOMES_AR]).split(',') : List(),
      feesPerMonth:   singleCourseJson[ApiParseKeys.COURSE_SUBSCRIPTION_PRICE] ?? 0.0,
      courseId: singleCourseJson[ApiParseKeys.COURSE_ID],
      courseField: StudyFieldViewModel(
        studyFieldNameAr: singleCourseJson[ApiParseKeys.COURSE_TITLE_AR],
        studyFieldNameEn: singleCourseJson[ApiParseKeys.COURSE_TITLE_EN],
      ),
      courseTitle: singleCourseJson[ApiParseKeys.COURSE_NAME_EN],
      courseImage: imagePath,
      isUserSubscribed: singleCourseJson[ApiParseKeys.COURSE_ALREADY_SUBSCRIBED] ?? false,
      instructorName: singleCourseJson[ApiParseKeys.COURSE_TEACHER_NAME],
      courseStartTime: courseStartDate,
      numberOfMonthsLeft: (courseEndDate.difference(courseStartDate).inDays/30).floor(),
      numberOfLessonsPerWeek: 1,
    );
  }
}