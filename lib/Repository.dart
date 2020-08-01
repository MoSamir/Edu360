import 'dart:io';
import 'package:edu360/data/apis/CoursesDataProvider.dart';
import 'package:edu360/data/apis/PostDataProvider.dart';
import 'package:edu360/data/models/CategoryPostViewModel.dart';
import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/data/models/ErrorViewModel.dart';
import 'package:edu360/data/models/GradeViewModel.dart';
import 'package:edu360/data/models/NotificationViewModel.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
import 'package:edu360/data/models/StudyFieldViewModel.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'data/apis/UserDataProvider.dart';
import 'data/models/CommentViewModel.dart';

class Repository {


  static saveUser(UserViewModel user)  async{
    await UserDataProvider.saveUser(user);
  }
  static saveEncryptedPassword(String userPassword) async {
    await Future.delayed(Duration(seconds: 2),()=>{});
  }
  static Future<UserViewModel> getUser() async {
    return await UserDataProvider.getUser();
  }
  static clearCache()async {
     await UserDataProvider.clearUserCache();
     return ;
  }
  static Future<ResponseViewModel<int>> registerUser(UserViewModel user , File profileImage)  async{
    var response = await UserDataProvider.registerUser(user , profileImage);
    return response;
  }
  static Future<ResponseViewModel<List<String>>> uploadFiles(List<File> tobeUploadedFiles , File profileImage) async{
    var response =  await UserDataProvider.uploadFiles(tobeUploadedFiles , profileImage);
    return response;
  }
  static Future<ResponseViewModel<void>>verifyUser({ String userID ,String userVerificationCode})  async{
    var response = await UserDataProvider.verifyUser(userID , userVerificationCode);
    return response;
  }
  static Future<ResponseViewModel<UserViewModel>>login({ String userMail ,String userPassword})  async{
    var response = await UserDataProvider.login(userMail , userPassword);
    return response;
  }
  static Future<ResponseViewModel<bool>>logout({String userId})  async{
    var response = await UserDataProvider.logOut(userId);
    return response;
  }
  static Future<ResponseViewModel<List<StudyFieldViewModel>>>getFieldsOfStudy() async{
    var response = await UserDataProvider.loadFieldsOfStudy();
    return response;
  }
  static Future<ResponseViewModel<void>> createPost({PostViewModel userPost}) async{
    var createPostResponse = await PostDataProvider.createUserPost(userPost);
    return createPostResponse;
  }

  static likePost({int postId}) async{
    var createPostResponse = await PostDataProvider.likePost(postId);
    return createPostResponse;
  }
  static likeComment({int postCommentId}) async{
    var likeCommentResponse = await PostDataProvider.likeComment(postCommentId);
    return likeCommentResponse;
  }
  static unLikePost({int postId}) async{
    var createPostResponse = await PostDataProvider.likePost(postId);
    return createPostResponse;
  }
  static uploadPostFiles(List<File> postDocuments) async{
    var response = await PostDataProvider.uploadPostFiles(postDocuments);
    return response;
  }
  static createPostWithMedia({PostViewModel userPost, List<String> postFilesPath}) async{

    var createPostResponse = await PostDataProvider.createUserPost(userPost ,uploadedFiles:  postFilesPath);
    return createPostResponse;


  }
  static loadUserProfile({int pageNo}) async{
    var loadUserProfileResponse = await UserDataProvider.loadUserPosts(pageNo ?? 1);
    return loadUserProfileResponse;
  }

  static addComment({int postId , CommentViewModel comment}) async{
    var loadUserProfileResponse = await PostDataProvider.postComment(postId , comment);
    return loadUserProfileResponse;
  }
  static addObjection({int postId , CommentViewModel comment}) async{
    var loadUserProfileResponse = await PostDataProvider.postObjection(postId , comment);
    return loadUserProfileResponse;
  }
  static sharePost({int postId , String shareDescription}) async{
    var loadUserProfileResponse = await PostDataProvider.sharePost(postId , shareDescription);
    return loadUserProfileResponse;
  }

  static Future<ResponseViewModel<List<CategoryPostViewModel>> >loadUserCategories() async{
   await Future.delayed(Duration(seconds: 1),(){});

   return ResponseViewModel<List<CategoryPostViewModel>>(
     responseData: [CategoryPostViewModel(
       studyField: StudyFieldViewModel(
         studyFieldNameEn: 'Category Name',
         imagePath: null,
       ),
     ),CategoryPostViewModel(
       studyField: StudyFieldViewModel(
         studyFieldNameEn: 'Category Name',
         imagePath: null,
       ),
     ),CategoryPostViewModel(
       studyField: StudyFieldViewModel(
         studyFieldNameEn: 'Category Name',
         imagePath: null,
       ),
     ),],
     isSuccess: true,
   );
  }

