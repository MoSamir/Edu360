import 'dart:io';

import 'CommentViewModel.dart';

class PostViewModel{

  String postBody , ownerName , ownerImagePath ;
  int postId , postOwnerId ;
  List<CommentViewModel> postComments = List();
  ContentType contentType;
  List<String> postFilesPath;
  PostViewModel({this.ownerName, this.ownerImagePath , this.postBody , this.postComments , this.postId , this.postOwnerId , this.contentType , this.postFilesPath});
  

  static PostViewModel fromJson(Map<String,dynamic> postMap){
    return PostViewModel();
  }







}

enum ContentType {
  TEXT_POST,
  FILE_POST,
  VIDEO_POST,
}


