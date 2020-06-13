import 'package:edu360/data/models/ErrorViewModel.dart';
import 'dart:io';
class Constants {

  static final ErrorViewModel CONNECTION_TIMEOUT = ErrorViewModel(
    errorMessage: '',
    errorCode: HttpStatus.requestTimeout,
  );
}
