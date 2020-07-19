import 'package:edu360/data/models/UserViewModel.dart';
import 'dart:io';
abstract class RegistrationEvents {}

class RegisterUserWithCredentials extends RegistrationEvents{
  final UserViewModel userViewModel;
  final File profileImage ;
  final List<File> userUploadedDocuments ;
  RegisterUserWithCredentials({this.userViewModel, this.profileImage, this.userUploadedDocuments});
}

class VerifyUserInformation extends RegistrationEvents{
  final String verificationCode;
  VerifyUserInformation({this.verificationCode});
}

class UploadFiles extends RegistrationEvents {
  final List<File> files ;
  UploadFiles({this.files});

}

class LoadFieldsOfStudy extends RegistrationEvents {}