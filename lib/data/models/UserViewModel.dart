import 'package:edu360/data/apis/helpers/ApiParseKeys.dart';
import 'package:edu360/data/apis/helpers/URL.dart';
import 'package:edu360/utilities/ParserHelpers.dart';
import 'StudyFieldViewModel.dart';
class UserViewModel {
  String userFullName  ,userEmail , userMobileNumber , userEducation  , userPassword ,  userToken , profileImagePath ;
  int userAge, userId;
  DateTime userBirthDay;
  bool contentCreator , isFollowingLoggedInUser;
  StudyFieldViewModel userFieldOfStudy ;

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
    return 'UserViewModel{userFullName: $userFullName, userEmail: $userEmail, userMobileNumber: $userMobileNumber, userEducation: $userEducation, userPassword: $userPassword, userToken: $userToken, profileImagePath: $profileImagePath, userAge: $userAge, userId: $userId, userBirthDay: $userBirthDay, contentCreator: $contentCreator, userFieldOfStudy: $userFieldOfStudy, userFiles: $userFiles}';
  }

  List<String> userFiles = List();
  static UserViewModel fromAnonymousUser() {
    return UserViewModel();
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
    return userFullName!= null && userFullName.isNotEmpty &&
        userEmail!= null &&  userEmail.isNotEmpty &&
        //profileImagePath!=null && profileImagePath.isNotEmpty &&
        //userMobileNumber!=null && userMobileNumber.isNotEmpty &&
        userEducation !=null && userEducation .isNotEmpty &&
        userPassword!=null && userPassword .isNotEmpty &&
        userAge > 0 &&
        userBirthDay != null &&
        userFieldOfStudy != null ;
  }
}