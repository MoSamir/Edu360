import 'package:chewie/chewie.dart';
import 'package:edu360/data/apis/helpers/URL.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class UserVideoPostCard extends StatefulWidget {
  final PostViewModel postModel ;
  UserVideoPostCard({this.postModel});

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
      padding: const EdgeInsets.all(4.0),
      child: Material(
        type: MaterialType.card,
        color: Colors.white,
        elevation: 5,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
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
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: Center(child:Text('S' , textScaleFactor: 1,style: Styles.baseTextStyle,),),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      child:Text(widget.postModel.ownerName ?? 'Username' ,textScaleFactor: 1,),
                    ),
                    SizedBox(width: 5,),
                    IconButton(icon: Icon(Icons.linear_scale , color: Colors.black,),),
                  ],
                ),
                SizedBox(height: 10,),
                Text(widget.postModel.postBody ?? "Post Description" , textScaleFactor: 1,maxLines: 2, textAlign: TextAlign.start,),
                SizedBox(height: 5,),
                Container(height: 120, child: Chewie(
                  controller: chewieController,
                ),),
                SizedBox(height: 10,),
                Container( color: Colors.black12,width: MediaQuery.of(context).size.width, height: .25,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.comment ,color: Colors.blue), padding: EdgeInsets.all(0), onPressed: (){},),
                        IconButton(icon: Icon(Icons.comment ,color: Colors.red), padding: EdgeInsets.all(0), onPressed: (){},),
                        IconButton(icon: Icon(Icons.thumb_up ,color: Colors.blue), padding: EdgeInsets.all(0), onPressed: (){},),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.share,), padding: EdgeInsets.all(0),
                      onPressed: (){},
                    ),
                  ],
                )
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
