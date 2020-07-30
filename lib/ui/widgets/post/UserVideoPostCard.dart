import 'package:chewie/chewie.dart';
import 'package:edu360/data/apis/helpers/URL.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';

class UserVideoPostCard extends StatefulWidget {
  final PostViewModel postModel ;
  final double elevation ;
  final onLike , onShare , onComment , onObjection ;

  UserVideoPostCard({this.postModel, this.elevation , this.onComment , this.onLike , this.onObjection , this.onShare});

  @override
  _UserVideoPostCardState createState() => _UserVideoPostCardState();
}

class _UserVideoPostCardState extends State<UserVideoPostCard> {

  final videoPlayerController = VideoPlayerController.network('${URL.BASE_URL}/Uploads//Edu360Files//2cae8ba8-3cef-46c1-9942-affad496772f_videoplayback.mp4');

  ChewieController chewieController ;

  @override
  void initState() {
    super.initState();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: false,
      autoInitialize: true,
      placeholder: Container(),
      looping: false,
    );

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4 , right: 0 , left: 4 , bottom: 4),

      child: Material(
        type: MaterialType.card,
        color: Colors.white,
        elevation: widget.elevation ?? 5.0,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(8), bottomRight: Radius.circular(25) , bottomLeft: Radius.circular(8) , topRight: Radius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.only(top: 4 , right: 0 , left: 4 , bottom: 4),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 5,),
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
                    SizedBox(width: 5,),
                    IconButton(icon: Icon(Icons.more_vert , color: AppColors.mainThemeColor,),),
                  ],
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 5,right: 5),
                  child: Text( widget.postModel.postBody ?? "Post Description" , style: TextStyle(
                      color: AppColors.mainThemeColor
                  ), textScaleFactor: 1,maxLines: 2, textAlign: TextAlign.start,),
                ),  SizedBox(height: 5,),
                Container(height: 120, child: Chewie(
                  controller: chewieController,
                ),),
                SizedBox(height: 10,),
                Container( color: Colors.black12,width: MediaQuery.of(context).size.width, height: .25,),
                SizedBox(height: 10,),
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

                                        Resources.Clap_SVG_IMAGE , width: 25, height: 25,))),
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
                                          Resources.COMMENT_SVG_IMAGE , width: 25, height: 25,) ,
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
                                          Resources.COMMENT_ERROR_SVG_IMAGE , width: 25, height: 25,),
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
                            onTap: widget.onShare ?? () {},
                            child: SvgPicture.asset(
                                Resources.SHARE_SVG_IMAGE, width: 30, height: 30,) ,
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





  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

}
