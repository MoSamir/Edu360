import 'package:edu360/data/apis/helpers/ApiParseKeys.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/apis/helpers/URL.dart';
import 'package:edu360/utilities/ParserHelpers.dart';

import 'CommentViewModel.dart';

class PostViewModel{

  String postBody , ownerName , ownerImagePath ;
  int postId , postOwnerId  , numberOfLikes , numberOfComments, numberOfObjections , numberOfShares;
  bool isLiked ;

  @override
  String toString() {
    return 'PostViewModel{postBody: $postBody, ownerName: $ownerName, postId: $postId, postOwnerId: $postOwnerId, numberOfLikes: $numberOfLikes, numberOfComments: $numberOfComments, numberOfObjections: $numberOfObjections, numberOfShares: $numberOfShares}';
  }

  List<CommentViewModel> postComments = List();
  ContentType contentType;
  List<String> postFilesPath;
  PostViewModel({this.ownerName, this.ownerImagePath , this.numberOfLikes , this.numberOfObjections , this.numberOfComments , this.numberOfShares , this.postBody , this.postComments , this.postId , this.postOwnerId , this.contentType , this.isLiked ,this.postFilesPath});

  static PostViewModel fromJson(Map<String,dynamic> postMap){

    List<String> postDocuments = List<String>();
    if(postMap[ApiParseKeys.POST_SINGLE_ATTACHMENT_PATH] != null)
      postDocuments.add(postMap[ApiParseKeys.POST_SINGLE_ATTACHMENT_PATH]);

//    try {
//      if(postMap[ApiParseKeys.POST_ATTACHMENTS] != null && postMap[ApiParseKeys.POST_ATTACHMENTS] is List) {
//        for (int i  = 0; i < postMap[ApiParseKeys.POST_ATTACHMENTS].length; i++) {
//          var attachment = postMap[ApiParseKeys.POST_ATTACHMENTS][i];
//
//          postDocuments.add(ParserHelper.parseURL(url));
//        }
//      }
//    } catch(Exception){}

    PostViewModel post =  PostViewModel(
      isLiked: (postMap[ApiParseKeys.POST_USER_INTERACTION] != null && postMap[ApiParseKeys.POST_USER_INTERACTION] == 0),
      postId: postMap[ApiParseKeys.POST_ID],
      postOwnerId: postMap[ApiParseKeys.POST_OWNER_ID],
      ownerImagePath: ParserHelper.parseURL(postMap[ApiParseKeys.POST_OWNER_IMAGE]) ?? '',
      ownerName: postMap[ApiParseKeys.POST_OWNER_NAME],
      postBody: postMap[ApiParseKeys.POST_BODY],
      postFilesPath: postDocuments,
      postComments: postMap[ApiParseKeys.POST_COMMENTS],
      numberOfLikes: postMap[ApiParseKeys.POST_NUMBER_OF_LIKES],
      numberOfObjections: postMap[ApiParseKeys.POST_NUMBER_OF_OBJECTIONS],
      numberOfComments: postMap[ApiParseKeys.POST_NUMBER_OF_COMMENTS],
      numberOfShares: postMap[ApiParseKeys.POST_NUMBER_OF_SHARES],
      contentType:  getContentType(postDocuments),
    );
    return post;
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
      if(attachments[i].toString().contains('.doc') || attachments[i].toString().contains('.pdf') || attachments[i].toString().contains('.txt'))
        return ContentType.FILE_POST;
    return ContentType.VIDEO_POST;
  }

  bool canMatch(String query) {
     try{
       bool mainPostHasMatch =  (postBody.contains(query) || ownerName.contains(query));
       if(mainPostHasMatch) return mainPostHasMatch;
       for(int i = 0 ; i < postFilesPath.length ; i++)
         if(postFilesPath[i].contains(query)) return true ;
       return false ;
     }catch(exception){
       return false;
     }
  }
}

enum ContentType {
  TEXT_POST,
  FILE_POST,
  VIDEO_POST,
}


