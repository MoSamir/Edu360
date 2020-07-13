import 'package:edu360/Repository.dart';
import 'package:edu360/blocs/events/UserProfileEvents.dart';
import 'package:edu360/blocs/states/UserProfileStates.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileBloc extends Bloc<UserProfileEvents , UserProfileStates>{

  List<PostViewModel> userPosts = List();
  List<PostViewModel> get userTextPosts => userPosts.where((element) => element.contentType == ContentType.TEXT_POST).toList();
  List<PostViewModel> get userFilePosts => userPosts.where((element) => element.contentType == ContentType.FILE_POST).toList();
  List<PostViewModel> get userVideoPosts => userPosts.where((element) => element.contentType == ContentType.VIDEO_POST).toList();

  @override
  UserProfileStates get initialState => UserProfileLoading();

  @override
  Stream<UserProfileStates> mapEventToState(UserProfileEvents event) async*{
    if(event is LoadUserProfile){
      yield* _loadUserProfile(event);
      return;
    }
  }
  Stream<UserProfileStates> _loadUserProfile(LoadUserProfile event) async*{
    ResponseViewModel<List<PostViewModel>> userPostsResponse = await Repository.loadUserProfile();
    if(userPostsResponse.isSuccess){
      userPosts = userPostsResponse.responseData;
      yield UserProfileLoaded();
      return ;
    } else {
      yield UserProfileLoadingFailed(error: userPostsResponse.errorViewModel , failureEvent: event);
      return ;
    }
  }
}