import 'package:edu360/data/apis/helpers/ApiParseKeys.dart';
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
  List<String> userFiles = List();


  static UserViewModel fromAnonymousUser() {
    return UserViewModel();
  }

  static UserViewModel fromJson(userJson) {
    var userInformation = userJson[ApiParseKeys.USER_DATA];
    return UserViewModel(
      userEmail: userInformation[ApiParseKeys.USER_MAIL],
      userMobileNumber: userInformation[ApiParseKeys.USER_MOBILE],
      contentCreator : userInformation[ApiParseKeys.USER_TYPE] != 0,
      userFullName: userInformation[ApiParseKeys.USER_FULL_NAME],
      profileImagePath: userInformation[ApiParseKeys.USER_PROFILE_IMAGE],
      userAge: userInformation[ApiParseKeys.USER_AGE] ?? 0,
      userBirthDay: userInformation[ApiParseKeys.USER_BIRTHDAY] != null ? DateTime.parse(userInformation[ApiParseKeys.USER_BIRTHDAY]) : DateTime.now(),
      userId: userInformation[ApiParseKeys.ID],
      userEducation: userInformation[ApiParseKeys.USER_EDUCATION],
      userFieldOfStudy: StudyFieldViewModel(
        studyFieldId: userInformation[ApiParseKeys.USER_FIELD_OF_STUDY],
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
       ApiParseKeys.USER_FIELD_OF_STUDY: userFieldOfStudy.studyFieldId,
    };
    return {
      ApiParseKeys.USER_DATA: userInformation,
      ApiParseKeys.USER_TOKEN : userToken,
    };
  }
}
