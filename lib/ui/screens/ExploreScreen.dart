import 'package:edu360/data/models/CategoryPostViewModel.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/data/models/StudyFieldViewModel.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/ui/widgets/CategoryPostsCardWidget.dart';
import 'package:edu360/ui/widgets/EduCircleAvatar.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(LocalKeys.TUTORS_FOR_YOU , style: Styles.baseTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mainThemeColor,
                    ),).tr(),
                    SizedBox(height: 10,),
                    Container(
                      height: 150,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 4,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index){
                              return EduCircleAvatar(
                                showUserInformation: true,
                                userModel: UserViewModel(
                                  profileImagePath: "https://www.pinclipart.com/picdir/middle/142-1421318_abdu-sentamu-person-image-placeholder-clipart.png",
                                ),
                                userRate: index+1,
                              );
                        }),
                    ),
                    SizedBox(height: 10,),
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
            ),
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  return CategoryPostsCardWidget(
                    category: CategoryPostViewModel(
                      fieldPosts: [PostViewModel(
                        contentType: ContentType.TEXT_POST,
                        postBody: "Hello World",
                      )],
                      studyField: StudyFieldViewModel(
                        studyFieldId: 1,
                        studyFieldDescAr: "عربي",
                        studyFieldNameEn: "Science",
                      ),
                    ),
                  );
                } , itemCount: 5,),
            ),
            SizedBox(height: 100,)
          ],
        ),
      ),
    );
  }
}
