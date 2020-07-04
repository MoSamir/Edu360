import 'dart:io';

import 'package:edu360/data/apis/helpers/ApiParseKeys.dart';

import 'CommentViewModel.dart';

class PostViewModel{

  String postBody , ownerName , ownerImagePath ;
  int postId , postOwnerId ;
  List<CommentViewModel> postComments = List();
  ContentType contentType;
  List<String> postFilesPath;

  PostViewModel({this.ownerName, this.ownerImagePath , this.postBody , this.postComments , this.postId , this.postOwnerId , this.contentType , this.postFilesPath});
  

  static PostViewModel fromJson(Map<String,dynamic> postMap){
    return PostViewModel(
      postId: postMap[ApiParseKeys.POST_ID],
      postOwnerId: postMap[ApiParseKeys.POST_OWNER_ID],
      ownerImagePath: postMap[ApiParseKeys.POST_OWNER_IMAGE],
      ownerName: postMap[ApiParseKeys.POST_OWNER_NAME],
      postBody: postMap[ApiParseKeys.POST_BODY],
      postFilesPath: postMap[ApiParseKeys.POST_ATTACHMENTS],
      postComments: postMap[ApiParseKeys.POST_COMMENTS],
      contentType: getContentType(postMap[ApiParseKeys.POST_TYPE]),

    );
  }


  static List<PostViewModel> fromListJson(List<dynamic> postsListMap){

    List<PostViewModel> postsList = List();
    print('Posts Map $postsListMap');
    print("User List => ${postsListMap!= null && postsListMap is List}");
    if(postsListMap!= null && postsListMap is List)
      for(int i = 0 ; i < postsListMap.length ; i++)
        postsList.add(PostViewModel.fromJson(postsListMap[i]));
    return postsList;
  }

  static getContentType(int postType) {

    switch(postType){
      case 0 : return ContentType.VIDEO_POST;
      case 1 : return ContentType.FILE_POST;
     // case 2 : return ContentType.IMAGE_POST;
      case 3 : return ContentType.TEXT_POST;
      default : return ContentType.TEXT_POST;
    }



  }







}

enum ContentType {
  TEXT_POST,
  FILE_POST,
  VIDEO_POST,
}


