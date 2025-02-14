import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:edu360/Repository.dart';
import 'package:edu360/data/apis/helpers/ApiParseKeys.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/apis/helpers/URL.dart';
import 'package:edu360/data/models/IssueModel.dart';
import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/data/models/ErrorViewModel.dart';
import 'package:edu360/data/models/GradeViewModel.dart';
import 'package:edu360/data/models/PaymentMethodModel.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
import 'package:edu360/data/models/StudyFieldViewModel.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/utilities/Constants.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/ParserHelpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDataProvider {
  static Future<ResponseViewModel<List<String>>> uploadFiles(
      List<File> tobeUploadedFiles, File profileImage) async {
    List<MultipartFile> files = List();

    for (int i = 0; i < tobeUploadedFiles.length; i++) {
      String fileName = tobeUploadedFiles[i]
          .path
          .split("/")[tobeUploadedFiles[i].path.split("/").length - 1];
      files.add(MultipartFile.fromFileSync(tobeUploadedFiles[i].path,
          filename: fileName));
    }

    Map filesMap = Map<String,dynamic>();
    filesMap.putIfAbsent("files", () => files);
    if(profileImage != null){
      String profileImageName = profileImage.path.split("/")[profileImage.path.split("/").length - 1];
      filesMap.putIfAbsent("ProfileImage" , () => MultipartFile.fromFileSync(profileImage.path,
      filename: profileImageName));
    }

    FormData formData = FormData.fromMap(filesMap);

    ResponseViewModel uploadFiles = await NetworkUtilities.handleFilesUploading(
        formData: formData,
        requestHeaders: NetworkUtilities.getHeaders(),
        methodURL: NetworkUtilities.getFullURL(method: URL.POST_UPLOAD_FILES),
        parserFunction: (responseJson) {
          try{
            List<String> urls = List<String>();
            for(int i = 0 ; i <responseJson.length ; i++)
              urls.add(responseJson[i].toString());
            print(urls.length);
            return urls;

          }catch(exception){
            print("Exception Happened While parsing URLs => $exception");
            return List<String>();
          }
        });
    return ResponseViewModel<List<String>>(
      responseData: uploadFiles.responseData,
      isSuccess: uploadFiles.isSuccess,
      errorViewModel: uploadFiles.errorViewModel,
    );
  }

  static Future<ResponseViewModel<int>> registerUser(
      UserViewModel userModel, File profileImage) async {
    var json = {
      "ProfileImagePath": userModel.profileImagePath,
      "FullName": userModel.userFullName,
      "Email": userModel.userEmail,
      "Password": userModel.userPassword,
      "Mobile": userModel.userMobileNumber,
      "Education": userModel.userEducation,
      "FieldOfStudyID": userModel.userFieldOfStudy.studyFieldId,
      "BirthDate": userModel.userBirthDay.toString(),
      "Agee": userModel.userAge ?? 0,
      "UploadedFilesPaths": userModel.userFiles,
    };
    ResponseViewModel createUserResponse = await NetworkUtilities.handlePostRequest(
        acceptJson: true,
        methodURL: NetworkUtilities.getFullURL(method: URL.POST_CREATE_USER),
        requestHeaders: NetworkUtilities.getHeaders(),
        requestBody: json,
        parserFunction: (jsonResponse) {
          return jsonResponse[ApiParseKeys.ID];
        });
    return ResponseViewModel<int>(
      errorViewModel: createUserResponse.errorViewModel,
      isSuccess: createUserResponse.isSuccess,
      responseData: createUserResponse.responseData
    );
  }

  static Future<ResponseViewModel<void>> verifyUser(
      String userId, String userVerification) async {
    var json = {
      "UserID": int.parse(userId),
      "VerificationCode": int.parse(userVerification),
    };
    ResponseViewModel verificationResponse = await NetworkUtilities.handlePostRequest(
        acceptJson: true,
        methodURL: NetworkUtilities.getFullURL(method: URL.POST_VERIFY_USER),
        requestHeaders: NetworkUtilities.getHeaders(),
        requestBody: json,
        parserFunction: (jsonResponse) {
          print(jsonResponse);
        });
    return ResponseViewModel<void>(
      responseData: verificationResponse.responseData,
      isSuccess: verificationResponse.isSuccess,
      errorViewModel: verificationResponse.errorViewModel,
    );

  }


  static Future<ResponseViewModel<UserViewModel>> login(String userName, String password) async {
    var json = {
      "UserName": userName,
      "Password": password,
    };

    var loginResponse = await NetworkUtilities.handlePostRequest(
        acceptJson: true,
        methodURL: NetworkUtilities.getFullURL(method: URL.POST_LOGIN),
        requestHeaders: NetworkUtilities.getHeaders(),
        requestBody: json,
        parserFunction: (jsonResponse) {
          print("**************Login*************************");
          print(jsonResponse);
          print("*************End of Login**************************");

          return UserViewModel.fromJson(jsonResponse);
        });

    return ResponseViewModel<UserViewModel>(
      responseData: loginResponse.responseData,
      isSuccess: loginResponse.isSuccess,
      errorViewModel: loginResponse.errorViewModel,
    );

  }

  static Future<ResponseViewModel<bool>> logOut(String userId) async {
    var logoutResponse = await NetworkUtilities.handleGetRequest(
        methodURL:
            '${NetworkUtilities.getFullURL(method: URL.GET_LOGOUT)}?UserID=$userId',
        requestHeaders: NetworkUtilities.getHeaders(),
        parserFunction: (jsonResponse) {
          print(jsonResponse);
        });
    return ResponseViewModel<bool>(
      responseData: logoutResponse.responseData,
      isSuccess: logoutResponse.isSuccess,
      errorViewModel: logoutResponse.errorViewModel,
    );
  }


  static Future<UserViewModel> getUser() async{
    SharedPreferences mSharedPreference = await SharedPreferences.getInstance();
    var userJson = mSharedPreference.getString(Constants.SHARED_PREFERENCE_USER_KEY);

    if(userJson == null){
      return UserViewModel.fromAnonymousUser();
    } else {
      UserViewModel userViewModel = UserViewModel.fromJson(json.decode(userJson));
      return userViewModel;
    }
  }

  static saveUserToken(String userToken)async{
    SharedPreferences mSharedPreference = await SharedPreferences.getInstance();
    mSharedPreference.setString(Constants.SHARED_PREFERENCE_USER_TOKEN_KEY, userToken);
  }


  static void saveUserPassword(String userPassword) async{
    SharedPreferences mSharedPreference = await SharedPreferences.getInstance();
    mSharedPreference.setString(Constants.SHARED_PREFERENCE_USER_PASSWORD, userPassword);
  }


  static getUserToken()async{
    SharedPreferences mSharedPreference = await SharedPreferences.getInstance();
    return mSharedPreference.getString(Constants.SHARED_PREFERENCE_USER_TOKEN_KEY);
  }

  static saveUser(UserViewModel userViewModel) async {
    SharedPreferences mSharedPreference = await SharedPreferences.getInstance();
    mSharedPreference.setString(Constants.SHARED_PREFERENCE_USER_KEY, json.encode(userViewModel.toJson()));
    await saveUserToken(userViewModel.userToken);
  }

  static clearUserCache() async {
    SharedPreferences mSharedPreference = await SharedPreferences.getInstance();
    await mSharedPreference.clear();
  }

  static loadFieldsOfStudy() async{
    var getFieldsOfStudyResponse = await NetworkUtilities.handleGetRequest(requestHeaders: NetworkUtilities.getHeaders(), methodURL: NetworkUtilities.getFullURL(method: URL.GET_RETRIEVE_FIELDS_OF_STUDY), parserFunction: StudyFieldViewModel.fromListJson);
    return ResponseViewModel<List<StudyFieldViewModel>>(
      responseData: getFieldsOfStudyResponse.responseData,
      isSuccess: getFieldsOfStudyResponse.isSuccess,
      errorViewModel: getFieldsOfStudyResponse.errorViewModel,
    );
  }

  static loadUserPosts(int pageNo) async{
    Map<String,dynamic> postMap = {
      'PageNumber': pageNo,
      'PageSize' : 100,
    };
    String userToken = (await Repository.getUser()).userToken;

    var getUserPostsResponse = await NetworkUtilities.handlePostRequest(acceptJson: true, requestBody: postMap ,requestHeaders: NetworkUtilities.getHeaders(customHeaders: {'Authorization' : 'Bearer $userToken'}), methodURL: NetworkUtilities.getFullURL(method: URL.GET_GET_USER_POSTS),parserFunction: (postsJson){
      return PostViewModel.fromListJson(postsJson[ApiParseKeys.POSTS_DATA]);
    });


    return ResponseViewModel<List<PostViewModel>>(
      responseData: getUserPostsResponse.responseData,
      isSuccess: getUserPostsResponse.isSuccess,
      errorViewModel: getUserPostsResponse.errorViewModel,
    );
  }

  static Future<ResponseViewModel<List<CourseViewModel>>> loadStudyFieldCourses() async{

    UserViewModel user = await getUser();
    Map<String,dynamic> postMap = {
      'PageNumber': 1,
      'PageSize' : 100,
      'UserType' : -1,
      'GradeId' : -1,
      'FieldOfStudyID':  -1 , //user.userFieldOfStudy.studyFieldId ,
    };
    String userToken = (await Repository.getUser()).userToken;
    var getUserPostsResponse = await NetworkUtilities.handlePostRequest(acceptJson: true, requestBody: postMap ,requestHeaders: NetworkUtilities.getHeaders(customHeaders: {'Authorization' : 'Bearer $userToken'}), methodURL: NetworkUtilities.getFullURL(method: URL.POST_RETRIEVE_COURSES),parserFunction: (jsonResponse){
      return CourseViewModel.fromListJson(jsonResponse[ApiParseKeys.POSTS_DATA]);
    });


    return ResponseViewModel<List<CourseViewModel>>(
      responseData: getUserPostsResponse.responseData,
      isSuccess: getUserPostsResponse.isSuccess,
      errorViewModel: getUserPostsResponse.errorViewModel,
    );
  }

  static Future<ResponseViewModel<List<UserViewModel>>> loadStudyFieldUsers() async{

    UserViewModel user = await getUser();
    Map<String,dynamic> postMap = {
      'PageNumber': 1,
      'PageSize' : 100,
      'UserType' : 0,
      'FieldOfStudyID':  -1 , //user.userFieldOfStudy.studyFieldId,
    };
    String userToken = (await Repository.getUser()).userToken;

    var getUserPostsResponse = await NetworkUtilities.handlePostRequest(acceptJson: true, requestBody: postMap ,requestHeaders: NetworkUtilities.getHeaders(customHeaders: {'Authorization' : 'Bearer $userToken'}), methodURL: NetworkUtilities.getFullURL(method: URL.POST_PEOPLE_WITH_STUDY_FIELD),parserFunction: (usersJson){
      print("usersJson => ${ usersJson[ApiParseKeys.POSTS_DATA]}");
      return UserViewModel.fromListJson(usersJson[ApiParseKeys.POSTS_DATA]);
    });
    return ResponseViewModel<List<UserViewModel>>(
      responseData: getUserPostsResponse.responseData,
      isSuccess: getUserPostsResponse.isSuccess,
      errorViewModel: getUserPostsResponse.errorViewModel,
    );
  }

  static Future<ResponseViewModel<List<UserViewModel>>> loadStudyFieldTeachers() async{
    UserViewModel user = await getUser();
    Map<String,dynamic> postMap = {
      'PageNumber': 1,
      'PageSize' : 100,
      'UserType' : 1,
      'FieldOfStudyID':  -1 , //user.userFieldOfStudy.studyFieldId,
    };
    String userToken = (await Repository.getUser()).userToken;
    var getUserPostsResponse = await NetworkUtilities.handlePostRequest(acceptJson: true, requestBody: postMap ,requestHeaders: NetworkUtilities.getHeaders(customHeaders: {'Authorization' : 'Bearer $userToken'}), methodURL: NetworkUtilities.getFullURL(method: URL.POST_PEOPLE_WITH_STUDY_FIELD),parserFunction: (teachersJson){
      print("teachersJson => ${teachersJson[ApiParseKeys.POSTS_DATA]}");
      return UserViewModel.fromListJson(teachersJson[ApiParseKeys.POSTS_DATA]);
    });
    return ResponseViewModel<List<UserViewModel>>(
      responseData: getUserPostsResponse.responseData,
      isSuccess: getUserPostsResponse.isSuccess,
      errorViewModel: getUserPostsResponse.errorViewModel,
    );
  }

  static Future<ResponseViewModel<List<PostViewModel>>> loadHomePagePosts() async{
    UserViewModel user = await getUser();
    Map<String,dynamic> postMap = {
      'PageNumber': 1,
      'PageSize' : 100,
      'UserType' : 1,
      'FieldOfStudyID':  -1 , // user.userFieldOfStudy.studyFieldId,
    };
    String userToken = (await Repository.getUser()).userToken;
    var getUserPostsResponse = await NetworkUtilities.handlePostRequest(acceptJson: true, requestBody: postMap ,requestHeaders: NetworkUtilities.getHeaders(customHeaders: {'Authorization' : 'Bearer $userToken'}), methodURL: NetworkUtilities.getFullURL(method: URL.POST_LOAD_POSTS),parserFunction: (teachersJson){
      print("teachersJson => ${teachersJson[ApiParseKeys.POSTS_DATA]}");
      return PostViewModel.fromListJson(teachersJson[ApiParseKeys.POSTS_DATA]);
    });
    return ResponseViewModel<List<PostViewModel>>(
      responseData: getUserPostsResponse.responseData,
      isSuccess: getUserPostsResponse.isSuccess,
      errorViewModel: getUserPostsResponse.errorViewModel,
    );
  }

  static Future<ResponseViewModel<List<GradeViewModel>>> loadSystemGrades() async{


    var getGradesResponse = await NetworkUtilities.handleGetRequest(requestHeaders: NetworkUtilities.getHeaders(), methodURL: NetworkUtilities.getFullURL(method: URL.GET_RETRIEVE_SYSTEM_GRADES), parserFunction: GradeViewModel.fromListJson);
    return ResponseViewModel<List<GradeViewModel>>(
      responseData: getGradesResponse.responseData,
      isSuccess: getGradesResponse.isSuccess,
      errorViewModel: getGradesResponse.errorViewModel,
    );
  }

  static unfollowUser(int userId) async{
    Map<String,dynamic> requestBody = {
      'UserID' : userId,
    };

    String userToken = (await Repository.getUser()).userToken;
    ResponseViewModel unFollowResponse = await NetworkUtilities.handlePostRequest(
      parserFunction: (json){},
      methodURL: NetworkUtilities.getFullURL(method: URL.POST_UNFOLLOW_USER),
      requestHeaders: NetworkUtilities.getHeaders(
          customHeaders: {'Authorization': 'Bearer $userToken'}),
      requestBody:requestBody,
      acceptJson: true,
    );

    return ResponseViewModel<void>(
      responseData: null,
      isSuccess: unFollowResponse.isSuccess,
      errorViewModel: unFollowResponse.errorViewModel,
    );
  }

  static followUser(int userId) async{

    Map<String,dynamic> requestBody = {
      'UserID' : userId,
    };

    String userToken = (await Repository.getUser()).userToken;
    ResponseViewModel followResponse = await NetworkUtilities.handlePostRequest(
      parserFunction: (json){},
      acceptJson: true,
      methodURL: NetworkUtilities.getFullURL(method: URL.POST_FOLLOW_USER),
      requestHeaders: NetworkUtilities.getHeaders(
          customHeaders: {'Authorization': 'Bearer $userToken'}),
      requestBody:requestBody,
    );

    return ResponseViewModel<void>(
      responseData: null,
      isSuccess: followResponse.isSuccess,
      errorViewModel: followResponse.errorViewModel,
    );
  }

  static loadUserProfile(int id, int i) async{
    String userToken = (await Repository.getUser()).userToken;
    var logoutResponse = await NetworkUtilities.handleGetRequest(
        methodURL:
        '${NetworkUtilities.getFullURL(method: URL.GET_LOAD_USER_PROFILE)}?UserID=$id',
      requestHeaders: NetworkUtilities.getHeaders(
          customHeaders: {'Authorization': 'Bearer $userToken'}),
        parserFunction: (userJson){
         return UserViewModel.fromJson(userJson);
        },
    );
    return ResponseViewModel<UserViewModel>(
      responseData: logoutResponse.responseData,
      isSuccess: logoutResponse.isSuccess,
      errorViewModel: logoutResponse.errorViewModel,
    );



  }


  static loadSingleUserPosts(int id ,{int pageNo}) async{
    Map<String,dynamic> postMap = {
      'PageNumber': pageNo ?? 1,
      'PageSize' : 100,
      'UserID':id,
    };
    String userToken = (await Repository.getUser()).userToken;
    var getUserPostsResponse = await NetworkUtilities.handlePostRequest(acceptJson: true, requestBody: postMap ,requestHeaders: NetworkUtilities.getHeaders(customHeaders: {'Authorization' : 'Bearer $userToken'}), methodURL: NetworkUtilities.getFullURL(method: URL.POST_GET_USER_POSTS),parserFunction: (postsJson){
      return PostViewModel.fromListJson(postsJson[ApiParseKeys.POSTS_DATA]);
    });
    return ResponseViewModel<List<PostViewModel>>(
      responseData: getUserPostsResponse.responseData,
      isSuccess: getUserPostsResponse.isSuccess,
      errorViewModel: getUserPostsResponse.errorViewModel,
    );
  }

  static loadStudyFieldPosts() async{
    UserViewModel user = await getUser();
    Map<String,dynamic> postMap = {
      'PageNumber': 1,
      'PageSize' : 100,
      'UserType' : 1,
      'FieldOfStudyID':  -1 , // user.userFieldOfStudy.studyFieldId,
    };
    String userToken = (await Repository.getUser()).userToken;
    var getUserPostsResponse = await NetworkUtilities.handlePostRequest(acceptJson: true, requestBody: postMap ,requestHeaders: NetworkUtilities.getHeaders(customHeaders: {'Authorization' : 'Bearer $userToken'}), methodURL: NetworkUtilities.getFullURL(method: URL.POST_GET_EXPLORE_POSTS),parserFunction: (postsJson){
    return PostViewModel.fromListJson(postsJson[ApiParseKeys.POSTS_DATA]);
    });
    return ResponseViewModel<List<PostViewModel>>(
    responseData: getUserPostsResponse.responseData,
    isSuccess: getUserPostsResponse.isSuccess,
    errorViewModel: getUserPostsResponse.errorViewModel,
    );
  }

  static Future<ResponseViewModel<bool>> updateProfileImage(File userImage) async{
    UserViewModel loggedInUser = await Repository.getUser();
    String fileName = userImage.path.split("/")[userImage.path.split("/").length - 1];
    MultipartFile imageAsMultipartFile = MultipartFile.fromFileSync(userImage.path, filename: fileName);
    Map filesMap = Map<String,dynamic>();
    filesMap.putIfAbsent("profileImagePath", () => imageAsMultipartFile);
    filesMap.putIfAbsent("UserID", () => loggedInUser.userId);

    FormData formData = FormData.fromMap(filesMap);

    ResponseViewModel uploadFiles = await NetworkUtilities.handleFilesUploading(
        formData: formData,
        requestHeaders: NetworkUtilities.getHeaders(customHeaders:  NetworkUtilities.getHeaders(customHeaders: {'Authorization' : 'Bearer ${loggedInUser.userToken}'})),
        methodURL: NetworkUtilities.getFullURL(method: URL.POST_UPDATE_PROFILE_IMAGE),
        parserFunction: (responseJson) {
          try{
            if(responseJson is List){
              return ParserHelper.parseURL(responseJson[0].toString());
            } else {
                return responseJson[0].toString();
            }
          }catch(exception){
            print("Exception Happened While parsing URLs => $exception");
            return List<String>();
          }
        });
    return ResponseViewModel<bool>(
      responseData: uploadFiles.isSuccess,
      isSuccess: uploadFiles.isSuccess,
      errorViewModel: uploadFiles.errorViewModel,
    );
  }

  static requestPhoneAuth({String phoneNumber, Function onTimeout, Function onAuthComplete, Function onAuthFail, Function onCodeSent}) {

    FirebaseAuth.instance.verifyPhoneNumber(phoneNumber: phoneNumber, verificationCompleted: (AuthCredential credentials){
      onAuthComplete(credentials);
      return;
    }, verificationFailed: (FirebaseAuthException exception){
      onAuthFail(exception);
      return;
    }, codeSent: (String tokenId , int foreResend){
      onCodeSent(tokenId);
      return ;
    }, codeAutoRetrievalTimeout: (String tokenId){
      onTimeout(tokenId);
      return;
    });


  }

  static Future<ResponseViewModel<bool>> verifyPhoneCode(String code , String authenticationId) async{

    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: authenticationId,
      smsCode: code,
    );

    try{
      final User user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      return ResponseViewModel<bool>(
        isSuccess: user != null,
        responseData: user != null,
        errorViewModel: user == null ? ErrorViewModel(
          errorMessage: (LocalKeys.INVALID_AUTH_CODE).tr(),
        ) : null,
      );
    } catch(authException){

      FirebaseAuthException outerException = authException as FirebaseAuthException;

      print("Exception => ${outerException.code}");

      String errorMessage = "";
      try{
        if(outerException.code.contains('invalid-verification-code')){
          errorMessage = (LocalKeys.INVALID_AUTH_CODE).tr();
        }
        else if(outerException.code.contains('too-many-requests')){
          errorMessage = (LocalKeys.PHONE_NUMBER_IS_BLOCKED).tr();
        }
        else {
          errorMessage = (LocalKeys.INVALID_PHONE_NUMBER).tr();
        }
      } catch(innerException){
        print("Exception-1 $outerException");
        print("Exception-2 $innerException");
      }

      print("Error Message => $errorMessage");

      return ResponseViewModel<bool>(
        isSuccess: false,
        responseData: null,
        errorViewModel: ErrorViewModel(
          errorCode: 320,
          errorMessage: errorMessage,
        ),
      );
    }
  }

  static Future<ResponseViewModel<bool>> contactUs(IssueModel userIssue) async{

    Map<String , dynamic> requestBody = {
      'FullName' : userIssue.issuerName,
      'Email' : userIssue.issuerMail,
      'Mobile' : userIssue.issuerPhoneNumber,
      'Subject' : userIssue.issueTitle,
      'Message' : userIssue.issueBody,
    };


    ResponseViewModel contactUsResponse = await NetworkUtilities.handlePostRequest(
        acceptJson: true,
        methodURL: NetworkUtilities.getFullURL(method: URL.POST_CONTACT_US , withLocale : false),
        requestHeaders: NetworkUtilities.getHeaders(),
        requestBody: requestBody,
        parserFunction: (jsonResponse) {
          return true ;
        });


    return ResponseViewModel<bool>(
      responseData: contactUsResponse.isSuccess,
      isSuccess: contactUsResponse.isSuccess,
      errorViewModel: contactUsResponse.errorViewModel,
    );

  }

  static Future<ResponseViewModel<bool>> updateCoverPhoto(File userImage) async{
    UserViewModel loggedInUser = await Repository.getUser();
    String fileName = userImage.path.split("/")[userImage.path.split("/").length - 1];
    MultipartFile imageAsMultipartFile = MultipartFile.fromFileSync(userImage.path, filename: fileName);
    Map filesMap = Map<String,dynamic>();
    filesMap.putIfAbsent("CoverImagePath", () => imageAsMultipartFile);
    filesMap.putIfAbsent("UserID", () => loggedInUser.userId);
    FormData formData = FormData.fromMap(filesMap);

    ResponseViewModel uploadFiles = await NetworkUtilities.handleFilesUploading(
        formData: formData,
        requestHeaders: NetworkUtilities.getHeaders(customHeaders:  NetworkUtilities.getHeaders(customHeaders: {'Authorization' : 'Bearer ${loggedInUser.userToken}'})),
        methodURL: NetworkUtilities.getFullURL(method: URL.POST_UPDATE_COVER_IMAGE),
        parserFunction: (responseJson) {
          print("Response Json from cover uploading $responseJson");

          try{
            if(responseJson is List){
              return ParserHelper.parseURL(responseJson[0].toString());
            } else {
              return responseJson[0].toString();
            }
          }catch(exception){
            print("Exception Happened While parsing URLs => $exception");
            return List<String>();
          }
        });
    return ResponseViewModel<bool>(
      responseData: uploadFiles.isSuccess,
      isSuccess: uploadFiles.isSuccess,
      errorViewModel: uploadFiles.errorViewModel,
    );
  }

  static getUserPassword() async{
    SharedPreferences mSharedPreference = await SharedPreferences.getInstance();
    return mSharedPreference.getString(Constants.SHARED_PREFERENCE_USER_PASSWORD);
  }

  static Future<ResponseViewModel<bool>>forgetPassword(String userMail) async{


    Map<String , dynamic> requestBody = {
      'Email' : userMail,
    };
    ResponseViewModel contactUsResponse = await NetworkUtilities.handlePostRequest(
        acceptJson: true,
        methodURL: NetworkUtilities.getFullURL(method: URL.POST_FORGET_PASSWORD , withLocale : true),
        requestHeaders: NetworkUtilities.getHeaders(),
        requestBody: requestBody,
        parserFunction: (jsonResponse) {
          return true ;
        });
    return ResponseViewModel<bool>(
      responseData: contactUsResponse.isSuccess,
      isSuccess: contactUsResponse.isSuccess,
      errorViewModel: contactUsResponse.errorViewModel,
    );


  }

  static Future<ResponseViewModel<bool>> resetPassword(String userMail , String userCode , String password) async{


    Map<String , dynamic> requestBody = {
      'Email' : userMail,
      "VerificationCode": int.parse(userCode),
      "Password": password,
    };
    ResponseViewModel contactUsResponse = await NetworkUtilities.handlePostRequest(
        acceptJson: true,
        methodURL: NetworkUtilities.getFullURL(method: URL.POST_RESET_PASSWORD , withLocale : false),
        requestHeaders: NetworkUtilities.getHeaders(),
        requestBody: requestBody,
        parserFunction: (jsonResponse) {
          return true ;
        });
    return ResponseViewModel<bool>(
      responseData: contactUsResponse.isSuccess,
      isSuccess: contactUsResponse.isSuccess,
      errorViewModel: contactUsResponse.errorViewModel,
    );
  }

  static Future<ResponseViewModel<List<PaymentMethodModel>>> getPaymentMethods() async{

    ResponseViewModel contactUsResponse = await NetworkUtilities.handleGetRequest(
        methodURL: NetworkUtilities.getFullURL(method: URL.GET_RETRIEVE_PAYMENT_ACCOUNT , withLocale : false),
        requestHeaders: NetworkUtilities.getHeaders(),
        parserFunction: PaymentMethodModel.fromJson,
    );

    return ResponseViewModel<List<PaymentMethodModel>>(
      responseData: contactUsResponse.responseData,
      isSuccess: contactUsResponse.isSuccess,
      errorViewModel: contactUsResponse.errorViewModel,
    );


  }


}