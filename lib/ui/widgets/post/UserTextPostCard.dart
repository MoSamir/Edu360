import 'package:edu360/blocs/bloc/PostBloc.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserTextPostCard extends StatefulWidget {
  final PostViewModel postModel;
  final double elevation;
  final onLike, onShare, onComment, onObjection;
  UserTextPostCard(
      {this.postModel,
      this.elevation,
      this.onComment,
      this.onLike,
      this.onObjection,
      this.onShare});

  @override
  _UserTextPostCardState createState() => _UserTextPostCardState();
}

class _UserTextPostCardState extends State<UserTextPostCard> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.postModel.toString());
    int likes = 0, comment = 1000 , error = 1000;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        type: MaterialType.card,
        color: Colors.white,
        elevation: widget.elevation ?? 5.0,
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
                        image: DecorationImage(
                          image: NetworkImage(
                              widget.postModel.ownerImagePath ?? ''),
                        ),
                        shape: BoxShape.circle,
                        color: AppColors.mainThemeColor,
                      ),
                      //child: Center(child:Text('S' , textScaleFactor: 1,style: Styles.baseTextStyle,),),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                        widget.postModel.ownerName ?? 'Name',
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    IconButton(icon: Icon(Icons.more_vert , color: AppColors.mainThemeColor,),),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5,left: 5,bottom: 5),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.mainThemeColor,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text('Docs Name Category',style: Styles.studyTextStyle.copyWith(fontWeight: FontWeight.bold),),
                  )
                ),
                Padding(
                    padding: const EdgeInsets.only(right: 5,left: 5,bottom: 5),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: AppColors.redBackgroundColor,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text('Docs Name Category',style: Styles.studyTextStyle.copyWith(fontWeight: FontWeight.bold),),
                    )
                ),
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
                                child: InkWell(
                                    onTap: widget.onLike ?? () {},
                                    child: Row(
                                      children: <Widget>[
                                        Image(
                                            image: AssetImage(
                                                Resources.Clap_IMAGE)),
                                       likes < 1 ? Container() :
                                        Text('$likes',style: TextStyle(color: AppColors.mainThemeColor),),
                                      ],
                                    )
                                )),
                            Visibility(
                              replacement: Container(
                                width: 0,
                                height: 0,
                              ),
                              visible: widget.postModel.numberOfLikes != null
                                  ? widget.postModel.numberOfLikes > 0
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
                                        widget.postModel.numberOfLikes.toString(),
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
                                child: InkWell(
                                  onTap: () {
                                    widget.onComment("Comment");
                                    return;
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Image(
                                          image: AssetImage(
                                              Resources.COMMENT_CON_IMAGE)),
                                      comment < 1 ? Container() :
                                      Text('$comment',style: TextStyle(color: AppColors.mainThemeColor),),
                                    ],
                                  )??
                                      () {},
                                )),
                          ],
                        ),
                        SizedBox(width: 6,),
                        Column(
                          children: <Widget>[
                            SizedBox(
                                height: 25,
                                child: InkWell(
                                  onTap: () {
                                    widget.onObjection("objection");
                                    return;
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Image(
                                          image: AssetImage(
                                              Resources.COMMENT_ERROR_IMAGE)),
                                      error < 1 ? Container() :
                                      Text('$error',style: TextStyle(color: AppColors.redBackgroundColor),),
                                    ],
                                  ) ??
                                      () {},
                                )),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  widget.onShare("share");
                                  return;
                                },
                                child: Image(
                                    image: AssetImage(
                                        Resources.SHARE_IMAGE)) ??
                                        () {},
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          replacement: Container(
                            width: 0,
                            height: 0,
                          ),
                          visible: widget.postModel.numberOfShares != null
                              ? widget.postModel.numberOfShares > 0
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
                                widget.postModel.numberOfShares.toString(),
                                style: Styles.baseTextStyle,
                              ))),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
