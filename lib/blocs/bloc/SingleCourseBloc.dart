import 'package:edu360/Repository.dart';
import 'package:edu360/blocs/events/SingleCourseEvents.dart';
import 'package:edu360/blocs/states/SingleCourseStates.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
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
    ResponseViewModel<CourseViewModel> fetchCourseInformation = await Repository.getCourseInformation(courseId: event.course.courseId);
    if(fetchCourseInformation.isSuccess){
      courseViewModel = fetchCourseInformation.responseData;
      yield CourseInformationLoaded(course: fetchCourseInformation.responseData);
      return;
    } else {
      yield LoadingCourseFailed(error: fetchCourseInformation.errorViewModel , failureEvent: event);
          return ;
    }

  }
}