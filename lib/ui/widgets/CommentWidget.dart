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
      elevation: 2,
      shadowColor: AppColors.backgroundColor,
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
                      image: DecorationImage(
                        image: comment.ownerImagePath != null && comment.ownerImagePath.length > 0 ? NetworkImage(
                          comment.ownerImagePath,
                        ) : AssetImage(Resources.USER_PLACEHOLDER_IMAGE),
                      ),
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
    );
  }
}
