import 'package:edu360/data/models/CategoryPostViewModel.dart';
import 'package:edu360/ui/UIHelper.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:math' as Math;
class CategoryPostsCardWidget extends StatefulWidget {
  final CategoryPostViewModel category;
  CategoryPostsCardWidget({this.category});

  @override
  _CategoryPostsCardWidgetState createState() => _CategoryPostsCardWidgetState();
}

class _CategoryPostsCardWidgetState extends State<CategoryPostsCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(widget.category.studyField.studyFieldNameEn , style: Styles.baseTextStyle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.mainThemeColor,
            ),),
            ...getPosts(),
            GestureDetector(
              onTap: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(LocalKeys.SHOW_MORE , style: Styles.baseTextStyle.copyWith(
                    color: AppColors.mainThemeColor,
                  ),).tr(),
                  SizedBox(width: 5,),
                  Icon(Icons.arrow_forward_ios , color: AppColors.mainThemeColor, size: 15,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getPosts() {
    List<Widget> posts = List();
    if(widget.category!= null && widget.category.fieldPosts != null) {
      for (int i = 0; i < Math.min(widget.category.fieldPosts.length, 2); i++)
        posts.add(UIHelper.getPostView(widget.category.fieldPosts[i], context ,elevation: 0));
    }
//    return Wrap(
//      children: ,
//      direction: Axis.vertical,
//    );
//
    return posts;
  }
}
