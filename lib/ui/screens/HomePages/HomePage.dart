import 'package:edu360/ui/screens/HomePages/AllCouses.dart';
import 'package:edu360/ui/screens/HomePages/AllDocuments.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:edu360/ui/screens/HomePages/AllContent.dart';

import 'AllPeople.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 5,
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar:
            AppBar(
              backgroundColor: AppColors.mainThemeColor,
              title: Image(image: AssetImage(Resources.REF360_IMAGE )),
              actions: <Widget>[ Image(image: AssetImage(Resources.COMMENT_IMAGE ),color: Colors.white,),],
            ),
              body: Stack(
                children: <Widget>[
                  customAppBar(),
                ],
              ),),
        ));
  }

  Widget customAppBar() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          child: customTextFormSearch(),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
        ),

        tabBarWidget(),

        tabBarPages()
      ],
    );
  }

  Widget customTextFormSearch() {
    return Row(

      children: <Widget>[
        Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width * .70,
            child: TextField(
                decoration: InputDecoration(
                  fillColor: Colors.red,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  hintText: 'What are you looking for?',
                ))),
        Spacer(),
        Image(
          image: AssetImage(Resources.ICON_1_IMAGE),),
      ],
    );
  }

  Widget tabBarWidget() {
    return   Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          isScrollable: true,
          labelColor: AppColors.mainThemeColor,
          indicatorColor: AppColors.mainThemeColor,
          unselectedLabelColor: AppColors.mainThemeColor.withOpacity(0.7),
          tabs: [
            Tab(
              text: 'All',
            ),
            Tab(
              text: 'People',
            ),
            Tab(
              text: 'Teachers',
            ),
            Tab(
              text: 'Documents',
            ),
            Tab(
              text: 'Courses',
            ),
          ], // list of tabs
        ),
      ),
    );
  }


  Widget tabBarPages() {
    return Expanded(
      child: TabBarView(
        children: [
          AllContent(),
          AllPeople(),
          AllPeople(),
          AllDocuments(),
          AllCouses(),
        ],
      ),
    );
  }
}
