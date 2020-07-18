import 'package:edu360/utilities/AppStyles.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
class PlaceHolderWidget extends StatelessWidget {

  final Widget placeHolder;
  final Widget placeHolderIcon ;
  PlaceHolderWidget({this.placeHolderIcon , this.placeHolder});


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          placeHolder ,
          SizedBox(height: 5,),
          placeHolderIcon !=null ? placeHolderIcon : Container(width: 0, height: 0,),
        ],
      ),

    );
  }
}
