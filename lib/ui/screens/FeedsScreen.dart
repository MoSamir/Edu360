import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:edu360/blocs/bloc/HomePostsBloc.dart';
import 'package:edu360/blocs/events/HomePostsEvent.dart';
import 'package:edu360/blocs/states/HomePostsStates.dart';

import 'package:edu360/ui/UIHelper.dart';
import 'package:edu360/ui/screens/CreatePostScreen.dart';
import 'package:edu360/ui/screens/SinglePostScreen.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'CreatePostScreen.dart';
class FeedsScreen extends StatefulWidget {

  final Function moveToScreen , onPostCreated;
  FeedsScreen( this.onPostCreated , this.moveToScreen);


  @override
  _FeedsScreenState createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {

  HomePostsBloc homeBloc;

  @override
  Widget build(BuildContext context) {
    homeBloc = BlocProvider.of<AppDataBloc>(context).userDataBloc.homePostsBloc;
    return BlocConsumer(
      builder: (context,state){
        return ModalProgressHUD(
          inAsyncCall: state is HomePostsLoading,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 40,),
                addCommentWidget(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(top: 0 , left: 10, right: 10),
                  itemBuilder: (context , index) {
                    return UIHelper.getPostView(homeBloc.homePosts[index], context , elevation: 5 , postAction: (){
                      setState(() {});
                    } , onPostClick: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SinglePostScreen((){
                      BlocProvider.of<AppDataBloc>(context).userDataBloc.homePostsBloc.add(LoadHomeUserPosts());
                    },post: homeBloc.homePosts[index],))));
                  } , itemCount: homeBloc.homePosts.length, shrinkWrap: true,),
              ],
            ),
          ),
        );
      },
      listener: (context, state){},
      bloc: homeBloc,
    );
  }
  Widget addCommentWidget() {
    return GestureDetector(
      onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CreatePostScreen(widget.onPostCreated , widget.moveToScreen))),
      child: Container(
        margin: EdgeInsets.only(left: 16,right: 16, top: 20 , bottom: 10),
        padding: EdgeInsets.only(right: 10,left: 10),
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: AppColors.white,
        ),
        child: Row(
          children: <Widget>[
//            Image(image: AssetImage(Resources.COMPONENT_IMAGE)),
            SizedBox(width: 10,),
            Text( LocalKeys.SHARE_YOUR_THOUGHTS , textAlign: TextAlign.start , style: Styles.baseTextStyle.copyWith(color: AppColors.mainThemeColor, fontSize: 20),).tr(),
          ],
        )
      ),
    );

  }
}


