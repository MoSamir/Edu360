import 'dart:io';

import 'package:edu360/data/apis/helpers/ApiParseKeys.dart';

import 'CommentViewModel.dart';

class PostViewModel{

  String postBody , ownerName , ownerImagePath ;
  int postId , postOwnerId  , numberOfLikes , numberOfComments, numberOfObjections , numberOfShares;

  @override
  String toString() {
    return 'PostViewModel{postBody: $postBody, ownerName: $ownerName, postId: $postId, postOwnerId: $postOwnerId, numberOfLikes: $numberOfLikes, numberOfComments: $numberOfComments, numberOfObjections: $numberOfObjections, numberOfShares: $numberOfShares}';
  }

  List<CommentViewModel> postComments = List();
  ContentType contentType;
  List<String> postFilesPath;
  PostViewModel({this.ownerName, this.ownerImagePath , this.numberOfLikes , this.numberOfObjections , this.numberOfComments , this.numberOfShares , this.postBody , this.postComments , this.postId , this.postOwnerId , this.contentType , this.postFilesPath});
  

  static PostViewModel fromJson(Map<String,dynamic> postMap){
    return PostViewModel(
      postId: postMap[ApiParseKeys.POST_ID],
      postOwnerId: postMap[ApiParseKeys.POST_OWNER_ID],
      ownerImagePath: postMap[ApiParseKeys.POST_OWNER_IMAGE],
      ownerName: postMap[ApiParseKeys.POST_OWNER_NAME],
      postBody: postMap[ApiParseKeys.POST_BODY],
      postFilesPath: postMap[ApiParseKeys.POST_ATTACHMENTS],
      postComments: postMap[ApiParseKeys.POST_COMMENTS],

      numberOfLikes: postMap[ApiParseKeys.POST_NUMBER_OF_LIKES],
      numberOfObjections: postMap[ApiParseKeys.POST_NUMBER_OF_OBJECTIONS],
      numberOfComments: postMap[ApiParseKeys.POST_NUMBER_OF_COMMENTS],
      numberOfShares: postMap[ApiParseKeys.POST_NUMBER_OF_SHARES],

      contentType:  getContentType(postMap[ApiParseKeys.POST_ATTACHMENTS]),
    );
  }


  static List<PostViewModel> fromListJson(List<dynamic> postsListMap){

    List<PostViewModel> postsList = List();
    if(postsListMap!= null && postsListMap is List)
      for(int i = 0 ; i < postsListMap.length ; i++)
        postsList.add(PostViewModel.fromJson(postsListMap[i]));
    return postsList;
  }

  static getContentType(List <String> attachments) {
    if(attachments == null || attachments.length == 0)
      return ContentType.TEXT_POST;

    for(int i = 0 ; i < attachments.length ; i++)
      if(attachments[i].contains('.doc') || attachments[i].contains('.pdf') || attachments[i].contains('.txt'))
        return ContentType.FILE_POST;
    return ContentType.VIDEO_POST;
  }







}

enum ContentType {
  TEXT_POST,
  FILE_POST,
  VIDEO_POST,
}


