import 'package:chewie/chewie.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class UserVideoPostCard extends StatefulWidget {
  @override
  _UserVideoPostCardState createState() => _UserVideoPostCardState();
}

class _UserVideoPostCardState extends State<UserVideoPostCard> {

  final videoPlayerController = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');

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
      padding: EdgeInsets.all(16),
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
                      child: Center(child:Text('S' , style: Styles.baseTextStyle,),),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      child:Text('Username' ,),
                    ),
                    SizedBox(width: 5,),
                    IconButton(icon: Icon(Icons.linear_scale , color: Colors.black,),),
                  ],
                ),
                SizedBox(height: 10,),
                Text("Post Description" , maxLines: 2, textAlign: TextAlign.start,),
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
                        IconButton(icon: Icon(Icons.comment ,color: Colors.blue), onPressed: (){},),
                        IconButton(icon: Icon(Icons.comment ,color: Colors.red), onPressed: (){},),
                        IconButton(icon: Icon(Icons.thumb_up ,color: Colors.blue), onPressed: (){},),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.share,),
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
