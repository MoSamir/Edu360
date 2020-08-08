import 'package:edu360/Repository.dart';
import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/data/models/LessonViewModel.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
import 'package:edu360/data/models/UserViewModel.dart';

import 'helpers/ApiParseKeys.dart';
import 'helpers/NetworkUtilities.dart';
import 'helpers/URL.dart';

class CoursesDataProvider {


  static Future<ResponseViewModel<CourseViewModel>> loadStudyFieldCourses(
      int courseId) async {
    String userToken = (await Repository.getUser()).userToken;
    var getUserPostsResponse = await NetworkUtilities.handleGetRequest(
        requestHeaders: NetworkUtilities.getHeaders(
            customHeaders: {'Authorization': 'Bearer $userToken'}),
        methodURL: '${NetworkUtilities.getFullURL(
            method: URL.GET_FETCH_COURSE_INFORMATION)}$courseId',
        parserFunction: (jsonResponse) {
          return CourseViewModel.fromJson(jsonResponse);
        });

    return ResponseViewModel<CourseViewModel>(
      responseData: getUserPostsResponse.responseData,
      isSuccess: getUserPostsResponse.isSuccess,
      errorViewModel: getUserPostsResponse.errorViewModel,
    );
  }

  static subscribeInCourse(CourseViewModel course) async {
    Map<String, dynamic> requestBody = {
      'courseID': course.courseId,
    };


    String userToken = (await Repository.getUser()).userToken;
    var subscribeResponse = await NetworkUtilities.handlePostRequest(
        requestBody: requestBody,
        requestHeaders: NetworkUtilities.getHeaders(
            customHeaders: {'Authorization': 'Bearer $userToken'}),
        methodURL: NetworkUtilities.getFullURL(
            method: URL.POST_SUBSCRIBE_COURSE),
        parserFunction: (jsonResponse) {} , acceptJson: true);


    return ResponseViewModel<void>(
      errorViewModel: subscribeResponse.errorViewModel,
      isSuccess: subscribeResponse.isSuccess,
      responseData: null,
    );

  }


  static Future<ResponseViewModel<List<CourseViewModel>>> getMySubscribedCourses() async {
    UserViewModel userViewModel  = await Repository.getUser();

    Map<String, dynamic> requestBody = {
      "PageNumber":1,
      "PageSize":10,
      'UserID' : userViewModel.userId,
    };



    String userToken = userViewModel.userToken;
    var subscribeResponse = await NetworkUtilities.handlePostRequest(
        requestBody: requestBody,
        requestHeaders: NetworkUtilities.getHeaders(
            customHeaders: {'Authorization': 'Bearer $userToken'}),
        methodURL: NetworkUtilities.getFullURL(
            method: URL.POST_GET_SUBSCRIBED_COURSES),
        parserFunction: (responseJson){
          return CourseViewModel.fromListJson(responseJson[ApiParseKeys.POSTS_DATA]);
        } , acceptJson: true);

    return ResponseViewModel<List<CourseViewModel>>(
      errorViewModel: subscribeResponse.errorViewModel,
      isSuccess: subscribeResponse.isSuccess,
      responseData: subscribeResponse.responseData,
    );
  }

  static getLessonInformation(int lessonId) async{
    String userToken = (await Repository.getUser()).userToken;
    var getUserPostsResponse = await NetworkUtilities.handleGetRequest(
    requestHeaders: NetworkUtilities.getHeaders(
    customHeaders: {'Authorization': 'Bearer $userToken'}),
    methodURL: '${NetworkUtilities.getFullURL(
    method: URL.GET_FETCH_LESSON_INFORMATION)}$lessonId',
    parserFunction: (jsonResponse) {
    return LessonViewModel.fromJson(jsonResponse);
    });

    return ResponseViewModel<LessonViewModel>(
    responseData: getUserPostsResponse.responseData,
    isSuccess: getUserPostsResponse.isSuccess,
    errorViewModel: getUserPostsResponse.errorViewModel,
    );
  }

  static completeLesson(LessonViewModel lesson, bool flashCards, double quizGrade) async{
    Map<String,dynamic> requestBody = {
      "LessonID":lesson.lessonId,
      "StudentGrade": quizGrade,
      "SendFlashCard": flashCards,
    };
    UserViewModel userViewModel  = await Repository.getUser();

    String userToken = userViewModel.userToken;
    var completeLesson = await NetworkUtilities.handlePostRequest(
        requestBody: requestBody,
        requestHeaders: NetworkUtilities.getHeaders(
            customHeaders: {'Authorization': 'Bearer $userToken'}),
        methodURL: NetworkUtilities.getFullURL(
            method: URL.POST_COMPLETE_LESSON),
        parserFunction: (responseJson){
          return  true ;
        } , acceptJson: true);

    return ResponseViewModel<bool>(
      errorViewModel: completeLesson.errorViewModel,
      isSuccess: completeLesson.isSuccess,
      responseData: completeLesson.responseData,
    );


  }

}

