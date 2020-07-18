import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:edu360/blocs/bloc/PostBloc.dart';
import 'package:edu360/blocs/events/PostEvents.dart';
import 'package:edu360/data/models/CommentViewModel.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/ui/widgets/post/UserDocumentsPostCard.dart';
import 'package:edu360/ui/widgets/post/UserTextPostCard.dart';
import 'package:edu360/ui/widgets/post/UserVideoPostCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UIHelper {
  static Widget getPostView(PostViewModel post , BuildContext context ,{double elevation , Function postAction}){
    PostBloc postBloc = PostBloc(profileBloc: BlocProvider.of<AppDataBloc>(context).userDataBloc.userProfileBloc
        , homePostsBloc: BlocProvider.of<AppDataBloc>(context).userDataBloc.homePostsBloc);
    UserViewModel user = BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc.currentUser;

    if(post.contentType == ContentType.TEXT_POST)
      return UserTextPostCard(postModel: post, elevation: elevation , onComment: (String comment){
        postBloc.add(AddComment(postModel: post, commentViewModel: createComment(comment, user)));
        if(postAction != null)
          postAction();
      }, onLike: (){
        postBloc.add(LikePost(postViewModel:  post));
        if(postAction != null)
          postAction();
      }, onShare: (String shareDescription){
        postBloc.add(SharePost(postViewModel: post , shareDescription: shareDescription));
        if(postAction != null)
          postAction();
      }, onObjection: (String objection){
        postBloc.add(AddObjection(postModel: post, commentViewModel: createComment(objection, user)));
        if(postAction != null)
          postAction();
      },);
    else if(post.contentType == ContentType.VIDEO_POST)
      return UserVideoPostCard(postModel: post, elevation: elevation , onComment: (String comment){
        postBloc.add(AddComment(postModel: post, commentViewModel: createComment(comment, user)));
        if(postAction != null)
          postAction();
      }, onLike: (){
        postBloc.add(LikePost(postViewModel:  post));
        if(postAction != null)
          postAction();
      }, onShare: (String shareDescription){
        postBloc.add(SharePost(postViewModel: post , shareDescription: shareDescription));
        if(postAction != null)
          postAction();
      }, onObjection: (String objection){
        postBloc.add(AddObjection(postModel: post, commentViewModel: createComment(objection, user)));
        if(postAction != null)
          postAction();
      },);
    else if(post.contentType == ContentType.FILE_POST)
      return UserDocumentsPostCard(postModel: post, elevation: elevation , onComment: (String comment){
        postBloc.add(AddComment(postModel: post, commentViewModel: createComment(comment, user)));
        if(postAction != null)
          postAction();
      }, onLike: (){
        postBloc.add(LikePost(postViewModel:  post));
        if(postAction != null)
          postAction();
      }, onShare: (String shareDescription){
        postBloc.add(SharePost(postViewModel: post , shareDescription: shareDescription));
        if(postAction != null)
          postAction();
      }, onObjection: (String objection){
        postBloc.add(AddObjection(postModel: post, commentViewModel: createComment(objection, user)));
        if(postAction != null)
          postAction();
      },);
    else
      return Container(
        width: 0,
        height: 0,
      );
  }

  static CommentViewModel createComment(String comment , UserViewModel user) {
    return CommentViewModel(commentText: comment , ownerName: user.userFullName, ownerId:  user.userId);
  }

}