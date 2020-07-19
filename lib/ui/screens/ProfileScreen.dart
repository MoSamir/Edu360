import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:edu360/blocs/bloc/UserDataBloc.dart';
import 'package:edu360/blocs/bloc/UserProfileBloc.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/ui/UIHelper.dart';
import 'package:edu360/ui/widgets/ProfileScreenHeader.dart';
import 'package:edu360/utilities/AppStyles.dart';
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
            user: BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc.currentUser,
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
          getPostsView(currentTabIndex),
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
  getPostsView(int currentTabIndex) {
    UserProfileBloc bloc = BlocProvider.of<AppDataBloc>(context).userDataBloc.userProfileBloc;
    if(currentTabIndex == 0){
      return GridView.count(crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0),
        crossAxisSpacing: 0,
        children: List.generate(bloc.userPosts.length , (index) => UIHelper.getPostView(bloc.userPosts[index], context)),
      );
    }
    else if(currentTabIndex == 1){
      return GridView.count(crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0),
        childAspectRatio: .55,
        crossAxisSpacing: 0,
        children: List.generate(bloc.userTextPosts.length , (index) => UIHelper.getPostView(bloc.userTextPosts[index], context ,)),
      );
    }
    else if(currentTabIndex == 2){

      return GridView.count(crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0),
        childAspectRatio: .55,
        crossAxisSpacing: 0,
        children: List.generate(bloc.userFilePosts.length , (index) => UIHelper.getPostView(bloc.userFilePosts[index], context ,)),
      );
    }
    else if(currentTabIndex == 3){
      return GridView.count(crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0),
        childAspectRatio: .55,
        crossAxisSpacing: 0,
        children: List.generate(bloc.userVideoPosts.length , (index) => UIHelper.getPostView(bloc.userVideoPosts[index], context ,)),
      );
    }
    else {
     return Container();
    }
  }
}
