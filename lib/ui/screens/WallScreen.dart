import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/ui/screens/ExploreScreen.dart';
import 'package:edu360/ui/screens/FeedsScreen.dart';
import 'package:edu360/ui/widgets/post/UserDocumentsPostCard.dart';
import 'package:edu360/ui/widgets/post/UserTextPostCard.dart';
import 'package:edu360/ui/widgets/post/UserVideoPostCard.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
class WallScreen extends StatefulWidget {

  Function moveToScreen;
  WallScreen(this.moveToScreen);

  @override
  _WallScreenState createState() => _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {
  int currentTab = 0 ;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
        color: AppColors.backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
            padding: EdgeInsets.only(top: 20 , bottom: 10 , left: 10 , right: 10),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      currentTab = 0 ;
                      setState(() {});
                    },
                    child: Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: currentTab == 0 ? AppColors.mainThemeColor : AppColors.white,
                      ),
                      child: Center(
                        child: Text(LocalKeys.FEEDS_TITLE , style: TextStyle(
                          fontWeight: currentTab == 0 ? FontWeight.bold : FontWeight.normal,
                          color: currentTab == 0 ? AppColors.white : AppColors.mainThemeColor.withOpacity(.5),
                        ),).tr(),
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  GestureDetector(
                    onTap: (){
                      currentTab = 1 ;
                      setState(() {});
                    },
                    child: Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: currentTab == 1 ? AppColors.mainThemeColor : AppColors.white,
                      ),
                      child: Center(
                        child: Text(LocalKeys.EXPLORE_TITLE , style: TextStyle(
                          fontWeight: currentTab == 1 ? FontWeight.bold : FontWeight.normal,
                          color: currentTab == 1 ? AppColors.white : AppColors.mainThemeColor.withOpacity(.5),
                        ),).tr(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ),
            Expanded(
              child: getScreenBody(),
            ),
          ],
        ),
    );
  }

  getScreenBody() {
    if(currentTab == 0)
      return FeedsScreen();
    else
      return ExploreScreen();
  }
}
