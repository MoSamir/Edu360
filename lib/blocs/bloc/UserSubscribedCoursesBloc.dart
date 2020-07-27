import 'package:edu360/blocs/events/CoursesEvents.dart';
import 'package:edu360/blocs/states/CourseStates.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/data/models/StudyFieldViewModel.dart';
import 'package:edu360/utilities/Constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserSubscribedCoursesBloc extends Bloc<CoursesEvents , CourseStates>{

  List<CourseViewModel> userSubscribedCourses  = List<CourseViewModel>();

  @override
  CourseStates get initialState => UserCoursesLoading();

  @override
  Stream<CourseStates> mapEventToState(CoursesEvents event) async*{
    bool isUserConnected = await NetworkUtilities.isConnected();
    if(isUserConnected == false){
      yield LoadingCoursesFailed(
        failureEvent: event,
        error: Constants.CONNECTION_TIMEOUT,
      );
      return ;
    }
    if(event is LoadUserCourses){
      yield* _handleUserCoursesLoading(event);
      return;
    }
  }

  Stream<CourseStates>  _handleUserCoursesLoading(LoadUserCourses event) async*{
    yield UserCoursesLoading();
    /// HANDLE LOADING USER COURSES HERE GET THE COURSES AND SET IT IN THE CACHED INFORMATION
    await Future.delayed(Duration(seconds: 2),(){});
    userSubscribedCourses.add(CourseViewModel(
      courseField: StudyFieldViewModel(imagePath: '', studyFieldNameEn: 'Computer science' , studyFieldDescAr: 'علوم حاسب' , studyFieldId: 1 ,  studyFieldDescEn: 'Computer science' , studyFieldNameAr: 'Computer science'),
      courseId: 1,
      courseImage: '',
      courseOutcomes: ['Introduction to CS' , 'Introduction to Algorithms' , 'Introduction to Data structures'],
      courseStartTime: DateTime.now(),
      courseTitle: 'Computer Science',
      feesPerMonth: 100.0,
      instructorName: 'Mohamed Samir',
      numberOfLessonsPerWeek: 2,
      numberOfMonthsLeft: 5,
      targetClasses: ['Grade-1','Grade-2' , 'Grade-12' , 'Grade-20'],
    ));



    yield LoadUserSubscribedCoursesLoaded();
    return ;
  }
}