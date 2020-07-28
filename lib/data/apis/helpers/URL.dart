class URL{
//  static const String BASE_URL = "http://www.ref360.net:2000"; // server
  static const String BASE_URL = "http://f91b9c4a4be7.ngrok.io"; // local
  static const String API_URL = "$BASE_URL/api/";
  //ar-EG/

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
  static const String GET_GET_USER_POSTS = "Post/GetMyPosts";
  static const String POST_LIKE_POST = "Post/LikePost";
  static const String POST_LIKE_POST_COMMENT = "Post/LikePostComment";
  static const String POST_UNLIKE_POST = "Post/UnLikePost";
  static const String POST_SHARE_POST = "Post/SharePost";
  static const String POST_ADD_COMMENT = "Post/PostComment";
  static const String POST_ADD_OBJECTION = "Post/PostObjection";
  static const String POST_RETRIEVE_COURSES = "Course/GetAllCourseWithStudyField";
  static const String GET_RETRIEVE_SYSTEM_GRADES = "Grade/GetAll";
  static const String GET_FETCH_COURSE_INFORMATION = "Course/GetCourseInformation?courseId=";



}