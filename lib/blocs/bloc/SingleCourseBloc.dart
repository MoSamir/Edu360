import 'package:edu360/blocs/events/SingleCourseEvents.dart';
import 'package:edu360/blocs/states/SingleCourseStates.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/data/models/StudyFieldViewModel.dart';
import 'package:edu360/utilities/Constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleCourseBloc extends Bloc<SingleCourseEvents , SingleCourseStates>{

  CourseViewModel courseViewModel = CourseViewModel();

  @override
  SingleCourseStates get initialState => CourseLoadingStates();

  @override
  Stream<SingleCourseStates> mapEventToState(SingleCourseEvents event) async*{
    bool isUserConnected = await NetworkUtilities.isConnected();
    if(isUserConnected == false){
      yield LoadingCourseFailed(
        failureEvent: event,
        error: Constants.CONNECTION_TIMEOUT,
      );
      return ;
    }


    if(event is FetchCourseInformation){
      yield* _handleCourseInformationFetching(event);
      return ;
    }
  }

  Stream<SingleCourseStates> _handleCourseInformationFetching(FetchCourseInformation event) async*{
    courseViewModel = event.course;
    yield CourseLoadingStates();
    /// HANDLE FETCHING COURSE FULL INFORMATION AND CACHE IT TO THE COURSE INSTANCE
    Future.delayed(Duration(seconds: 2),(){});

    courseViewModel = CourseViewModel(
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
    );
    yield CourseInformationLoaded(course: courseViewModel);
  }
}