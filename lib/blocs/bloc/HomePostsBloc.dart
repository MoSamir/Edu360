import 'package:edu360/blocs/events/HomePostsEvent.dart';
import 'package:edu360/blocs/states/HomePostsStates.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/utilities/Constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePostsBloc extends Bloc<HomePostsEvents , HomePostsStates>{

  List<PostViewModel> homePosts = List();

  @override
  HomePostsStates get initialState => HomePostsLoading();

  @override
  Stream<HomePostsStates> mapEventToState(HomePostsEvents event) async*{

    bool isUserConnected = await NetworkUtilities.isConnected();
    if(isUserConnected == false){
      yield HomePostsLoadingFailed(
        failureEvent: event,
        error: Constants.CONNECTION_TIMEOUT,
      );
      return ;
    }


    if(event is LoadHomeUserPosts){
      yield* _handleUserHomeLoading(event);
      return;
    }
  }

  Stream<HomePostsStates>  _handleUserHomeLoading(LoadHomeUserPosts event) async*{
    yield HomePostsLoaded();
    return ;
  }
}