import 'package:edu360/ui/widgets/CreatePostCard.dart';
import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {

  final Function createPostResult ;
  final Function moveToScreen;
  CreatePostScreen(this.createPostResult , this.moveToScreen);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {


  onCancelClicked(){
    Navigator.of(context).pop();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EduAppBar(

        logoHeight: 20,
        logoWidth: MediaQuery.of(context).size.width * .25,
        backgroundColor: AppColors.mainThemeColor,
        autoImplyLeading: true,

      ),
      extendBody: false,
      body: Container(
        child: CreatePostCard(onFinish: widget.createPostResult, onCancel: onCancelClicked),
      ),
    );
  }
}
