import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:chewie/chewie.dart';
import 'package:edu360/blocs/bloc/SingleCourseBloc.dart';
import 'package:edu360/blocs/events/SingleCourseEvents.dart';
import 'package:edu360/blocs/states/SingleCourseStates.dart';
import 'package:edu360/data/models/LessonViewModel.dart';
import 'package:edu360/ui/screens/LessonQuizScreen.dart';
import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/ui/widgets/EduButton.dart';
import 'package:edu360/ui/widgets/NetworkErrorView.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:video_player/video_player.dart';

class ViewLesson extends StatefulWidget {
  final LessonViewModel lesson ;
  final Function onDonePressed ;
  ViewLesson({this.lesson, this.onDonePressed});
  @override
  _ViewLessonState createState() => _ViewLessonState();
}

class _ViewLessonState extends State<ViewLesson> {
  LessonViewModel currentLesson ;
  bool showComment1 = false;
  bool showComment2 = false;
  bool flashCardEnabled = false;

  VideoPlayerController videoPlayerController ;


  ChewieController chewieController;
  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network('http://ref360.net/assets/video/ref360_video_intro.mp4');
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3/4,
      autoPlay: false,
      autoInitialize: true,
      placeholder: Container(),
      looping: false,
    );
    if(widget.lesson !=null)
      currentLesson = widget.lesson;
    BlocProvider.of<SingleCourseBloc>(context).add(FetchLessonInformation(lessonId: widget.lesson.lessonId));
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
          if(state is LessonInformationLoaded){
            currentLesson = state.lesson;
            videoPlayerController = VideoPlayerController.network(state.lesson.videoURL);
            chewieController = ChewieController(
              videoPlayerController: videoPlayerController,
              aspectRatio: 3/4,
              autoPlay: false,
              autoInitialize: true,
              placeholder: Container(),
              looping: false,
            );
            setState(() {});
          }
          else if (state is LessonInformationLoadingFailed ||
                   state is LoadingCourseFailed ||
                   state is LessonCompletionFailed) {
            if (state.error.errorCode == HttpStatus.requestTimeout) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return NetworkErrorView();
                  });
            }
            else if(state.error.errorCode == HttpStatus.serviceUnavailable){
              Fluttertoast.showToast(
                  msg: (LocalKeys.SERVER_UNREACHABLE).tr(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
            else {
              Fluttertoast.showToast(
                  msg: state.error.errorMessage ?? '',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
          }
        },
        builder: (context , state){
          return ModalProgressHUD(
            inAsyncCall: state is LessonLoadingState,
            child: Stack(
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
                                        controller: chewieController ?? VideoPlayerController.network('http://ref360.net/assets/video/ref360_video_intro.mp4'),
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
                                  lessonTextWidget(),
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
            ),
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

  Widget lessonTextWidget(){
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 15,right: 15),
      //height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(currentLesson.lessonNameEn,style: TextStyle(color: AppColors.mainThemeColor,fontSize: 20),),
            SizedBox(height: 5,),
            Text(currentLesson.lessonLearningEn,style: TextStyle(color: AppColors.mainThemeColor,fontSize: 15),),
          ],
        ),
      ),
    );
  }

  Widget flashCards(){
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 15,right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Flashcards',style: TextStyle(color: AppColors.mainThemeColor,fontSize: 20),),
              ...currentLesson.lessonFlashCards.map((e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(e , style: TextStyle(color: AppColors.mainThemeColor,fontSize: 15),),
              )).toList()
            ],
          )),
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
    return GestureDetector(
      onTap: (){
        if(currentLesson.isCompleted == false)
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LessonQuizScreen()));
      } ,
      child: Container(
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
            Text('Score ${currentLesson.quizMark} %',style: TextStyle(color: AppColors.mainThemeColor,fontSize: 20),),
          ],
        ),
      ),
    );
  }
  void _completeLesson() {
    BlocProvider.of<SingleCourseBloc>(context).add(CompleteLesson(lesson: widget.lesson , flashCard: flashCardEnabled , quizGrade : 100));
  }

}


