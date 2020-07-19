import 'package:edu360/blocs/bloc/HomePostsBloc.dart';
import 'package:edu360/blocs/bloc/UserProfileBloc.dart';
import 'package:edu360/blocs/events/PostEvents.dart';
import 'package:edu360/blocs/events/UserProfileEvents.dart';
import 'package:edu360/blocs/states/PostStates.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
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
    } else if(event is LikePost){
      yield* _handleLikePost(event);
      return ;
    }
  }

  Stream<PostStates> _handleLikePost(LikePost event) async*{
    ResponseViewModel<void> likePostResult = await Repository.likePost(postId: event.postViewModel.postId);
    print(likePostResult.isSuccess);
    if(likePostResult.isSuccess){
      profileBloc.add(LoadUserProfile());
    } else {}
  }
}