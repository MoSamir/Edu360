import 'package:edu360/blocs/events/PostEvents.dart';
import 'package:edu360/data/models/ErrorViewModel.dart';

abstract class PostStates {}



class PostLoadedState extends PostStates{}
class PostLoadingState extends PostStates{}
class PostLoadingFailed extends PostStates{
  final PostEvents failureEvent ;
  final ErrorViewModel error;
  PostLoadingFailed({this.failureEvent , this.error});
}
