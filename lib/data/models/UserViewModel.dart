import 'package:edu360/data/apis/helpers/ApiParseKeys.dart';
import 'package:edu360/data/apis/helpers/URL.dart';
import 'package:edu360/utilities/ParserHelpers.dart';
import 'StudyFieldViewModel.dart';
class UserViewModel {
  String userFullName  ,userEmail , userMobileNumber , userEducation  , userPassword ,  userToken , profileImagePath , profileCoverImagePath;
  int userAge, userId;
  DateTime userBirthDay;
  bool contentCreator , isFollowingLoggedInUser;
  StudyFieldViewModel userFieldOfStudy ;
  double userRate = 5.0;

  static List<UserViewModel> fromListJson(List<dynamic> usersJson){
    List<UserViewModel> users = List();
    if(usersJson is List){
      for(int i = 0 ; i < usersJson.length; i++){
        users.add(UserViewModel.fromJson(usersJson[i]));
      }
    }
    return users;
  }

  UserViewModel({
      this.userFullName,
      this.userEmail,
      this.userRate,
      this.profileCoverImagePath,
      this.contentCreator,
      this.profileImagePath,
      this.userMobileNumber,
      this.isFollowingLoggedInUser,
      this.userEducation,
      this.userPassword,
      this.userAge,
      this.userId,
      this.userToken,
      this.userBirthDay,
      this.userFieldOfStudy});


  @override
  String toString() {
    return 'UserViewModel{userFullName: $userFullName, userEmail: $userEmail, userMobileNumber: $userMobileNumber, userEducation: $userEducation, userPassword: $userPassword, userToken: $userToken, profileImagePath: $profileImagePath, profileCoverImagePath: $profileCoverImagePath, userAge: $userAge, userId: $userId, userBirthDay: $userBirthDay, contentCreator: $contentCreator, isFollowingLoggedInUser: $isFollowingLoggedInUser, userFieldOfStudy: $userFieldOfStudy, userRate: $userRate, userFiles: $userFiles}';
  }

  List<String> userFiles = List();
  static UserViewModel fromAnonymousUser() {
    return UserViewModel(
      userId: -1,
    );
  }
  static UserViewModel fromJson(Map<String,dynamic> userJson) {


    Map<String,dynamic> userInformation = Map();
    if(userJson.containsKey(ApiParseKeys.USER_DATA))
      userInformation = userJson[ApiParseKeys.USER_DATA];
    else
      userInformation = userJson;

    return UserViewModel(
      userEmail: userInformation[ApiParseKeys.USER_MAIL],
      userMobileNumber: userInformation[ApiParseKeys.USER_MOBILE],
      contentCreator : userInformation[ApiParseKeys.USER_TYPE] != 0,
      userFullName: userInformation[ApiParseKeys.USER_FULL_NAME],
      profileImagePath: ParserHelper.parseURL(userInformation[ApiParseKeys.USER_PROFILE_IMAGE].toString()) ?? '',
      profileCoverImagePath: ParserHelper.parseURL(userInformation[ApiParseKeys.USER_COVER_IMAGE].toString()) ?? '',
      userAge: userInformation[ApiParseKeys.USER_AGE] ?? 0,
      userBirthDay: userInformation[ApiParseKeys.USER_BIRTHDAY] != null ? DateTime.parse(userInformation[ApiParseKeys.USER_BIRTHDAY]) : DateTime.now(),
      userId: userInformation[ApiParseKeys.ID],
      userEducation: userInformation[ApiParseKeys.USER_EDUCATION],
      userFieldOfStudy: StudyFieldViewModel(
        studyFieldId: userInformation[ApiParseKeys.USER_FIELD_OF_STUDY_ID],
      ),
      userToken: userJson[ApiParseKeys.USER_TOKEN],
      isFollowingLoggedInUser: userJson[ApiParseKeys.IS_FOLLOWER] ?? false,
    );
  }
  Map<String,dynamic> toJson(){
    Map<String, dynamic> userInformation = {
      ApiParseKeys.USER_COVER_IMAGE : profileCoverImagePath,
      ApiParseKeys.USER_MAIL: userEmail ,
       ApiParseKeys.USER_MOBILE : userMobileNumber,
      ApiParseKeys.USER_TYPE : contentCreator == true ? 1 : 0,
      ApiParseKeys.USER_FULL_NAME : userFullName,
      ApiParseKeys.USER_PROFILE_IMAGE : profileImagePath,
      ApiParseKeys.USER_AGE : userAge,
      ApiParseKeys.USER_BIRTHDAY: userBirthDay.toString(),
      ApiParseKeys.ID : userId ,
      ApiParseKeys.USER_EDUCATION: userEducation,
      ApiParseKeys.USER_FIELD_OF_STUDY : userFieldOfStudy.studyFieldId,
    };
    return {
      ApiParseKeys.USER_DATA: userInformation,
      ApiParseKeys.USER_TOKEN : userToken,
    };
  }
  bool isValid() {

    print("Full name ==> ${userFullName!= null && userFullName.isNotEmpty}");
    print("Education ==> ${userEducation !=null && userEducation .isNotEmpty}");
    print("Password ==> ${userPassword!=null && userPassword .isNotEmpty}");
    print("Password ==> ${userBirthDay != null}");
    print("StudyField ==> ${userFieldOfStudy != null}");
    print("userEmail or PhoneNumber ==> ${(userEmail!= null &&  userEmail.isNotEmpty || userMobileNumber!=null && userMobileNumber.isNotEmpty)}");



    return userFullName!= null && userFullName.isNotEmpty &&
        (userEmail!= null &&  userEmail.isNotEmpty || userMobileNumber!=null && userMobileNumber.isNotEmpty) &&
        //profileImagePath!=null && profileImagePath.isNotEmpty &&
        //userMobileNumber!=null && userMobileNumber.isNotEmpty &&
        //userEducation !=null && userEducation .isNotEmpty &&
        userPassword!=null && userPassword .isNotEmpty &&
        //userAge > 0 &&
        userBirthDay != null &&
        userFieldOfStudy != null ;
  }



  bool canMatch(String query) {
    try {
      bool mainPostHasMatch = (userFullName.contains(query));
//          || userMobileNumber.contains(query) || userMobileNumber.contains(query));
//      mainPostHasMatch = mainPostHasMatch || userEducation.contains(query) ||
//          userFieldOfStudy.studyFieldNameEn.contains(query) ||
//          userFieldOfStudy.studyFieldNameAr.contains(query);
      return mainPostHasMatch;
    } catch(exception){
      return false;
    }
  }

  bool isAnonymous() {
    if(userId == -1) return true ;
    if((userEmail == null || userEmail.length == 0) && (userMobileNumber == null || userMobileNumber.length == 0)) return true ;
    return false ;
  }
}