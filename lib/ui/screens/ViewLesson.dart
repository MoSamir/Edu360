import 'package:chewie/chewie.dart';
import 'package:edu360/blocs/bloc/SingleCourseBloc.dart';
import 'package:edu360/blocs/events/SingleCourseEvents.dart';
import 'package:edu360/blocs/states/SingleCourseStates.dart';
import 'package:edu360/data/models/LessonViewModel.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/ui/widgets/EduButton.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';

import 'CoursePayNow.dart';

class ViewLesson extends StatefulWidget {
  final LessonViewModel lesson ;
  final Function onDonePressed ;
  ViewLesson({this.lesson, this.onDonePressed});
  @override
  _ViewLessonState createState() => _ViewLessonState();
}

class _ViewLessonState extends State<ViewLesson> {
  bool showComment1 = false;
  bool showComment2 = false;
  bool flashCardEnabled = false;

  final videoPlayerController = VideoPlayerController.network('http://ref360.net/assets/video/ref360_video_intro.mp4');

  ChewieController chewieController;
  @override
  void initState() {
    super.initState();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3/4,
      autoPlay: false,
      autoInitialize: true,
      placeholder: Container(),
      looping: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: BlocConsumer(
        bloc: BlocProvider.of<SingleCourseBloc>(context),
        listener: (context, state){
          if(state is LessonCompleted){
            widget.onDonePressed();
            Navigator.of(context).pop();
          }
        },
        builder: (context , state){
          return Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                      child: ListView(
                        children: <Widget>[
                          SizedBox(height: 65,),
                          Container(
                            height: 180,
                            color: AppColors.white,
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 25),
                                  child: Container(
                                    height: 120,
                                    child: Chewie(
                                      controller: chewieController,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  color: Colors.black12,
                                  width: MediaQuery.of(context).size.width,
                                  height: .25,
                                ),
                                commentCont(),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                text(),
                                SizedBox(height: 10,),
                                flashCards(),
                                SizedBox(height: 10,),
                                quiz(),
                              ],
                            ),
                          ),
                        ],
                      )),
                  EduButton( title: LocalKeys.MarkDone , onPressed: _completeLesson,bgColor: AppColors.mainThemeColor,style: Styles.studyTextStyle,cornerRadius: 0,),
                ],
              ),
              EduAppBar(
                backgroundColor: AppColors.mainThemeColor,
                logoWidth: MediaQuery.of(context).size.width / 3,
                logoHeight: 20,
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  Widget commentCont() {
    return Align(
      alignment: Alignment(-1, -1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment:CrossAxisAlignment.center,
                        children: <Widget>[
                          InkWell(child:              SvgPicture.asset(Resources.COMMENT_SVG_IMAGE , width: 25, height: 25,), onTap: () {
                          setState(() {
                            showComment2 = !showComment2;
                          });
                    },),
                        ],
                      ),),
                  ],
                ),

                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    child:  showComment2  == true?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:  Container(
                          height: 30,
                          decoration: BoxDecoration(
                              color: AppColors.mainThemeColor,
                              borderRadius:
                              BorderRadius.all(Radius.circular(100))),
//                     width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            decoration: InputDecoration(
                                contentPadding:
                                EdgeInsets.only(left: 10, bottom: 16),
                                hintText: "Type your comment here..",
                                hintStyle: TextStyle(color: Colors.white,fontSize: 14),
                                border: InputBorder.none),
                          )),
                    ): Container(),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment:CrossAxisAlignment.center,
                        children: <Widget>[
                          InkWell(child: SvgPicture.asset(Resources.COMMENT_SVG_IMAGE , width: 25, height: 25,), onTap: () {
                            setState(() {
                              showComment1 = !showComment1;
                            });
                          },),
                        ],
                      ),),
                  ],
                ),

                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    child:  showComment1  == true?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:  Container(
                          height: 30,
                          decoration: BoxDecoration(
                              color: AppColors.redBackgroundColor,
                              borderRadius:
                              BorderRadius.all(Radius.circular(100))),
//                     width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            decoration: InputDecoration(
                                contentPadding:
                                EdgeInsets.only(left: 10, bottom: 16),
                                hintText: "Type your objection  here..",
                                hintStyle: TextStyle(color: Colors.white,fontSize: 14),
                                border: InputBorder.none),
                          )),
                    ): Container(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget text(){

    return Container(
      padding: EdgeInsets.only(left: 15,right: 15),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Text',style: TextStyle(color: AppColors.mainThemeColor,fontSize: 20),),

        ],
      ),
    );
  }

  Widget flashCards(){

    return Container(
      padding: EdgeInsets.only(left: 15,right: 15),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Flashcards',style: TextStyle(color: AppColors.mainThemeColor,fontSize: 20),),
        InkWell(
            onTap: (){
              setState(() {
                flashCardEnabled =! flashCardEnabled;
              });
            },
            child: Icon(flashCardEnabled ?Icons.check_circle: Icons.check_circle_outline,color: AppColors.mainThemeColor,))
        ],
      ),
    );
  }

  Widget quiz(){

    return Container(
      padding: EdgeInsets.only(left: 15,right: 15),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Quiz',style: TextStyle(color: AppColors.mainThemeColor,fontSize: 20),),
          Text('Score%',style: TextStyle(color: AppColors.mainThemeColor,fontSize: 20),),
        ],
      ),
    );
  }
  void _completeLesson() {
    BlocProvider.of<SingleCourseBloc>(context).add(CompleteLesson(lesson: widget.lesson , flashCard: flashCardEnabled , quizGrade : 100));
  }

}


