import 'StudyFieldViewModel.dart';
import 'UserGenderViewModel.dart';
class UserViewModel {
  String userFullName , userEmail , userMobileNumber ;
  int userAge ;
  DateTime userBirthDay;
  StudyFieldViewModel userFieldOfStudy ;
  UserGenderViewModel userGender ;

  static UserViewModel fromAnonymousUser() {
    return UserViewModel();
  }

}

/*
  public string FullName { get; set; }
public string Email { get; set; }
public string Password { get; set; }
public string Mobile { get; set; }
public List<byte> ProfileImage { get; set; }
public int? Age { get; set; }
public DateTime? BirthDate { get; set; }
public Genders? Gender { get; set; }
public FieldOfStudy FieldOfStudy { get; set; }
 */
