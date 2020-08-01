import 'package:edu360/Repository.dart';
import 'package:edu360/data/models/CourseViewModel.dart';
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
}

