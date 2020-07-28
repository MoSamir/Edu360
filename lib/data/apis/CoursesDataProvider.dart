import 'package:edu360/Repository.dart';
import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
import 'package:edu360/data/models/UserViewModel.dart';

import 'helpers/ApiParseKeys.dart';
import 'helpers/NetworkUtilities.dart';
import 'helpers/URL.dart';

class CoursesDataProvider{






  static Future<ResponseViewModel<CourseViewModel>> loadStudyFieldCourses(int courseId) async{

    UserViewModel user = await Repository.getUser();
    String userToken = (await Repository.getUser()).userToken;
    var getUserPostsResponse = await NetworkUtilities.handleGetRequest(requestHeaders: NetworkUtilities.getHeaders(customHeaders: {'Authorization' : 'Bearer $userToken'}), methodURL: '${NetworkUtilities.getFullURL(method: URL.GET_FETCH_COURSE_INFORMATION)}/$courseId',parserFunction: (jsonResponse){
      return CourseViewModel.fromJson(jsonResponse[ApiParseKeys.POSTS_DATA]);
    });

    return ResponseViewModel<CourseViewModel>(
      responseData: getUserPostsResponse.responseData,
      isSuccess: getUserPostsResponse.isSuccess,
      errorViewModel: getUserPostsResponse.errorViewModel,
    );
  }


}