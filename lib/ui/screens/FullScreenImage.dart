import 'dart:io';


import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:flutter/material.dart';

import 'CreatePostScreen.dart';

class FullScreenImage extends StatelessWidget {
  final String imagePath;
  final ImageSource source;
  FullScreenImage({this.imagePath, this.source});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EduAppBar(autoImplyLeading: true, backgroundColor: AppColors.mainThemeColor,),
      body: source == ImageSource.FILE ? Hero(
          tag: imagePath,
          child: Image.file(File(imagePath) , height: MediaQuery.of(context).size.height ,width: MediaQuery.of(context).size.width, fit: BoxFit.fill)) :
            source == ImageSource.NETWORK ? Hero(
                tag: imagePath,
                child: Image.network(imagePath , height: MediaQuery.of(context).size.height , width: MediaQuery.of(context).size.width, fit: BoxFit.fill,))  : Container()
    );
  }
}
