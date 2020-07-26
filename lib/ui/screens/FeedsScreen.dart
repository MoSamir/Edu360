import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/ui/screens/CreatePostScreen.dart';
import 'package:edu360/ui/widgets/post/UserDocumentsPostCard.dart';
import 'package:edu360/ui/widgets/post/UserTextPostCard.dart';
import 'package:edu360/ui/widgets/post/UserVideoPostCard.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'CreatePostScreen.dart';
class FeedsScreen extends StatefulWidget {

  final Function moveToScreen , onPostCreated;
  FeedsScreen( this.onPostCreated , this.moveToScreen);


  @override
  _FeedsScreenState createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          addCommentWidget(),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 0 , left: 10, right: 10),
            itemBuilder: (context , index) {
              return index == 1 ? UserDocumentsPostCard(postModel: PostViewModel(),) : index == 2 ? UserVideoPostCard(postModel: PostViewModel(),) : UserTextPostCard(postModel: PostViewModel(),);
            } , itemCount: 3, shrinkWrap: true,),
        ],
      ),
    );
  }
  Widget addCommentWidget() {

    return GestureDetector(
      onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CreatePostScreen(widget.onPostCreated , widget.moveToScreen))),
      child: Container(
        margin: EdgeInsets.only(left: 16,right: 16, top: 20 , bottom: 10),
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: AppColors.white,
        ),
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: AppColors.white,
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.comment , color: AppColors.mainThemeColor, size: 25,),
                    SizedBox(width: 10,),
                    Text( LocalKeys.SHARE_YOUR_THOUGHTS , textAlign: TextAlign.start , style: Styles.baseTextStyle.copyWith(color: AppColors.mainThemeColor, fontWeight: FontWeight.bold),).tr(),
                  ],
                )),
          ),
        ),
      ),
    );

  }
}


