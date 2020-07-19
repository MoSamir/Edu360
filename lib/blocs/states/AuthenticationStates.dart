import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/blocs/events/AuthenticationEvents.dart';
import 'package:edu360/data/models/ErrorViewModel.dart';
abstract class AuthenticationStates {}

class AuthenticationInitiated extends AuthenticationStates{}



class UserAuthenticated extends AuthenticationStates{
  final UserViewModel currentUser ;
  UserAuthenticated({this.currentUser});
}

class UserNotInitialized extends AuthenticationStates{}


class AuthenticationLoading extends AuthenticationStates {}

class AuthenticationFailed extends AuthenticationStates {
  final AuthenticationEvents failedEvent ;
  final ErrorViewModel error ;

  AuthenticationFailed({this.error , this.failedEvent});

}

