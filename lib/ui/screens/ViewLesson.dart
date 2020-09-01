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
import 'package:edu360/utilities/ParserHelpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';
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
  bool flashCardEnabled = false;

  VideoPlayerController videoPlayerController ;


  ChewieController chewieController;
  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network('https://ref360.net/assets/video/ref360_video_intro.mp4');
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 4/3,
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
              aspectRatio: 21/9,
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
            if (state.error.errorCode == HttpStatus.requestTimeout|| state.error.errorCode == HttpStatus.badGateway) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return NetworkErrorView();
                  });

              Future.delayed(Duration(seconds: 2), () {
                Navigator.pop(context);
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
            child: Scaffold(
              appBar: EduAppBar(
                backgroundColor: AppColors.mainThemeColor,
                logoWidth: MediaQuery.of(context).size.width / 3,
                logoHeight: 20,
                autoImplyLeading: true,
              ),
              body: Column(
                children: <Widget>[
                  Expanded(
                      child: ListView(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 8 , right: 8 , left: 8),
                            child: Text(currentLesson.getLessonName(context),style: TextStyle(color: AppColors.mainThemeColor,fontSize: 20),),
                          ),
                          SizedBox(height: 5,),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width,
                            color: AppColors.redBackgroundColor,
                            child: Container(
                              height: 180,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Chewie(
                                  controller: chewieController ?? VideoPlayerController.network('https://ref360.net/assets/video/ref360_video_intro.mp4'),
                                ),
                              ),
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
                  EduButton( title: (LocalKeys.MARK_DONE).tr() , onPressed: _completeLesson,bgColor: currentLesson.isCompleted ? Colors.grey : AppColors.mainThemeColor,style: Styles.studyTextStyle,cornerRadius: 0,),
                ],
              ),
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

//  Widget commentCont() {
//    return Align(
//      alignment: Alignment(-1, -1),
//      child: Column(
//        mainAxisAlignment: MainAxisAlignment.end,
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//
//          Padding(
//            padding: const EdgeInsets.symmetric(horizontal: 10),
//            child: Stack(
//              children: <Widget>[
//                Container(
//                  height: 40,
//                  width: MediaQuery.of(context).size.width,
//                ),
//                Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Container(
//                      height: 40,
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        crossAxisAlignment:CrossAxisAlignment.center,
//                        children: <Widget>[
//                          InkWell(child:              SvgPicture.asset(Resources.COMMENT_SVG_IMAGE , width: 25, height: 25,), onTap: () {
//                          setState(() {
//                            showComment2 = !showComment2;
//                          });
//                    },),
//                        ],
//                      ),),
//                  ],
//                ),
//
//                Positioned(
//                  top: 0,
//                  right: 0,
//                  left: 0,
//                  child: Container(
//                    margin: EdgeInsets.symmetric(horizontal: 25),
//                    child:  showComment2  == true?
//                    Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child:  Container(
//                          height: 30,
//                          decoration: BoxDecoration(
//                              color: AppColors.mainThemeColor,
//                              borderRadius:
//                              BorderRadius.all(Radius.circular(100))),
////                     width: MediaQuery.of(context).size.width,
//                          child: TextFormField(
//                            decoration: InputDecoration(
//                                contentPadding:
//                                EdgeInsets.only(left: 10, bottom: 16),
//                                hintText: "Type your comment here..",
//                                hintStyle: TextStyle(color: Colors.white,fontSize: 14),
//                                border: InputBorder.none),
//                          )),
//                    ): Container(),
//                  ),
//                ),
//              ],
//            ),
//          ),
//
//          Padding(
//            padding: const EdgeInsets.symmetric(horizontal: 10),
//            child: Stack(
//              children: <Widget>[
//                Container(
//                  height: 40,
//                  width: MediaQuery.of(context).size.width,
//                ),
//                Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Container(
//                      height: 40,
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        crossAxisAlignment:CrossAxisAlignment.center,
//                        children: <Widget>[
//                          InkWell(child: SvgPicture.asset(Resources.COMMENT_SVG_IMAGE , width: 25, height: 25,), onTap: () {
//                            setState(() {
//                              showComment1 = !showComment1;
//                            });
//                          },),
//                        ],
//                      ),),
//                  ],
//                ),
//
//                Positioned(
//                  top: 0,
//                  right: 0,
//                  left: 0,
//                  child: Container(
//                    margin: EdgeInsets.symmetric(horizontal: 25),
//                    child:  showComment1  == true?
//                    Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child:  Container(
//                          height: 30,
//                          decoration: BoxDecoration(
//                              color: AppColors.redBackgroundColor,
//                              borderRadius:
//                              BorderRadius.all(Radius.circular(100))),
////                     width: MediaQuery.of(context).size.width,
//                          child: TextFormField(
//                            decoration: InputDecoration(
//                                contentPadding:
//                                EdgeInsets.only(left: 10, bottom: 16),
//                                hintText: "Type your objection  here..",
//                                hintStyle: TextStyle(color: Colors.white,fontSize: 14),
//                                border: InputBorder.none),
//                          )),
//                    ): Container(),
//                  ),
//                ),
//              ],
//            ),
//          ),
//        ],
//      ),
//    );
//  }

  Widget lessonTextWidget(){
    return Container(
      width: MediaQuery.of(context).size.width,
      // padding: EdgeInsets.only(left: 15,right: 15),
      //height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: getLessonFile(),
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
              Text((LocalKeys.CARDS).tr(),style: TextStyle(color: AppColors.mainThemeColor,fontSize: 20),),
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
      onTap: ()async{
        if(currentLesson.isCompleted == false && currentLesson.quizQuestions.length > 0)
          currentLesson.quizMark = await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LessonQuizScreen(questions: currentLesson.quizQuestions))) ?? 0.0;
        setState(() {});
      } ,
      child: Container(
        padding: EdgeInsets.only(left: 15,right: 15),
        height: 60,
        decoration: BoxDecoration(
          color: currentLesson.isCompleted ?  Colors.grey : Colors.white,
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
    if(currentLesson.isCompleted == false)
      BlocProvider.of<SingleCourseBloc>(context).add(CompleteLesson(lesson: widget.lesson , flashCard: flashCardEnabled , quizGrade : 100));
  }


  getLessonFile() {
    String document = ParserHelper.parseURL(currentLesson.documentURL);
    return GestureDetector(
      onTap: (){
        PdftronFlutter.openDocument(document);
      },
      child: Container(
        // height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: document.endsWith(".pdf") ? AppColors.redBackgroundColor : AppColors.wordBackgroundColor,
        ),
        padding : EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            document.split("/")[document.split("/").length -1],
            softWrap: true,
            textAlign: TextAlign.start,
            maxLines: 2,
            textScaleFactor: 1,
            style: TextStyle(
                color: AppColors.white
            ),
          ),
        ),
      ),
    );
  }


}


