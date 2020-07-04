import 'package:edu360/ui/screens/FeedsScreen.dart';
import 'package:edu360/ui/screens/ProfileScreen.dart';
import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:flutter/material.dart';

import 'CreatePostScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  List<Widget> screens = [
    FeedsScreen(),
    ProfileScreen(),
    CreatePostScreen(),
  ];
  List<BottomNavigationBarItem> barTabs = [
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
      icon: Icon(Icons.add_alert,size: 25,),
    ),
  ];
  int currentVisiblePageIndex  = 0 ;

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
