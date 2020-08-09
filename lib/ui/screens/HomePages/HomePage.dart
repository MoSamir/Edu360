import 'package:edu360/blocs/bloc/ExploreBloc.dart';
import 'package:edu360/blocs/events/ExploreEevnts.dart';
import 'package:edu360/blocs/states/ExploreStates.dart';
import 'package:edu360/ui/screens/HomePages/AllCourses.dart';
import 'package:edu360/ui/screens/HomePages/AllDocuments.dart';
import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'AllPeople.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ExploreBloc _exploreBloc = ExploreBloc();


  @override
  void initState() {
    super.initState();
    _exploreBloc.add(LoadExploreInformation());
  }

  @override
  void dispose() {
    _exploreBloc.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
          length: 4,
          initialIndex: 0,
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: EduAppBar(
              logoWidth: MediaQuery.of(context).size.width / 3,
              logoHeight: 20,
              backgroundColor: AppColors.mainThemeColor,
              actions: <Widget>[ Image(image: AssetImage(Resources.APPBAR_MESSAGE_IMAGE),color: Colors.white,),],
            ),
              body: BlocConsumer(
                builder: (context, state){
                  return ModalProgressHUD(
                    inAsyncCall: state is ExploreScreenLoading,
                    child: customAppBar()
                  );
                },
                bloc: _exploreBloc,
                listener: (context , state){},
              ),
        ),
    );
  }

  Widget customAppBar() {
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          child: customTextFormSearch(),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
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
      width: MediaQuery.of(context).size.width,
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
        child: Center(
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: true,
            labelColor: AppColors.mainThemeColor,
            indicatorColor: AppColors.mainThemeColor,
            unselectedLabelColor: AppColors.mainThemeColor.withOpacity(0.7),
            tabs: [
              Tab(
                text: 'Documents',
              ),
              Tab(
                text: 'People',
              ),
              Tab(
                text: 'Teachers',
              ),
              Tab(
                text: 'Courses',
              ),
            ], // list of tabs
          ),
        ),
      ),
    );
  }


  Widget tabBarPages() {
    return Expanded(
      child: TabBarView(
        children: [
          BlocProvider.value(
            value: _exploreBloc,
            child: AllDocuments(_exploreBloc.posts),
          ),
          BlocProvider.value(
            value: _exploreBloc,
            child: AllPeople(_exploreBloc.users),
          ),
          BlocProvider.value(
            value: _exploreBloc,
            child: AllPeople(_exploreBloc.teachers),
          ),
          BlocProvider.value(
            value: _exploreBloc,
            child: AllCourses(_exploreBloc.courses),
          ),
        ],
      ),
    );
  }
}
