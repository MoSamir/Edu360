import 'package:edu360/data/models/CommentViewModel.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {

  final CommentViewModel comment;
  CommentWidget({this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(width: .5, color: comment.isObjection ? AppColors.redBackgroundColor : AppColors.wordBackgroundColor)),
      elevation: 2,
      shadowColor: AppColors.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: FadeInImage.assetNetwork(placeholder: Resources.USER_PLACEHOLDER_IMAGE, image: comment.ownerImagePath , fit: BoxFit.cover,),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text(comment.ownerName),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Text(comment.commentText),
              SizedBox(height: 5,),
            ],
          ),
        ),
      ),
    );
  }
}
