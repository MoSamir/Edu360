import 'package:edu360/ui/screens/CategoriesScreen.dart';
import 'package:edu360/ui/screens/WallScreen.dart';
import 'package:edu360/ui/screens/ProfileScreen.dart';
import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:flutter/material.dart';

import 'CreatePostScreen.dart';

class TabsHolderScreen extends StatefulWidget {
  @override
  _TabsHolderScreenState createState() => _TabsHolderScreenState();
}

class _TabsHolderScreenState extends State<TabsHolderScreen> {





   _onPostCreated({bool success}){
    currentVisiblePageIndex = success ? 1 : 0 ;
    setState(() {});
  }

  _moveToScreen(SCREEN screen){
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
  static int currentVisiblePageIndex  = 0 ;


  @override
  void initState() {
    super.initState();
    screens = [
      WallScreen(_moveToScreen),
      ProfileScreen(_moveToScreen),
      CategoriesScreen(_moveToScreen),
      CreatePostScreen(_onPostCreated , _moveToScreen),
    ];

    barTabs = [
      BottomNavigationBarItem(
        title: Container(width: 0,height: 0,),
        icon: Icon(Icons.home,size: 25,),
      ),
      BottomNavigationBarItem(
        title: Container(width: 0,height: 0,),
        icon: Icon(Icons.person,size: 25,),
      ),
      BottomNavigationBarItem(
        title: Container(width: 0,height: 0,),
        icon: Icon(Icons.dashboard ,size: 25,),
      ),
      BottomNavigationBarItem(
        title: Container(width: 0,height: 0,),
        icon: Icon(Icons.add_alert,size: 25,),
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
        selectedItemColor: AppColors.mainThemeColor,
        iconSize: 30,
        selectedFontSize: 40,
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
          EduAppBar(icon: Icons.search,),
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