import 'package:edu360/Repository.dart';
import 'package:edu360/blocs/events/SingleCourseEvents.dart';
import 'package:edu360/blocs/states/SingleCourseStates.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/data/models/LessonViewModel.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
import 'package:edu360/data/models/StudyFieldViewModel.dart';
import 'package:edu360/utilities/Constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleCourseBloc extends Bloc<SingleCourseEvents , SingleCourseStates> {

  CourseViewModel courseViewModel = CourseViewModel();

  @override
  SingleCourseStates get initialState => CourseLoadingStates();

  @override
  Stream<SingleCourseStates> mapEventToState(SingleCourseEvents event) async* {
    bool isUserConnected = await NetworkUtilities.isConnected();
    if (isUserConnected == false) {
      yield LoadingCourseFailed(
        failureEvent: event,
        error: Constants.CONNECTION_TIMEOUT,
      );
      return;
    }

    if (event is FetchCourseInformation) {
      yield* _handleCourseInformationFetching(event);
      return;
    }
    else if (event is SubscribeCourse) {
      yield* _handleCourseSubscription(event);
      return;
    } else if (event is CompleteLesson) {
      yield* _handleLessonCompletion(event);
      return;
    } else if (event is FetchLessonInformation) {
      yield* _handleLessonFetchingEvent(event);
      return;
    }
  }

  Stream<SingleCourseStates> _handleCourseInformationFetching(
      FetchCourseInformation event) async* {
    courseViewModel = event.course;
    yield CourseLoadingStates();
    ResponseViewModel<CourseViewModel> fetchCourseInformation = await Repository
        .getCourseInformation(courseId: courseViewModel!= null ? courseViewModel.courseId : event.course.courseId);
    if (fetchCourseInformation.isSuccess) {
      courseViewModel = fetchCourseInformation.responseData;
      yield CourseInformationLoaded(
          course: fetchCourseInformation.responseData);
      return;
    } else {
      yield LoadingCourseFailed(
          error: fetchCourseInformation.errorViewModel, failureEvent: event);
      return;
    }
  }

  Stream<SingleCourseStates> _handleCourseSubscription(
      SubscribeCourse event) async* {
    ResponseViewModel subscriptionResponse = await Repository.subscribeInCourse(
        course: event.course);
    if (subscriptionResponse.isSuccess) {
      yield SubscriptionSuccess();
      return;
    } else {
      yield SubscriptionFailed(
          failureEvent: event, error: subscriptionResponse.errorViewModel);
      return;
    }
  }

  Stream<SingleCourseStates> _handleLessonCompletion(CompleteLesson event) async* {
    yield LessonLoadingState();
    ResponseViewModel<bool> completeLessonResponse = await Repository.completeLesson(lesson:event.lesson , flashCards: event.flashCard , quizGrade: event.quizGrade);
    if(completeLessonResponse.isSuccess){
      yield LessonCompleted();
      return ;
    } else {
      yield LessonCompletionFailed(
        failureEvent: event,
        error: completeLessonResponse.errorViewModel,
      );
      return;
    }
  }

  Stream<SingleCourseStates> _handleLessonFetchingEvent(
      FetchLessonInformation event) async* {

    yield LessonLoadingState();
    ResponseViewModel<LessonViewModel> fetchLessonInformation = await Repository
        .getLessonInformation(lessonId: event.lessonId);
    if (fetchLessonInformation.isSuccess) {
      yield LessonInformationLoaded(
          lesson: fetchLessonInformation.responseData);
      return ;
    } else {
      yield LessonInformationLoadingFailed(
          error: fetchLessonInformation.errorViewModel , failureEvent: event);
      return;
    }
  }
}