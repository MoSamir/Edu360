import 'package:edu360/utilities/AppStyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EduIconImage extends StatelessWidget {

  final double size ;
  final Color color ;
  final ImageProvider icon;
  final Function onTap ;
  EduIconImage({this.size , this.color , this.icon , this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2),
        height: size ?? 25,
        width: size ?? 25,
        decoration: BoxDecoration(
          color: color?? AppColors.transparent,
         // borderRadius: BorderRadius.all(Radius.circular(size != null ? size/2.0 : 12.5)),
          image: DecorationImage(image: icon , fit: BoxFit.scaleDown),
        ),
      );
  }
}
