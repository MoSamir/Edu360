import 'dart:io';

import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:edu360/blocs/bloc/UserProfileBloc.dart';
import 'package:edu360/blocs/events/AuthenticationEvents.dart';
import 'package:edu360/blocs/events/HomePostsEvent.dart';
import 'package:edu360/blocs/events/UserProfileEvents.dart';
import 'package:edu360/blocs/states/AuthenticationStates.dart';
import 'package:edu360/blocs/states/UserProfileStates.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/ui/UIHelper.dart';
import 'package:edu360/ui/screens/LandingScreen.dart';
import 'package:edu360/ui/screens/SinglePostScreen.dart';
import 'package:edu360/ui/widgets/EduRadioButtonListTile.dart';

import 'package:edu360/ui/widgets/PlaceHolderWidget.dart';
import 'package:edu360/ui/widgets/ProfileScreenHeader.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/Constants.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:easy_localization/easy_localization.dart';

import 'TabHolderScreen.dart';
class ProfileScreen extends StatefulWidget {

  final Function moveToScreen;
  ProfileScreen(this.moveToScreen);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin{



  String currentLocale ;
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
    currentLocale = Constants.CURRENT_LOCALE;
    try{
      BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc.listen((state) {

        print("Profile State => $state");

        if(state is UserAuthenticated){
          if(BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc.currentUser.isAnonymous()){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> LandingScreen()), (route) => false);
          }
        }
      });
    } catch(exception){}
  }

  @override
  Widget build(BuildContext context) {

    user = BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc.currentUser;
    return Container(
      color: AppColors.backgroundColor,
      child: BlocConsumer(
        bloc: BlocProvider.of<AppDataBloc>(context).userDataBloc.userProfileBloc,
        listener: (context, state){},
        builder: (context, state){
          return ModalProgressHUD(
            inAsyncCall: state is UserProfileLoading,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 15,),
                  ProfileScreenHeader(
                    user: user,
                    userProfileImage: TabsHolderScreen.profileImage,
                    userCoverFileImage: TabsHolderScreen.coverImage,
                    isMe: true,
                    isMyFriend: true,
                    onEditProfileImageClicked: _changeUserProfileImage,
                    onEditProfileCoverImageClicked: _changeUserProfileCoverImage,
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
                    padding: EdgeInsets.symmetric(horizontal: 0 , vertical: 0),
                    child: getPostsView(currentTabIndex),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  getTaps() {
    List<Widget> itemsList = List();
    for(int i = 0 ; i < 4 ; i++){
      if(i == currentTabIndex) itemsList.add(
        Container(width: 80, height: 35, padding: EdgeInsets.all(0) ,decoration: BoxDecoration(color: AppColors.mainThemeColor,
          borderRadius: BorderRadius.circular(15),), child: Center(child: Text(getTabTitle(currentTabIndex) , style: Styles.studyTextStyle.copyWith(fontWeight: FontWeight.normal),),), ),);
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
                  bloc.add(LoadUserProfile(userId: BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc.currentUser.userId));
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
                  bloc.add(LoadUserProfile(userId: BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc.currentUser.userId));
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
              bloc.add(LoadUserProfile(userId: BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc.currentUser.userId));
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
         color: AppColors.backgroundColor,
         width: MediaQuery.of(context).size.width,
         child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: GestureDetector(
                 onTap: showLocalePickerDialog,
                 child: Row(
                   children: <Widget>[
                     ClipRRect(
                       borderRadius: BorderRadius.all(Radius.circular(20)),
                       child: Image.asset('assets/images/flags/${Constants.CURRENT_LOCALE}.png' , fit: BoxFit.cover, width: 40, height: 40,),
                     ),
                     SizedBox(width: 10,),
                     Text( EasyLocalization.of(context).locale.languageCode == "en" ?  LocalKeys.EN : LocalKeys.AR)
                   ],
                 ),
               ),
             ),
             Padding(
               padding: EdgeInsets.symmetric(horizontal: 8),
               child: FlatButton(
                 padding: EdgeInsets.all(0),
                 onPressed: (){
                   BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc.add(Logout());
                 },
                 child: Text((LocalKeys.LOGOUT).tr() , textAlign: TextAlign.start,),
               ),
             ),
             Padding(
               padding: const EdgeInsets.symmetric(vertical:8.0),
               child: Center(
                 child: Text('v1.0.8' , textAlign: TextAlign.center, style: TextStyle(
                   color: Colors.grey,
                 ),),
               ),
             ),
           ],
         ),);
         //PlaceHolderWidget(placeHolder: Text('Edit Profile coming soon')));
    }
  }

  String getTabTitle(int currentTabIndex) {
    if(currentTabIndex == 0)
      return (LocalKeys.ALL_TITLE).tr();
    if(currentTabIndex == 1)
      return (LocalKeys.TEXT_POSTS_TITLE).tr();
    if(currentTabIndex == 2)
      return (LocalKeys.DOCUMENTS_POSTS_TITLE).tr();
    if(currentTabIndex == 3)
      return (LocalKeys.EDIT_PROFILE_TITLE).tr();
    return "";
  }

  showLocalePickerDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                //shrinkWrap: true,
                children: getLanguagesList(),
              ),
            ),
          );
        });
  }
  getLanguagesList() {
    List<Widget> languagesRows = List();
    languagesRows.add(languageRow(
      flagAsset: Resources.ARABIC_LOCALE_FLAG,
      locale: LocalKeys.AR,
    ));
    languagesRows.add(languageRow(
      flagAsset: Resources.ENGLISH_LOCALE_FLAG,
      locale: LocalKeys.EN,
    ));

    return languagesRows;
  }

  Widget languageRow({String locale , String flagAsset}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RadioButtonListTile(
        key: GlobalKey(),
        activeColor: Colors.grey[900],
        title: Row(
          children: <Widget>[
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('$flagAsset'),
                    fit: BoxFit.cover),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              locale,
            ),
          ],
        ),
        value: flagAsset,
        onChanged: (langVal) {
          print(langVal);

          String localeName = langVal.toString().split('/')[langVal.toString().split('/').length -1].split('.')[0];
          EasyLocalization.of(context).locale = Locale(localeName);
          if(localeName == "en")
            Constants.CURRENT_LOCALE = "en";
          else
            Constants.CURRENT_LOCALE = "ar";
            setState(() {});
        },
        groupValue: flagAsset == currentLocale,
      ),
    );
  }


  void _changeUserProfileImage() async{

    final picker = ImagePicker();
     showBottomSheet(context: context, builder: (context) => Material(
       elevation: 5,
       color: AppColors.mainThemeColor,
       borderRadius: BorderRadiusDirectional.only(
         topStart: Radius.circular(16),
         topEnd: Radius.circular(16),
       ),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.camera_alt),
            color: AppColors.white,
            onPressed: ()async{
              final pickedFile = await picker.getImage(source: ImageSource.camera , imageQuality: 70);
              if(pickedFile != null) {
                TabsHolderScreen.profileImage =  File(pickedFile.path);
                setState(() {});
              }
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            icon: Icon(Icons.filter),
            color: AppColors.white,
            onPressed: ()async{
              final pickedFile = await picker.getImage(source: ImageSource.gallery  , imageQuality: 70 );
              if(pickedFile != null) {
                TabsHolderScreen.profileImage =  File(pickedFile.path);
                setState(() {});
              }
              Navigator.of(context).pop();
            },
          ),
        ],
    ),
     ) , elevation: 2 , backgroundColor: AppColors.mainThemeColor);
  }

  void _changeUserProfileCoverImage() async{

    final picker = ImagePicker();
    showBottomSheet(context: context, builder: (context) => Material(
      elevation: 5,
      color: AppColors.mainThemeColor,
      borderRadius: BorderRadiusDirectional.only(
        topStart: Radius.circular(16),
        topEnd: Radius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.camera_alt),
            color: AppColors.white,
            onPressed: ()async{
              final pickedFile = await picker.getImage(source: ImageSource.camera , imageQuality: 70);
              if(pickedFile != null) {
                TabsHolderScreen.coverImage =  File(pickedFile.path);
                setState(() {});
              }
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            icon: Icon(Icons.filter),
            color: AppColors.white,
            onPressed: ()async{
              final pickedFile = await picker.getImage(source: ImageSource.gallery  , imageQuality: 70 );
              if(pickedFile != null) {
                TabsHolderScreen.coverImage =  File(pickedFile.path);
                setState(() {});
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    ) , elevation: 2 , backgroundColor: AppColors.mainThemeColor);
  }


  @override
  void deactivate() {
    print("Deactivate Called");
    super.deactivate();
  }

  @override
  void didUpdateWidget(ProfileScreen oldWidget) {
    print("Did Update Widget");
    super.didUpdateWidget(oldWidget);
  }
}