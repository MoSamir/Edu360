import 'dart:io';

import 'package:edu360/data/models/PostViewModel.dart';

abstract class CreateNewContentEvents {}


class CreatePost extends CreateNewContentEvents{
  final PostViewModel postViewModel ;
  final List<File> postDocuments;
  CreatePost({this.postViewModel , this.postDocuments});

}