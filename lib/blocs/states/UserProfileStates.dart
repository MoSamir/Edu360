import 'package:edu360/blocs/events/UserProfileEvents.dart';
import 'package:edu360/data/models/ErrorViewModel.dart';

abstract class UserProfileStates {}

class UserProfileLoaded extends UserProfileStates{}

class UserProfileLoading extends UserProfileStates{}

class UserProfileLoadingFailed extends UserProfileStates{
  final UserProfileEvents failureEvent ;
  final ErrorViewModel error ;

  UserProfileLoadingFailed({this.failureEvent , this.error});

}

class ProfileImageUpdated extends UserProfileStates{

  final int nextPageIndex;
  ProfileImageUpdated({this.nextPageIndex});

}