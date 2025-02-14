import 'package:edu360/Repository.dart';
import 'package:edu360/blocs/events/UserProfileEvents.dart';
import 'package:edu360/blocs/states/UserProfileStates.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/utilities/Constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class UserProfileBloc extends Bloc<UserProfileEvents , UserProfileStates>{

  UserViewModel userViewModel ;

  BehaviorSubject<bool> followStream = BehaviorSubject<bool>();
  List<PostViewModel> userPosts = List();
  List<PostViewModel> get userTextPosts => userPosts.where((element) => element.postFilesPath == null || element.postFilesPath.length == 0).toList();
  List<PostViewModel> get userFilePosts => userPosts.where((element) => element.postFilesPath != null && element.postFilesPath.length > 0 ).toList();
  List<PostViewModel> get userVideoPosts => userPosts.where((element) => element.contentType == ContentType.VIDEO_POST).toList();

  @override
  UserProfileStates get initialState => UserProfileLoading();

  @override
  Stream<UserProfileStates> mapEventToState(UserProfileEvents event) async*{
    bool isUserConnected = await NetworkUtilities.isConnected();
    if(isUserConnected == false){
      yield UserProfileLoadingFailed(
        failureEvent: event,
        error: Constants.CONNECTION_TIMEOUT,
      );
      return ;
    }
    if(event is LoadUserProfile){
      yield* _loadUserProfile(event);
      return;
    }
    else if(event is LoadOtherUsersProfile){
      yield* _loadOtherUserProfile(event);
      return;
    }
    else if(event is FollowUser){
      yield* _handleFollowUser(event);
     return ;
    }
    else if(event is UnfollowUser){
        yield* _handleUnFollowUser(event);
        return ;
    }
    else if(event is UpdateProfileImage){
      yield* _handleProfileImageChanging(event);
      return ;
    }



  }




  Stream<UserProfileStates> _loadUserProfile(LoadUserProfile event) async*{
    yield UserProfileLoading();

    ResponseViewModel<List<PostViewModel>> userPostsResponse = await Repository.loadUserProfile();
    if(userPostsResponse.isSuccess){
      userPosts.clear();
      if(userPostsResponse.responseData.isEmpty == false){
        userPosts = userPostsResponse.responseData;
        yield UserProfileLoaded();
        return ;
      } else {
        UserViewModel userModel = await Repository.getUser();
        ResponseViewModel<List<PostViewModel>> feedsResponse = await Repository.loadHomePagePosts();
        userPosts = feedsResponse.responseData.where((element) => element.postOwnerId == userModel.userId).toList();
        yield UserProfileLoaded();
        return ;
      }
    } else {
      yield UserProfileLoadingFailed(error: userPostsResponse.errorViewModel , failureEvent: event);
      return ;
    }
  }

  Stream<UserProfileStates> _handleUnFollowUser(UnfollowUser event) async*{
    yield UserProfileLoading();
    ResponseViewModel<void> followUser = await Repository.unfollowUser(userId: event.userId);
    if(followUser.isSuccess){
      followStream.sink.add(true);
      if(userViewModel ==null)
        add(LoadUserProfile(userId: event.userId));
      else
        add(LoadOtherUsersProfile(userId: userViewModel.userId));
      return;
    } else {
      yield UserProfileLoadingFailed(error: followUser.errorViewModel , failureEvent: event );
      return;
    }
  }

  Stream<UserProfileStates> _handleFollowUser(FollowUser event) async*{
    yield UserProfileLoading();
    ResponseViewModel<void> followUser = await Repository.followUser(userId: event.userId);
    if(followUser.isSuccess){
      followStream.sink.add(true);
      if(userViewModel ==null)
        add(LoadUserProfile(userId: event.userId));
      else
      add(LoadOtherUsersProfile(userId: userViewModel.userId));
      return;
    } else {
      yield UserProfileLoadingFailed(error: followUser.errorViewModel , failureEvent: event );
      return;
    }
  }

  Stream<UserProfileStates> _loadOtherUserProfile(LoadOtherUsersProfile event) async*{
    yield UserProfileLoading();
    ResponseViewModel<UserViewModel> userResponse = await Repository.loadOtherUserProfile(id: event.userId);
    if(userResponse.isSuccess){
      followStream.sink.add(userResponse.responseData.isFollowingLoggedInUser);
      userViewModel = userResponse.responseData;
      ResponseViewModel<List<PostViewModel>> userPostsResponse = await Repository.loadOtherUserProfilePosts(id: event.userId);
      if(userPostsResponse.isSuccess)
        userPosts = userPostsResponse.responseData;
      yield UserProfileLoaded();
      return ;
    } else {
      yield UserProfileLoadingFailed(error: userResponse.errorViewModel , failureEvent: event);
      return ;
    }
  }

  @override
  Future<Function> close() {
    followStream.close();
    return super.close();
  }

  Stream<UserProfileStates>  _handleProfileImageChanging(UpdateProfileImage event) async*{

    yield UserProfileLoading();

    List<Future<ResponseViewModel>> apis = List();
    if(event.userProfileImage != null)
      apis.add(Repository.updateProfileImage(profileImage: event.userProfileImage));

    if(event.userCoverImage != null)
      apis.add(Repository.updateCoverImage(profileImage: event.userCoverImage));
    List<ResponseViewModel> responses = await Future.wait(apis);

    bool isSuccess = true ;
    try {
      for (int i = 0; i < responses.length; i++) {
        isSuccess = (responses[i].isSuccess && isSuccess);
      }
    } catch(exception){
      print("Exception accured after Update => $exception");
    }

    if(isSuccess){
      yield ProfileImageUpdated(nextPageIndex: event.nextPageIndex);
      add(LoadUserProfile());
      return ;
    } else {
      yield UserProfileLoaded();
      return ;
    }
  }
}