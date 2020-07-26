import 'package:edu360/data/apis/helpers/ApiParseKeys.dart';
import 'package:edu360/data/apis/helpers/URL.dart';
import 'StudyFieldViewModel.dart';
class UserViewModel {
  String userFullName  ,userEmail , userMobileNumber , userEducation  , userPassword ,  userToken , profileImagePath ;
  int userAge, userId;
  DateTime userBirthDay;
  bool contentCreator ;
  StudyFieldViewModel userFieldOfStudy ;

  UserViewModel({
      this.userFullName,
      this.userEmail,
      this.contentCreator,
      this.profileImagePath,
      this.userMobileNumber,
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
    return UserViewModel(

    );
  }

  static UserViewModel fromJson(userJson) {


    var userInformation = userJson[ApiParseKeys.USER_DATA];
    return UserViewModel(
      userEmail: userInformation[ApiParseKeys.USER_MAIL],
      userMobileNumber: userInformation[ApiParseKeys.USER_MOBILE],
      contentCreator : userInformation[ApiParseKeys.USER_TYPE] != 0,
      userFullName: userInformation[ApiParseKeys.USER_FULL_NAME],
      profileImagePath: URL.BASE_URL+"/"+userInformation[ApiParseKeys.USER_PROFILE_IMAGE],
      userAge: userInformation[ApiParseKeys.USER_AGE] ?? 0,
      userBirthDay: userInformation[ApiParseKeys.USER_BIRTHDAY] != null ? DateTime.parse(userInformation[ApiParseKeys.USER_BIRTHDAY]) : DateTime.now(),
      userId: userInformation[ApiParseKeys.ID],
      userEducation: userInformation[ApiParseKeys.USER_EDUCATION],
      userFieldOfStudy: StudyFieldViewModel(
        studyFieldId: userInformation[ApiParseKeys.FIELD_OF_STUDY_ID] ?? userInformation[ApiParseKeys.ID],
      ),
      userToken: userJson[ApiParseKeys.USER_TOKEN],
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
      //ApiParseKeys.FIELD_OF_STUDY_ID : userFieldOfStudy.studyFieldId,
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