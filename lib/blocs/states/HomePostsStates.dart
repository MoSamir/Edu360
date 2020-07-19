import 'package:edu360/blocs/events/HomePostsEvent.dart';
import 'package:edu360/data/models/ErrorViewModel.dart';

abstract class HomePostsStates {}


class HomePostsLoading extends HomePostsStates{}

class HomePostsLoaded extends HomePostsStates{}

class HomePostsLoadingFailed extends HomePostsStates{

  final HomePostsEvents failureEvent ;
  final ErrorViewModel error ;
  HomePostsLoadingFailed({this.failureEvent, this.error});

}