  static Future<ResponseViewModel<List<CommentViewModel>>>getPostComments({PostViewModel post}) async {
    await Future.delayed(Duration(seconds: 1), (){});
    return ResponseViewModel<List<CommentViewModel>>(
      responseData: [
        CommentViewModel(
          ownerId: 1,
          ownerName: 'User',
          commentText: 'Hello Dummy comment',
          likesCount: 1,
          commentId: 1,
          ownerImagePath: '',
        ), CommentViewModel(
          ownerId: 2,
          ownerName: 'User 2',
          commentText: 'Hello Dummy comment 22',
          likesCount: 2,
          commentId: 2,
          ownerImagePath: '',
        ),
        CommentViewModel(
          ownerId: 3,
          ownerName: 'User 2',
          commentText: 'Hello Dummy comment 23432',
          likesCount: 0,
          commentId: 3,
          ownerImagePath: '',
        )
      ],
      isSuccess: true,
      errorViewModel: null,
    );
  }

  static Future<ResponseViewModel<List<NotificationViewModel>>>loadUserNotifications({int pageNo}) async{
    Future.delayed(Duration(seconds: 1),(){});

    if(pageNo == 1 ){
      return ResponseViewModel<List<NotificationViewModel>>(
        responseData: [
          NotificationViewModel(
            notificationBody: 'You Liked me',
            notificationId: 1,
            notificationURL: '',
          ),
          NotificationViewModel(
            notificationBody: 'You Liked me',
            notificationId: 1,
            notificationURL: 'https://img.icons8.com/material/4ac144/256/user-male.png',
          ),
          NotificationViewModel(
            notificationBody: 'You Liked me',
            notificationId: 1,
            notificationURL: '',
          ),
          NotificationViewModel(
            notificationBody: 'You Liked me',
            notificationId: 1,
            notificationURL: '',
          ),
          NotificationViewModel(
            notificationBody: 'You Liked me',
            notificationId: 1,
            notificationURL: '',
          ),
          NotificationViewModel(
            notificationBody: 'You Liked me',
            notificationId: 1,
            notificationURL: '',
          ),
          NotificationViewModel(
            notificationBody: 'You Liked me',
            notificationId: 1,
            notificationURL: '',
          ),
          NotificationViewModel(
            notificationBody: 'You Liked me',
            notificationId: 1,
            notificationURL: '',
          ),
          NotificationViewModel(
            notificationBody: 'You Liked me',
            notificationId: 1,
            notificationURL: '',
          ),
          NotificationViewModel(
            notificationBody: 'You Liked me',
            notificationId: 1,
            notificationURL: '',
          ),
        ],
        isSuccess: true,
        errorViewModel: null,
      );
    } else {
      return ResponseViewModel<List<NotificationViewModel>>(
        responseData: null,
        isSuccess: false,
        errorViewModel: ErrorViewModel(
          errorCode: 99,
          errorMessage: "No More Notifications Enough please",
        ),
      );
    }
  }


  static Future<ResponseViewModel<List<UserViewModel>>>loadStudyFieldTeachers() async => await UserDataProvider.loadStudyFieldTeachers();
  static Future<ResponseViewModel<List<UserViewModel>>>loadStudyFieldUsers() async => await UserDataProvider.loadStudyFieldUsers();

  static Future<ResponseViewModel<List<PostViewModel>>>loadStudyFieldPosts() async => await UserDataProvider.loadStudyFieldPosts();
  static Future<ResponseViewModel<List<CourseViewModel>>>loadStudyFieldCourses() async => await UserDataProvider.loadStudyFieldCourses();
  static Future<ResponseViewModel<List<GradeViewModel>>> getSystemGradesList() async  => await UserDataProvider.loadSystemGrades();

  static Future<ResponseViewModel<CourseViewModel>> getCourseInformation({int courseId}) async  => await CoursesDataProvider.loadStudyFieldCourses(courseId);

  static Future<ResponseViewModel<void>> subscribeInCourse({CourseViewModel course})  async  => await CoursesDataProvider.subscribeInCourse(course);

  static Future<ResponseViewModel<void>>followUser({int userId}) async => await UserDataProvider.followUser(userId);
  static Future<ResponseViewModel<void>> unfollowUser({int userId}) async => await UserDataProvider.unfollowUser(userId);

}