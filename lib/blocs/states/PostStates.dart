import 'package:edu360/blocs/events/PostEvents.dart';
import 'package:edu360/data/models/ErrorViewModel.dart';
import 'package:edu360/data/models/PostViewModel.dart';

abstract class PostStates {}



class PostLoadedState extends PostStates{}
class PostLoadingState extends PostStates{}
class PostLoadingFailed extends PostStates{
  final PostEvents failureEvent ;
  final ErrorViewModel error;
  PostLoadingFailed({this.failureEvent , this.error});
}
class PostSharedSuccessfully extends PostStates{}
class PostLoaded extends PostStates{
  final PostViewModel postViewModel;
  PostLoaded({this.postViewModel});
}

class CommentsFetched extends PostStates{
  final PostViewModel postViewModel;
  CommentsFetched({this.postViewModel});
}