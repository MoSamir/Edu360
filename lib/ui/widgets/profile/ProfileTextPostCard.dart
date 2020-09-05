import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
class ProfileTextPostCard extends StatelessWidget {
  final PostViewModel postModel ;
  final double elevation ;
  final onLike , onShare , onComment , onObjection , onPostClick , onDelete;

  ProfileTextPostCard({this.postModel, this.elevation , this.onComment, this.onDelete , this.onPostClick , this.onLike , this.onObjection , this.onShare});
  final GlobalKey _cardKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      key: _cardKey,
      onTap: onPostClick ?? (){},
      onLongPress: (){
        RenderBox box = _cardKey.currentContext.findRenderObject();
        Offset position = box.localToGlobal(Offset.zero);
        showMenu(context: context, position: RelativeRect.fromLTRB(position.dx , position.dy , position.dx + 40 , position.dy + 60),
            items: List.generate(1, (index) => PopupMenuItem<int>(
              child:  GestureDetector(
                child: Text((LocalKeys.DELETE_LABEL).tr()),
                onTap: (){
                  onDelete();
                  Navigator.of(context).pop();
                  return;
                },
              ),
              value: 0,

            )));
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20)
        ),
        child:  Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Material(
                  type: MaterialType.card,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.mainThemeColor,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: FadeInImage.assetNetwork(placeholder: Resources.USER_PLACEHOLDER_IMAGE, image: postModel.ownerImagePath, fit: BoxFit.cover,),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Text(
                                  postModel.ownerName ?? '',
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5,left: 5),
                            child: SizedBox(
                              child: Text(
                                postModel.postBody ?? '',
                                textAlign: TextAlign.start,
                                textScaleFactor: 1,
                                maxLines: 10,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: AppColors.mainThemeColor
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.black12,
                  width: MediaQuery.of(context).size.width,
                  height: .65,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                                height: 25,
                                width: 25,
                                child: InkWell(
                                    onTap: (){
                                      if(onLike != null)
                                        onLike();
                                      return;
                                    },
                                    child: Icon(postModel.isLiked ?? false ? Icons.favorite  : Icons.favorite_border ,color: AppColors.mainThemeColor,))),
                            Visibility(
                              replacement: Container(
                                width: 0,
                                height: 0,
                              ),
                              visible: postModel.numberOfLikes != null
                                  ? postModel.numberOfLikes > 0
                                  : false,
                              child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainThemeColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                      child: Text(
                                        postModel.numberOfLikes.toString(),
                                        style: Styles.baseTextStyle,
                                      ))),
                            ),
                          ],
                        ),
                        SizedBox(width: 6,),
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 25,
                              width: 25,
                              child: InkWell(
                                  onTap: () {
                                    onComment("Comment");
                                    return;
                                  },
                                  child: Image.asset(Resources.COMMENT_IMAGE , width: 25, height: 25,)) ?? () {},
                            ),
                            Visibility(
                              replacement: Container(
                                width: 0,
                                height: 0,
                              ),
                              visible: postModel.numberOfComments != null
                                  ? postModel.numberOfComments > 0
                                  : false,
                              child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainThemeColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                      child: Text(
                                        postModel.numberOfComments.toString(),
                                        style: Styles.baseTextStyle,
                                      ))),
                            ),
                          ],
                        ),
                        SizedBox(width: 6,),
                        Column(
                          children: <Widget>[
                            SizedBox(
                                width: 25,
                                height: 25,
                                child: InkWell(
                                  onTap: () {
                                    onObjection("Objection");
                                    return;
                                  },
                                  child: Image(
                                      image: AssetImage(
                                          Resources.OBJECTION_IMAGE)) ??
                                          () {},
                                ),),
                            Visibility(
                              replacement: Container(
                                width: 0,
                                height: 0,
                              ),
                              visible: postModel.numberOfObjections != null
                                  ? postModel.numberOfObjections > 0
                                  : false,
                              child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: AppColors.redBackgroundColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                      child: Text(
                                        postModel.numberOfObjections.toString(),
                                        style: Styles.baseTextStyle,
                                      ))),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 10,),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: InkWell(
                            onTap: (){
                              if(onShare != null)
                                onShare("Share");
                              return;
                            },
                            child: Image(
                                image: AssetImage(
                                    Resources.SHARE_IMAGE)) ,
                          ),
                        ),
                        Visibility(
                          replacement: Container(
                            width: 0,
                            height: 0,
                          ),
                          visible: postModel.numberOfShares != null
                              ? postModel.numberOfShares > 0
                              : false,
                          child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: AppColors.mainThemeColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                  child: Text(
                                    postModel.numberOfShares.toString(),
                                    style: Styles.baseTextStyle,
                                  ))),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }





}
