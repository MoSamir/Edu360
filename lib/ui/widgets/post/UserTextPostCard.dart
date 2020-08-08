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
  final onLike, onShare, onComment, onObjection , onPostClick;
  UserTextPostCard(
      {this.postModel,
      this.elevation,
      this.onPostClick,
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
    return GestureDetector(
      onTap: widget.onPostClick ?? (){},
      child: Padding(
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
                    child: Text(widget.postModel.postBody  ?? '' ,style: Styles.studyTextStyle.copyWith( color: AppColors.mainThemeColor),),
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
                                          SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: InkWell(
                                                  onTap: (){
                                                    if(widget.onLike != null)
                                                      widget.onLike();
                                                    return;
                                                  },
                                                  child: Icon(widget.postModel.isLiked ?? false ? Icons.favorite  : Icons.favorite_border ,color: AppColors.mainThemeColor,))),
                                        widget.postModel.numberOfLikes < 1 ? Container() : Text('${widget.postModel.numberOfLikes}',style: TextStyle(color: AppColors.mainThemeColor),),
                                        ],
                                      )
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
                                      widget.onComment("Comment");
                                      return;
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        SvgPicture.asset(Resources.COMMENT_SVG_IMAGE , width: 25, height: 25,),
                                        widget.postModel.numberOfComments < 1 ? Container() :
                                        Text('${ widget.postModel.numberOfComments}',style: TextStyle(color: AppColors.mainThemeColor),),
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
                                        SvgPicture.asset(Resources.COMMENT_ERROR_SVG_IMAGE , width: 25, height: 25,),
                                        widget.postModel.numberOfObjections < 1 ? Container() :
                                        Text('${ widget.postModel.numberOfObjections}',style: TextStyle(color: AppColors.redBackgroundColor),),
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
//                            width: 55,
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    widget.onShare("share");
                                    return;
                                  },
                                  child: Image(image: AssetImage(Resources.SHARE_IMAGE)),
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
      ),
    );
  }
}
