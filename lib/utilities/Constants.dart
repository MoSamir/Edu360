import 'package:edu360/data/models/ErrorViewModel.dart';
import 'dart:io';
class Constants {

  static final ErrorViewModel CONNECTION_TIMEOUT = ErrorViewModel(
    errorMessage: '',
    errorCode: HttpStatus.requestTimeout,
  );
  static const String SHARED_PREFERENCE_USER_TOKEN_KEY = "Edu_user_TokenKey_shared_pref";
  static const String SHARED_PREFERENCE_USER_KEY = "Edu_user_userKey_shared_pref";

}
