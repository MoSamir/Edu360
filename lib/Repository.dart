import 'dart:io';
import 'package:edu360/data/apis/PostDataProvider.dart';
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

}