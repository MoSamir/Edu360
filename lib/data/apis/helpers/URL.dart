import 'package:edu360/utilities/Constants.dart';

class URL{
//  static const String BASE_URL = "http://www.ref360.net:2000"; // server
//  static const String BASE_URL = "http://aeb67a340aa1.ngrok.io"; // local
  static const String BASE_URL = "http://161.97.87.130:2001"; // testing
  static const String ENGLISH_API_URL = "$BASE_URL/api/";
  static const String ARABIC_API_URL = "$BASE_URL/ar-EG/api/";

  static const String POST_CREATE_USER = "User/CreateUser";
  static const String POST_UPLOAD_FILES = "User/UploadFiles";
  static const String POST_VERIFY_USER = "User/VerifyUser";
  static const String POST_LOGIN = "User/Login";
  static const String GET_LOGOUT = "User/Logout";
  static const String POST_UPDATE_PROFILE_IMAGE = "User/UpdateProfileImage";
  static const String POST_UPDATE_PROFILE = "User/UpdateUserProfile";
  static const String POST_PEOPLE_WITH_STUDY_FIELD = "User/GetAllPeopleWithStudyField";
  static const String GET_RETRIEVE_FIELDS_OF_STUDY = "FieldOfStudy/GetAll";
  static const String POST_CREATE_POST = "Post/CreatePost";
  static const String POST_UPLOAD_POST_FILES = "Post/UploadAttachedFiles";
  static const String GET_GET_USER_POSTS = "Post/GetMyPosts"; // profile
  static const String POST_GET_EXPLORE_POSTS = "Post/GetExplorePostsWithPagination";
  static const String POST_LOAD_POSTS = "Post/GetAllPostsWithPagination"; // explore
  static const String POST_GET_SUBSCRIBED_COURSES = "Course/GetMySubscribedCourses";
  static const String POST_LIKE_POST = "Post/LikePost";
  static const String POST_LIKE_POST_COMMENT = "Post/LikePostComment";
  static const String POST_UNLIKE_POST = "Post/UnLikePost";
  static const String POST_SHARE_POST = "Post/SharePost";
  static const String POST_ADD_COMMENT = "Post/PostComment";
  static const String POST_ADD_OBJECTION = "Post/PostObjection";
  static const String POST_RETRIEVE_COURSES = "Course/GetAllCourseWithStudyField";
  static const String GET_RETRIEVE_SYSTEM_GRADES = "Grade/GetAll";
  static const String GET_FETCH_COURSE_INFORMATION = "Course/GetCourseInformation?courseId=";
  static const String GET_FETCH_LESSON_INFORMATION = "Lesson/GetLessonDetails?lessonId=";
  static const String POST_SUBSCRIBE_COURSE = "Subscription/SubscribeCourse";
  static const String POST_FOLLOW_USER = "Follower/Follow";
  static const String POST_UNFOLLOW_USER = "Follower/UnFollow";
  static const String GET_LOAD_USER_PROFILE = "User/LoadUserProfile";
  static const String POST_GET_USER_POSTS = "Post/GetUserPosts"; // public profile posts
  static const String POST_COMPLETE_LESSON = "Lesson/CompleteLesson";
  static const String POST_RETRIEVE_POST_COMMENTS = "Post/GetPostComments/";
  static const String POST_DELETE_POST = "Post/DeletePost?id=";
}