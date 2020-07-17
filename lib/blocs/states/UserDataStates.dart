import 'package:edu360/blocs/events/UserDataEvents.dart';
import 'package:edu360/data/models/ErrorViewModel.dart';

abstract class UserDataStates {}


class UserDataInitializing extends UserDataStates{}

class UserDataInitializationFailed extends UserDataStates{
  final UserDataEvents failureEvent ;
  final ErrorViewModel error;
  UserDataInitializationFailed({this.error , this.failureEvent});

}