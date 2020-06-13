import 'package:edu360/data/models/UserViewModel.dart';
import 'dart:io';
abstract class RegistrationEvents {}

class RegisterUserWithCredentials extends RegistrationEvents{
  final UserViewModel userViewModel;
  final List<File> userUploadedDocuments ;
  RegisterUserWithCredentials({this.userViewModel, this.userUploadedDocuments});

}


class VerifyUserInformation extends RegistrationEvents{
  final String verificationCode;
  VerifyUserInformation({this.verificationCode});

}