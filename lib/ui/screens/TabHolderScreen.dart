import 'package:edu360/ui/screens/CoursesScreen.dart';
import 'package:edu360/ui/screens/CategoriesScreen.dart';
import 'package:edu360/ui/screens/ExploreScreen.dart';
import 'package:edu360/ui/screens/FeedsScreen.dart';
import 'package:edu360/ui/screens/ProfileScreen.dart';
import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/ui/widgets/EduIconImage.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'CourseOverviewScreen.dart';
import 'CreatePostScreen.dart';
import 'NotificationsScreen.dart';

class TabsHolderScreen extends StatefulWidget {

  int index = 0;
  TabsHolderScreen({this.index});

  @override
  _TabsHolderScreenState createState() => _TabsHolderScreenState();
}

class _TabsHolderScreenState extends State<TabsHolderScreen> {

   void _onPostCreated({bool success}){
    currentVisiblePageIndex = success ? 2 : 0 ;
    setState(() {});
  }

  void moveToScreen(SCREEN screen){
     switch (screen){
       case SCREEN.WALL_SCREEN :
         currentVisiblePageIndex = 0 ;
         break;
       case SCREEN.PROFILE_SCREEN :
         currentVisiblePageIndex = 1 ;
         break;
       case SCREEN.CATEGORIES_SCREEN :
         currentVisiblePageIndex = 2 ;
         break;
       case SCREEN.POST_CREATION_SCREEN :
         currentVisiblePageIndex = 3 ;
         break;
       default:
         currentVisiblePageIndex = 0 ;
     }

     setState(() {});
  }


  List<Widget> screens = [];
  List<BottomNavigationBarItem> barTabs = [];
  static int currentVisiblePageIndex  ;


  @override
  void initState() {
    currentVisiblePageIndex = widget.index ?? 0 ;

    super.initState();
    screens = [
      FeedsScreen(_onPostCreated , moveToScreen),
      NotificationsScreen(moveToScreen),
      ProfileScreen(moveToScreen),
      CoursesScreen(),
    ];

    barTabs = [
      BottomNavigationBarItem(
        title: Container(width: 0,height: 0,),
        activeIcon: EduIconImage(icon: AssetImage(Resources.WALL_ICON_ACTIVE),),
        icon: EduIconImage(icon: AssetImage(Resources.WALL_ICON_INACTIVE),),
      ),
      BottomNavigationBarItem(
        title: Container(width: 0,height: 0,),
        activeIcon: EduIconImage(icon: AssetImage(Resources.NOTIFICATION_ICON_ACTIVE),) ,
        icon: EduIconImage(icon: AssetImage(Resources.NOTIFICATION_ICON_INACTIVE),),
      ),
      BottomNavigationBarItem(

        title: Container(width: 0,height: 0,),
        activeIcon: EduIconImage(icon: AssetImage(Resources.PROFILE_ICON_ACTIVE),) ,
        icon: EduIconImage(icon: AssetImage(Resources.PROFILE_ICON_INACTIVE),),
      ),
      BottomNavigationBarItem(
        title: Container(width: 0,height: 0,),

        activeIcon: EduIconImage(icon: AssetImage(Resources.COURSES_ICON_ACTIVE),) ,
        icon:  EduIconImage(icon: AssetImage(Resources.COURSES_ICON_INACTIVE),)
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: barTabs,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentVisiblePageIndex,
        selectedItemColor: AppColors.black,
        iconSize: 25,
        selectedFontSize: 0,
        onTap: (selectedIndex){
          currentVisiblePageIndex = selectedIndex;
          setState(() {});
        },
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: AppColors.backgroundColor,
            margin: EdgeInsets.only(top: kToolbarHeight + 30),
            child: screens[currentVisiblePageIndex],
          ),
          EduAppBar(
            backgroundColor: AppColors.mainThemeColor,
            icon:  Icon(Icons.search , color: AppColors.mainThemeColor, size: 25,),//SvgPicture.asset( Resources.LOGO_IMAGE_SVG, width: 40, height: 40,),
            actions: <Widget>[
              Image(
                image: AssetImage(Resources.APPBAR_MESSAGE_IMAGE),
                color: Colors.white,
              ),
            ],
            logoWidth: MediaQuery.of(context).size.width / 3,
            logoHeight: 20,
            autoImplyLeading: false,
          ),
        ],
      ),
    );
  }
}

enum SCREEN {
  WALL_SCREEN ,
  PROFILE_SCREEN,
  POST_CREATION_SCREEN,
  CATEGORIES_SCREEN,
}