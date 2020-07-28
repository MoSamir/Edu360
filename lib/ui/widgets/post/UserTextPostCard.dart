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

    return Padding(
      padding: const EdgeInsets.only(top: 4 , right: 0 , left: 4 , bottom: 4),
      child: Material(
        type: MaterialType.card,
        color: Colors.white,
        elevation: widget.elevation ?? 5.0,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomRight: Radius.circular(25) , bottomLeft: Radius.circular(8) , topRight: Radius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.only(top: 4 , right: 0 , left: 4 , bottom: 0),
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
                  padding: const EdgeInsets.only(right: 5,left: 5),
                  child: Text(
                    widget.postModel.postBody ?? 'Post descripton Post descripton Post descripton Post descripton Post descripton Post descripton Post descripton Post descripton Post descripton Post descripton Post descripton Post descripton Post descripton Post descripton Post descripton Post descripton Post descripton Post descripton Post descripton Post descripton ',
                    textAlign: TextAlign.start,
                    textScaleFactor: 1,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.mainThemeColor
                    ),
                  ),
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
                                width: 25,
                                child: InkWell(
                                    onTap: widget.onLike ?? () {},
                                    child: SvgPicture.asset(

                                        Resources.CLAP_IMAGE))),
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
                                width: 25,
                                child: InkWell(
                                  onTap: () {
                                    widget.onComment("Comment");
                                    return;
                                  },
                                  child: SvgPicture.asset(
                                      Resources.COMMENT_IMAGE) ,
                                )),
                            Visibility(
                              replacement: Container(
                                width: 0,
                                height: 0,
                              ),
                              visible: widget.postModel.numberOfComments != null
                                  ? widget.postModel.numberOfComments > 0
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
                                    widget.postModel.numberOfComments
                                        .toString(),
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
                                    widget.onObjection("objection");
                                    return;
                                  },
                                  child: SvgPicture.asset(
                                      Resources.COMMENT_ERROR_IMAGE),
                                )),
                            Visibility(
                              replacement: Container(
                                width: 0,
                                height: 0,
                              ),
                              visible:
                                  widget.postModel.numberOfObjections != null
                                      ? widget.postModel.numberOfObjections > 0
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
                                    widget.postModel.numberOfObjections
                                        .toString(),
                                    style: Styles.baseTextStyle,
                                  ))),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: InkWell(
                            onTap: () {},
                            child: SvgPicture.asset(
                                Resources.SHARE_IMAGE) ,
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
