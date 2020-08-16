import 'package:edu360/blocs/events/CoursesEvents.dart';
import 'package:edu360/blocs/states/CourseStates.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
import 'package:edu360/data/models/StudyFieldViewModel.dart';
import 'package:edu360/utilities/Constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Repository.dart';

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
    ResponseViewModel<List<CourseViewModel>> getMyCoursesResponse = await Repository.getUserSubscribedCourses();
    if(getMyCoursesResponse.isSuccess){
      print(getMyCoursesResponse.responseData);
      userSubscribedCourses = getMyCoursesResponse.responseData;
    }

    yield LoadUserSubscribedCoursesLoaded();
    return ;
  }
}