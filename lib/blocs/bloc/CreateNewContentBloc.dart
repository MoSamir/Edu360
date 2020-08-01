import 'package:edu360/blocs/events/CreateNewContentEvents.dart';
import 'package:edu360/blocs/states/CreateNewContentStates.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
import 'package:edu360/utilities/Constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Repository.dart';

class CreateNewContentBloc extends Bloc<CreateNewContentEvents , CreateNewContentStates>{

  PostViewModel newPost = PostViewModel(
    contentType: ContentType.TEXT_POST,
  );


  @override
  CreateNewContentStates get initialState => PostCreationInitialized();

  @override
  Stream<CreateNewContentStates> mapEventToState(CreateNewContentEvents event) async*{

    bool isUserConnected = await NetworkUtilities.isConnected();
    if(isUserConnected == false){
      yield PostCreationFailed(
        failedEvent: event,
        error: Constants.CONNECTION_TIMEOUT,
      );
      return ;
    }
    if(event is CreatePost){
      yield* _handlePostCreation(event);
      return ;
    }
  }

  Stream<CreateNewContentStates> _handlePostCreation(CreatePost event) async*{
    yield PostCreationLoading();
    if(event.postDocuments!=null && event.postDocuments.length > 0){
      yield* _handleMediaPostCreation(event);
      return;
    } else {
      yield* _handleTextPostCreation(event);
      return;
    }
  }

  Stream<CreateNewContentStates> _handleMediaPostCreation(CreatePost event) async*{

    ResponseViewModel<List<String>> uploadFilesResponse = await Repository.uploadPostFiles(event.postDocuments);
    if(event.postDocuments.length > 0 &&  uploadFilesResponse.isSuccess){
      ResponseViewModel<void> createPostResponse = await Repository.createPostWithMedia(userPost : event.postViewModel , postFilesPath : uploadFilesResponse.responseData);
      if(createPostResponse.isSuccess){
        yield PostCreationSuccess();
        return ;
      }
      else {
        yield PostCreationFailed(failedEvent: event , error: createPostResponse.errorViewModel);
        return ;
      }
    } else {
      yield PostCreationFailed(failedEvent: event , error: uploadFilesResponse.errorViewModel);
      return ;
    }
  }
  Stream<CreateNewContentStates> _handleTextPostCreation(CreatePost event) async*{
    ResponseViewModel<void> createPostResponse = await Repository.createPost(userPost : event.postViewModel);
    if(createPostResponse.isSuccess){
      yield PostCreationSuccess();
      return ;
    }
    else {
      yield PostCreationFailed(failedEvent: event , error: createPostResponse.errorViewModel);
      return ;
    }
  }

}