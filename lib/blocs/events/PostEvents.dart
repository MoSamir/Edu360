import 'package:edu360/data/models/CommentViewModel.dart';
import 'package:edu360/data/models/PostViewModel.dart';

abstract class PostEvents {}
class LikePost extends PostEvents{
  final PostViewModel postViewModel;
  LikePost({this.postViewModel});
}

class DeletePost extends PostEvents{
  final PostViewModel postViewModel;
  DeletePost({this.postViewModel});
}




class UnLikePost extends PostEvents{
  final PostViewModel postViewModel;
  UnLikePost({this.postViewModel});
}
class LikeComment extends PostEvents{
  final CommentViewModel postComment ;
  LikeComment({this.postComment});


}
class SharePost extends PostEvents{
  final PostViewModel postViewModel;
  final String shareDescription ;
  SharePost({this.postViewModel , this.shareDescription});
}
class AddComment extends PostEvents{
  final PostViewModel postModel;
  final CommentViewModel commentViewModel;
  AddComment({this.postModel , this.commentViewModel});
}
class AddObjection extends PostEvents{
  final PostViewModel postModel;
  final CommentViewModel commentViewModel;
  AddObjection({this.postModel , this.commentViewModel});
}
class FetchPostComments extends PostEvents{
  final PostViewModel postModel;
  final bool silentLoad;
  FetchPostComments({this.postModel , this.silentLoad});
}
