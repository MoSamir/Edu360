import 'dart:io';

import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:edu360/blocs/events/AuthenticationEvents.dart';
import 'package:edu360/blocs/events/HomePostsEvent.dart';
import 'package:edu360/blocs/events/UserProfileEvents.dart';
import 'package:edu360/blocs/states/UserProfileStates.dart';
import 'package:edu360/ui/screens/CoursesScreen.dart';
import 'package:edu360/ui/screens/FeedsScreen.dart';
import 'package:edu360/ui/screens/ProfileScreen.dart';
import 'package:edu360/ui/screens/SplashScreen.dart';
import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/ui/widgets/EduIconImage.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'ContactUsScreen.dart';
import 'NotificationsScreen.dart';

class TabsHolderScreen extends StatefulWidget {

  int index = 0;
  TabsHolderScreen({this.index});
  static File profileImage , coverImage;

  @override
  _TabsHolderScreenState createState() => _TabsHolderScreenState();
}

class _TabsHolderScreenState extends State<TabsHolderScreen> with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;



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
    super.build(context);
    return BlocConsumer(
      listener: (context, state){
        if(state is ProfileImageUpdated){
          BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc.add(UpdateUserInformation());
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> SplashScreen()) , (_)=> false);
        }
      },
      builder: (context, state){
        return ModalProgressHUD(
          inAsyncCall: state is UserProfileLoading,
          progressIndicator: Container(width: 0, height: 0,),
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              items: barTabs,
              key: GlobalKey(),
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              currentIndex: currentVisiblePageIndex,
              selectedItemColor: AppColors.black,
              iconSize: 25,
              selectedFontSize: 0,
              onTap: (selectedIndex) async{
                if(currentVisiblePageIndex == 2){ // profile screen
                  if(TabsHolderScreen.profileImage != null || TabsHolderScreen.coverImage != null){
                    bool confirmedChanges = await showDialog(context: context, barrierDismissible: true ,builder: (context) => AlertDialog(
                      elevation: 2,
                      actions: <Widget>[
                        FlatButton(
                          color: AppColors.mainThemeColor,
                          child: Text((LocalKeys.CONFIRM_LABEL).tr() , style: TextStyle(
                            color: AppColors.white,
                          ),),
                        onPressed: (){
                            Navigator.pop(context , true);
                        },
                        ),
                        FlatButton(
                          color: AppColors.redBackgroundColor,
                          child: Text((LocalKeys.CANCEL_LABEL).tr() , style: TextStyle(
                            color: AppColors.white,
                          ),),
                          onPressed: (){
                            Navigator.pop(context , false);
                          },
                        ),
                      ],
                      content: Container(
                        height: 25,
                        child: Center(
                          child: Text((LocalKeys.SET_IMAGE_MESSAGE).tr() , textAlign: TextAlign.center,),
                        ),
                      ),
                      title: Text((LocalKeys.CONFIRM_CHANGES_HEADER).tr(), textAlign: TextAlign.center , style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),),
                    ));
                    if(confirmedChanges){
                      if(TabsHolderScreen.profileImage != null || TabsHolderScreen.coverImage != null) {
                        BlocProvider
                            .of<AppDataBloc>(context)
                            .userDataBloc
                            .userProfileBloc
                            .add(UpdateProfileImage(
                            userProfileImage: TabsHolderScreen.profileImage,
                            userCoverImage: TabsHolderScreen.coverImage,
                            nextPageIndex: selectedIndex));
                      }
                    } else {
                      TabsHolderScreen.profileImage = null ;
                      TabsHolderScreen.coverImage = null ;
                      currentVisiblePageIndex = selectedIndex;
                      setState(() {});
                    }
                  }
                  else {
                    TabsHolderScreen.profileImage = null ;
                    TabsHolderScreen.coverImage = null ;
                    currentVisiblePageIndex = selectedIndex;
                    setState(() {});
                  }
                }
                else {
                  TabsHolderScreen.profileImage = null ;
                  TabsHolderScreen.coverImage = null ;
                  currentVisiblePageIndex = selectedIndex;
                  setState(() {});
                }
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
                    IconButton(
                      icon: Icon(Icons.error_outline , color: AppColors.redBackgroundColor, size: 25,),
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ContactUsScreen()));
                      },
                    ),
                  ],
                  logoWidth: MediaQuery.of(context).size.width / 3,
                  logoHeight: 20,
                  autoImplyLeading: false,
                ),
              ],
            ),
          ),
        );
      },
      bloc: BlocProvider.of<AppDataBloc>(context).userDataBloc.userProfileBloc,
    );
  }
}

enum SCREEN {
  WALL_SCREEN ,
  PROFILE_SCREEN,
  POST_CREATION_SCREEN,
  CATEGORIES_SCREEN,
}