import 'package:edu360/data/apis/helpers/ApiParseKeys.dart';
import 'package:edu360/utilities/ParserHelpers.dart';

class CommentViewModel {
  String commentText  , ownerName  , ownerImagePath ;
  int ownerId , commentId , likesCount ;
  bool isObjection;

  @override
  String toString() {
    return 'CommentViewModel{commentText: $commentText, ownerName: $ownerName, ownerImagePath: $ownerImagePath, ownerId: $ownerId, commentId: $commentId, likesCount: $likesCount}';
  }

  CommentViewModel({this.commentId , this.commentText , this.ownerId , this.ownerImagePath , this.ownerName , this.likesCount , this.isObjection});

  static CommentViewModel fromJson(Map<String,dynamic> commentJson){
    return CommentViewModel(
      isObjection: commentJson[ApiParseKeys.COMMENT_TYPE] == 1,
      commentId: commentJson[ApiParseKeys.ID],
      ownerImagePath: ParserHelper.parseURL(commentJson[ApiParseKeys.COMMENT_OWNER_IMAGE]),
      commentText: commentJson[ApiParseKeys.COMMENT_TEXT_BODY],
      likesCount: commentJson[ApiParseKeys.COMMENT_NUMBER_OF_LIKES],
      ownerName: commentJson[ApiParseKeys.COMMENT_OWNER_NAME],
      ownerId: commentJson[ApiParseKeys.COMMENT_OWNER_ID],
    );
  }

  static List<CommentViewModel> fromListJson(List<dynamic> commentsList){
    List<CommentViewModel> comments = List();
    if(commentsList != null && commentsList is List){
      for(int i = 0 ; i < commentsList.length ; i++)
        comments.add(fromJson(commentsList[i]));
    }
    return comments;
  }




}