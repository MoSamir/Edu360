import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:edu360/blocs/bloc/UserDataBloc.dart';
import 'package:edu360/blocs/bloc/UserProfileBloc.dart';
import 'package:edu360/blocs/events/HomePostsEvent.dart';
import 'package:edu360/blocs/events/UserProfileEvents.dart';
import 'package:edu360/blocs/states/UserProfileStates.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/ui/UIHelper.dart';
import 'package:edu360/ui/screens/SinglePostScreen.dart';

import 'package:edu360/ui/widgets/PlaceHolderWidget.dart';
import 'package:edu360/ui/widgets/ProfileScreenHeader.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:easy_localization/easy_localization.dart';
class ProfileScreen extends StatefulWidget {

  final Function moveToScreen;
  ProfileScreen(this.moveToScreen);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin{


  TabController tabController;
  UserViewModel user;
  int currentTabIndex = 0 ;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      vsync: this,
        initialIndex: currentTabIndex,
        length:4,
    );
  }
  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc.currentUser;
    return BlocConsumer(
      bloc: BlocProvider.of<AppDataBloc>(context).userDataBloc.userProfileBloc,
      listener: (context, state){},
      builder: (context, state){
        return ModalProgressHUD(
          inAsyncCall: state is UserProfileLoading,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(0),
            child: Column(
              children: <Widget>[
                ProfileScreenHeader(
                  user: user,
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
                        width: MediaQuery.of(context).size.width * .5,
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
                SizedBox(height: 5,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8 , vertical: 8),
                  child: getPostsView(currentTabIndex),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  getTaps() {
    List<Widget> itemsList = List();
    for(int i = 0 ; i < 4 ; i++){
      if(i == currentTabIndex) itemsList.add(
        Container(width: 70, height: 35, padding: EdgeInsets.all(0) ,decoration: BoxDecoration(color: AppColors.mainThemeColor,
          borderRadius: BorderRadius.circular(15),),),);
      else
        itemsList.add(Container(width: 35, height: 35, padding: EdgeInsets.all(0), decoration: BoxDecoration(color: AppColors.white,
          borderRadius: BorderRadius.circular(17.5), border: Border.all(
              color: AppColors.mainThemeColor,width: 1,
            )),),);
    }
    return itemsList;
  }
  getPostsView(int currentTabIndex) {
    UserProfileBloc bloc = BlocProvider.of<AppDataBloc>(context).userDataBloc.userProfileBloc;
    if(currentTabIndex == 0){
      return bloc.userPosts.length > 0 ?
      GridView.count(
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: .8,
          crossAxisCount: 2,
          primary: false,
          children: List.generate(
            bloc.userPosts!= null ? bloc.userPosts.length : 0,
                (index) {
                  bloc.userPosts[index].ownerName = user.userFullName;
                  bloc.userPosts[index].ownerImagePath = user.profileImagePath;
                  bloc.userPosts[index].postOwnerId = user.userId;
              return UIHelper.getProfilePostView(bloc.userPosts[index], context,postAction: (){
                setState(() {});
              }, onPostClick: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SinglePostScreen((){
                  bloc.add(LoadUserProfile());
                  BlocProvider.of<AppDataBloc>(context).userDataBloc.homePostsBloc.add(LoadHomeUserPosts());
                } ,post: bloc.userPosts[index],)));
              },
              );
            },
          ))  : Container(
          color: AppColors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .4,
          child: PlaceHolderWidget(placeHolder: Text(LocalKeys.WHOLE_POSTS_PLACE_HOLDER).tr(),));
    }
    else if(currentTabIndex == 1){
      return bloc.userTextPosts.length > 0 ?
      GridView.count(

        padding: EdgeInsets.all(0),
          shrinkWrap: true,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: .8,
          crossAxisCount: 2,

          primary: false,
          children: List.generate(
            bloc.userTextPosts != null ? bloc.userTextPosts.length : 0, (index) {
            bloc.userTextPosts[index].ownerName = user.userFullName;
            bloc.userTextPosts[index].ownerImagePath = user.profileImagePath;
            bloc.userTextPosts[index].postOwnerId = user.userId;
              return UIHelper.getProfilePostView(bloc.userTextPosts[index], context , postAction: (){
                setState(() {});
              }, onPostClick: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SinglePostScreen((){
                  bloc.add(LoadUserProfile());
                  BlocProvider.of<AppDataBloc>(context).userDataBloc.homePostsBloc.add(LoadHomeUserPosts());
                },post: bloc.userPosts[index],)));
              },);
            },
          ))  : Container(
    color: AppColors.white,
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * .4,
    child: PlaceHolderWidget(placeHolder: Text(LocalKeys.TEXT_POSTS_PLACE_HOLDER).tr(),));
    }
    else if(currentTabIndex == 2){
      return bloc.userFilePosts.length > 0 ? GridView.count(crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0),
        childAspectRatio: .8,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: List.generate(bloc.userFilePosts.length , (index) {
          bloc.userFilePosts[index].ownerName = user.userFullName;
          bloc.userFilePosts[index].ownerImagePath = user.profileImagePath;
          bloc.userFilePosts[index].postOwnerId = user.userId;
          return UIHelper.getProfilePostView(bloc.userFilePosts[index], context , postAction: (){
            setState(() {});
          }, onPostClick: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SinglePostScreen((){
              bloc.add(LoadUserProfile());
              BlocProvider.of<AppDataBloc>(context).userDataBloc.homePostsBloc.add(LoadHomeUserPosts());
            },post: bloc.userPosts[index],)));
          },);
        })
      ) : Container(
        color: AppColors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .4,
          child: PlaceHolderWidget(placeHolder: Text(LocalKeys.DOCUMENT_POSTS_PLACE_HOLDER).tr(),));
    }
    else {
     return Container(
         color: AppColors.white,
         width: MediaQuery.of(context).size.width,
         height: MediaQuery.of(context).size.height * .4,
         child: PlaceHolderWidget(placeHolder: Text('Edit Profile coming soon')));
    }
  }

}