import 'package:edu360/blocs/bloc/ExploreBloc.dart';
import 'package:edu360/blocs/events/ExploreEevnts.dart';
import 'package:edu360/blocs/states/ExploreStates.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'AllCourses.dart';
import 'AllDocuments.dart';
import 'AllPeople.dart';
import 'SearchDelegate.dart';

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
          length: 3,
          initialIndex: 1,
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: EduAppBar(
              logoWidth: MediaQuery.of(context).size.width / 3,
              logoHeight: 20,
              backgroundColor: AppColors.mainThemeColor,
              //actions: <Widget>[ Image(image: AssetImage(Resources.APPBAR_MESSAGE_IMAGE),color: Colors.white,),],
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
          padding: EdgeInsets.all(8),
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

  Widget customTextFormSearch(){
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: ()async{
            await showSearch(context: context, delegate: ContentSearch(
              coursesSpace: _exploreBloc.courses,
              postsSpace: _exploreBloc.posts,
              teachersSpace: _exploreBloc.teachers,
              userSpace: _exploreBloc.users,
            ));
          },
          child: Container(
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
              width: MediaQuery.of(context).size.width * .95,
              child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    fillColor: Colors.red,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    hintText: (LocalKeys.WHAT_YOU_LOOKING_FOR).tr(),
                  ))),
        ),
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
//              Tab(
//                text: (LocalKeys.DOCUMENTS).tr(),
//              ),
              Tab(
                text: (LocalKeys.PEOPLE).tr(),
              ),
              Tab(
                text: (LocalKeys.TEACHERS).tr(),
              ),
              Tab(
                text: (LocalKeys.COURSES).tr(),
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
//          BlocProvider.value(
//            value: _exploreBloc,
//            child: AllDocuments(_exploreBloc.posts),
//          ),
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
