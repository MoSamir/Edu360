import 'package:edu360/blocs/bloc/HomePostsBloc.dart';
import 'package:edu360/blocs/bloc/UserProfileBloc.dart';
import 'package:edu360/blocs/events/PostEvents.dart';
import 'package:edu360/blocs/events/UserProfileEvents.dart';
import 'package:edu360/blocs/states/PostStates.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/models/CommentViewModel.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
import 'package:edu360/utilities/Constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Repository.dart';

class PostBloc extends Bloc<PostEvents , PostStates>{

  UserProfileBloc profileBloc ;
  HomePostsBloc homePostsBloc ;
  PostBloc({this.homePostsBloc , this.profileBloc});

  @override
  PostStates get initialState => PostLoadedState();

  @override
  Stream<PostStates> mapEventToState(PostEvents event) async*{

    bool isUserConnected = await NetworkUtilities.isConnected();
    if(isUserConnected == false){
      yield PostLoadingFailed(
        failureEvent: event,
        error: Constants.CONNECTION_TIMEOUT,
      );
      return ;
    }
      else if(event is LikePost){
      yield* _handleLikePost(event);
      return ;
    }
      else if(event is AddComment){
      yield* _handleUserComment(event);
      return ;
    } else if(event is AddObjection){
      yield* _handleUserObjection(event);
      return ;
    }
      else if(event is SharePost){
      yield* _handlePostSharing(event);
      return ;
    }
      else if(event is FetchPostComments){
      yield* _handlePostCommentsFetching(event);
      return ;
    }
  }

  Stream<PostStates> _handleLikePost(LikePost event) async*{
    ResponseViewModel<void> likePostResult = await Repository.likePost(postId: event.postViewModel.postId);
    if(likePostResult.isSuccess){
      profileBloc.add(LoadUserProfile());
    } else {}
  }

  Stream<PostStates> _handleUserComment(AddComment event)  async*{
    ResponseViewModel<void> likePostResult = await Repository.addComment(postId: event.postModel.postId , comment: event.commentViewModel);
    if(likePostResult.isSuccess){
      profileBloc.add(LoadUserProfile());
    } else {}
  }

  Stream<PostStates> _handleUserObjection(AddObjection event) async* {
    ResponseViewModel<void> likePostResult = await Repository.addObjection(postId: event.postModel.postId , comment: event.commentViewModel);

    if(likePostResult.isSuccess){
      profileBloc.add(LoadUserProfile());
    } else {}
  }

  Stream<PostStates> _handlePostSharing(SharePost event) async* {
    ResponseViewModel<void> likePostResult = await Repository.sharePost(postId: event.postViewModel.postId , shareDescription: event.shareDescription);
    if(likePostResult.isSuccess){
      profileBloc.add(LoadUserProfile());
    } else {}
  }

  _handlePostCommentsFetching(FetchPostComments event) async*{
    ResponseViewModel<List<CommentViewModel>> post = await Repository.getPostComments(post: event.postModel);
    PostViewModel postModel = event.postModel;
    postModel.postComments = post.responseData;
    if(post.isSuccess){
      yield PostLoaded(postViewModel: postModel);
    } else {}
  }
}