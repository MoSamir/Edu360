import 'package:edu360/blocs/states/RegistrationStates.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'dart:io';
abstract class RegistrationEvents {}

class RegisterUserWithCredentials extends RegistrationEvents{
  final UserViewModel userViewModel;
  final File profileImage ;
  final List<File> userUploadedDocuments ;
  RegisterUserWithCredentials({this.userViewModel, this.profileImage, this.userUploadedDocuments});
}

class RequestPhoneVerification extends RegistrationEvents {
  final String phoneNo;
  RequestPhoneVerification({this.phoneNo});
}

class VerifyUserInformation extends RegistrationEvents{
  final String verificationCode;
  VerifyUserInformation({this.verificationCode});
}

class UploadFiles extends RegistrationEvents {
  final List<File> files ;
  UploadFiles({this.files});

}


class MoveToState extends RegistrationEvents{

  final RegistrationStates targetState ;
  MoveToState({this.targetState});

}

class LoadFieldsOfStudy extends RegistrationEvents {}


class VerifyUserPhoneNumber extends RegistrationEvents{
  final String phoneCode ;
  VerifyUserPhoneNumber({this.phoneCode});
}