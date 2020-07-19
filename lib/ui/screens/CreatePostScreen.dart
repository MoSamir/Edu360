import 'package:edu360/ui/widgets/CreatePostCard.dart';
import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      body: Container(
        child: CreatePostCard(),
      ),
    );
  }
}
