import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/ui/widgets/post/UserDocumentsPostCard.dart';
import 'package:edu360/ui/widgets/post/UserTextPostCard.dart';
import 'package:edu360/ui/widgets/post/UserVideoPostCard.dart';
import 'package:flutter/material.dart';

class FeedsScreen extends StatefulWidget {
  @override
  _FeedsScreenState createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 0 , left: 10, right: 10),
      itemBuilder: (context , index) {
        return index == 1 ? UserDocumentsPostCard(postModel: PostViewModel(),) : index == 2 ? UserVideoPostCard(postModel: PostViewModel(),) : UserTextPostCard(postModel: PostViewModel(),);
      } , itemCount: 3, shrinkWrap: true,);
  }
}
