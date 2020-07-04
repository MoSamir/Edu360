import 'package:edu360/blocs/bloc/UserDataBloc.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/ui/widgets/ProfileScreenHeader.dart';
import 'package:edu360/ui/widgets/UserTextPostCard.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin{


  TabController tabController;
  int currentTabIndex = 0 ;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      vsync: this,
        initialIndex: currentTabIndex,
        length:5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(0),
      child: Column(
        children: <Widget>[
          ProfileScreenHeader(
            user: BlocProvider.of<UserDataBloc>(context).authenticationBloc.currentUser,
            isMe: true,
            isMyFriend: true,
            onFollowClicked: (){},
          ),
          Material(
            elevation: 5,
            color: Colors.white,
            child: Container(
              height: 70,
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .8,
                  child: TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),),
                    isScrollable: false,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.transparent,
                    tabs: getTaps(),
                    labelPadding: EdgeInsets.all(0),
                    indicatorPadding: EdgeInsets.all(0),
                    controller: tabController,
                    onTap: (selectedIndex) {
                      currentTabIndex = selectedIndex;
                      setState(() {});
                    },
                    indicatorWeight: 2,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                ),
              ),
            ),
          ),
          GridView.count(crossAxisCount: 2,
          shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0),
            childAspectRatio: .55,
            crossAxisSpacing: 0,
            children: List.generate(25, (index) => UserTextPostCard()),
          )
        ],
      ),
    );
  }

  getTaps() {
    List<Widget> itemsList = List();
    for(int i = 0 ; i < 5 ; i++){
      if(i == currentTabIndex) itemsList.add(
        Container(width: 70, height: 35,  decoration: BoxDecoration(color: AppColors.mainThemeColor,
          borderRadius: BorderRadius.circular(15),),),);
      else
        itemsList.add(Container(width: 35, height: 35,  decoration: BoxDecoration(color: AppColors.white,
          borderRadius: BorderRadius.circular(17.5), border: Border.all(
              color: AppColors.mainThemeColor,width: 1,
            )),),);
    }
    return itemsList;
  }
}
