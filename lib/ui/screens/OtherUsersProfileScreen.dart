import 'package:edu360/blocs/bloc/AppDataBloc.dart';

import 'package:edu360/blocs/bloc/UserProfileBloc.dart';
import 'package:edu360/blocs/events/UserProfileEvents.dart';
import 'package:edu360/blocs/states/UserProfileStates.dart';
import 'package:edu360/ui/UIHelper.dart';

import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/ui/widgets/PlaceHolderWidget.dart';
import 'package:edu360/ui/widgets/ProfileScreenHeader.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:easy_localization/easy_localization.dart';
class OtherUsersProfileScreen extends StatefulWidget {

  final int userId;
  OtherUsersProfileScreen({this.userId});


  @override
  _OtherUsersProfileScreenState createState() => _OtherUsersProfileScreenState();
}

class _OtherUsersProfileScreenState extends State<OtherUsersProfileScreen> with SingleTickerProviderStateMixin{
  UserProfileBloc bloc ;

  TabController tabController;
  int currentTabIndex = 0 ;
  @override
  void initState() {
    super.initState();

    bloc = UserProfileBloc();

    bloc.add(LoadOtherUsersProfile(userId: widget.userId));
    tabController = TabController(
      vsync: this,
        initialIndex: currentTabIndex,
        length:3,
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: EduAppBar(
        backgroundColor: AppColors.mainThemeColor,
        actions: <Widget>[
          Image(
            image: AssetImage(Resources.COMMENT_IMAGE),
            color: Colors.white,
          ),
        ],
        logoWidth: MediaQuery.of(context).size.width / 3,
        logoHeight: 20,
        autoImplyLeading: true,
      ),
      body: BlocConsumer(
        bloc: bloc,
        listener: (context, state){},
        builder: (context, state){
          return ModalProgressHUD(
            inAsyncCall: state is UserProfileLoading,
            child: bloc.userViewModel != null ? SingleChildScrollView(
              padding: EdgeInsets.all(0),
              child: Column(
                children: <Widget>[
                  Container(
                    key: GlobalKey(),
                    child: StreamBuilder<bool>(
                      stream: bloc.followStream,
                      initialData: true,
                      builder: (context, snapshot) {
                        return ProfileScreenHeader(
                          user: bloc.userViewModel.userId != null ? bloc.userViewModel : UserProfileBloc(),
                          isMe: BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc.currentUser.userId == widget.userId,
                          isMyFriend: bloc.userViewModel.isFollowingLoggedInUser ?? false,
                          onFollowClicked: (){
                            if(bloc.userViewModel.isFollowingLoggedInUser ?? false)
                              bloc.add(UnfollowUser(userId:widget.userId));
                            else
                              bloc.add(FollowUser(userId:widget.userId));
                          },
                        );
                      }
                    ),
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
                  getPostsView(currentTabIndex),
                ],
              ),
            ) : Container(),
          );
        },
      ),
    );
  }
  getTaps() {
    List<Widget> itemsList = List();
    for(int i = 0 ; i < 3 ; i++){
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

    if(currentTabIndex == 0){
      return bloc.userPosts.length > 0 ?
      GridView.count(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(
              horizontal: 10.0, vertical: 20.0),
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 17.0,
          childAspectRatio: 0.545,
          crossAxisCount: 2,
          primary: false,
          children: List.generate(
            bloc.userPosts!= null ? bloc.userPosts.length : 0,
                (index) {
              bloc.userPosts[index].ownerName = bloc.userViewModel.userFullName;
              bloc.userPosts[index].ownerImagePath = bloc.userViewModel.profileImagePath;
              bloc.userPosts[index].postOwnerId = bloc.userViewModel.userId;
              return UIHelper.getProfilePostView(bloc.userPosts[index], context,postAction: (){
                setState(() {});
              });
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
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(
              horizontal: 10.0, vertical: 20.0),
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 17.0,
          childAspectRatio: 0.545,
          crossAxisCount: 2,
          primary: false,
          children: List.generate(
            bloc.userTextPosts != null ? bloc.userTextPosts.length : 0, (index) {

            bloc.userTextPosts[index].ownerName = bloc.userViewModel.userFullName;
            bloc.userTextPosts[index].ownerImagePath = bloc.userViewModel.profileImagePath;
            bloc.userTextPosts[index].postOwnerId = bloc.userViewModel.userId;

            return UIHelper.getProfilePostView(bloc.userTextPosts[index], context);
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
          childAspectRatio: 1.2,
          crossAxisSpacing: 0,
          children: List.generate(bloc.userFilePosts.length , (index) {
            bloc.userFilePosts[index].ownerName = bloc.userViewModel.userFullName;
            bloc.userFilePosts[index].ownerImagePath = bloc.userViewModel.profileImagePath;
            bloc.userFilePosts[index].postOwnerId = bloc.userViewModel.userId;
            return UIHelper.getProfilePostView(bloc.userFilePosts[index], context , postAction: (){
              setState(() {});
            });
          })
      ) : Container(
          color: AppColors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .4,
          child: PlaceHolderWidget(placeHolder: Text(LocalKeys.DOCUMENT_POSTS_PLACE_HOLDER).tr(),));
    }
  }

}