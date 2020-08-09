import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:edu360/blocs/bloc/PostBloc.dart';
import 'package:edu360/blocs/events/HomePostsEvent.dart';
import 'package:edu360/blocs/events/PostEvents.dart';
import 'package:edu360/blocs/events/UserProfileEvents.dart';
import 'package:edu360/data/models/CommentViewModel.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/ui/widgets/post/UserDocumentsPostCard.dart';
import 'package:edu360/ui/widgets/post/UserTextPostCard.dart';
import 'package:edu360/ui/widgets/post/UserVideoPostCard.dart';
import 'package:edu360/ui/widgets/profile/ProfileDocumentCard.dart';
import 'package:edu360/ui/widgets/profile/ProfileTextPostCard.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UIHelper {
  static Widget getPostView(PostViewModel post , BuildContext context ,{double elevation , Function postAction , Function onPostClick}){
    PostBloc postBloc = PostBloc((){
      BlocProvider.of<AppDataBloc>(context).userDataBloc.homePostsBloc.add(LoadHomeUserPosts());
      BlocProvider.of<AppDataBloc>(context).userDataBloc.userProfileBloc.add(LoadUserProfile());
    });
    UserViewModel user = BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc.currentUser;

    if(post.postFilesPath == null || post.postFilesPath.length == 0) {
      return UserTextPostCard(postModel: post,
        elevation: elevation,
        onPostClick: onPostClick ?? (){},
        onComment: (String comment) {
          postBloc.add(AddComment(
              postModel: post, commentViewModel: createComment(comment, user)));
          if (postAction != null)
            postAction();
        },
        onLike: () {
          postBloc.add(LikePost(postViewModel: post));
          if (postAction != null)
            postAction();
        },
        onShare: (String shareDescription) {
          postBloc.add(SharePost(
              postViewModel: post, shareDescription: shareDescription));
          if (postAction != null)
            postAction();
        },
        onObjection: (String objection) {
          postBloc.add(AddObjection(postModel: post,
              commentViewModel: createComment(objection, user)));
          if (postAction != null)
            postAction();
        },);
    }
    else if(post.postFilesPath[0].endsWith('.mov') || post.postFilesPath[0].endsWith('.mp4'))
      return UserVideoPostCard(postModel: post, elevation: elevation , onPostClick: onPostClick ?? (){}, onComment: (String comment){
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
      return UserDocumentsPostCard(postModel: post, elevation: elevation ,onPostClick: onPostClick ??(){}, onComment: (String comment){
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

  }

  static CommentViewModel createComment(String comment , UserViewModel user) {
    return CommentViewModel(commentText: comment , ownerName: user.userFullName, ownerId:  user.userId);
  }
  static Widget getProfilePostView(PostViewModel post , BuildContext context , {Function postAction , Function onPostClick}){
    PostBloc postBloc = PostBloc((){
      BlocProvider.of<AppDataBloc>(context).userDataBloc.homePostsBloc.add(LoadHomeUserPosts());
      BlocProvider.of<AppDataBloc>(context).userDataBloc.userProfileBloc.add(LoadUserProfile());
    });
    UserViewModel user = BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc.currentUser;

    if(post.postFilesPath == null || post.postFilesPath.length == 0) {
      return ProfileTextPostCard(postModel: post,
        onPostClick: onPostClick ?? (){},
        onComment: (String comment) {
          postBloc.add(AddComment(
              postModel: post, commentViewModel: createComment(comment, user)));
          if (postAction != null)
            postAction();
        },
        onLike: () {
          postBloc.add(LikePost(postViewModel: post));
          if (postAction != null)
            postAction();
        },
        onShare: (String shareDescription) {
          postBloc.add(SharePost(
              postViewModel: post, shareDescription: shareDescription));
          if (postAction != null)
            postAction();
        },
        onObjection: (String objection) {
          postBloc.add(AddObjection(postModel: post,
              commentViewModel: createComment(objection, user)));
          if (postAction != null)
            postAction();
        },);
    }
    else if(post.postFilesPath[0].endsWith('.mov') || post.postFilesPath[0].endsWith('.mp4'))
      return Container();
    else
      return ProfileDocumentCard(postModel: post,
        onPostClick:onPostClick ?? (){},
        onComment: (String comment){
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
  }




}