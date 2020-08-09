import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:edu360/blocs/bloc/SingleCourseBloc.dart';
import 'package:edu360/blocs/events/CoursesEvents.dart';
import 'package:edu360/blocs/events/SingleCourseEvents.dart';
import 'package:edu360/blocs/states/SingleCourseStates.dart';
import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/data/models/LessonViewModel.dart';
import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:edu360/ui/widgets/PlaceHolderWidget.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'ViewLesson.dart';

class CourseLessonsScreen extends StatefulWidget {

  final CourseViewModel course;
  CourseLessonsScreen({this.course});

  @override
  _CourseLessonsScreenState createState() => _CourseLessonsScreenState();
}

class _CourseLessonsScreenState extends State<CourseLessonsScreen> {


  SingleCourseBloc courseBloc ;
  CourseViewModel course ;

  @override
  void initState() {

    courseBloc = BlocProvider.of<SingleCourseBloc>(context);
    course = widget.course;
    if(course.courseLessons == null || course.courseLessons.length == 0){
      courseBloc.add(FetchCourseInformation(course: course));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar:  EduAppBar(
        logoWidth: MediaQuery.of(context).size.width / 3,
        logoHeight: 20,
        autoImplyLeading: true,
        backgroundColor: AppColors.mainThemeColor,
        //icon: SvgPicture.asset( Resources.LOGO_IMAGE_SVG, width: 25, height: 25,),
        actions: <Widget>[
          Image(
            image: AssetImage(Resources.APPBAR_MESSAGE_IMAGE),
            color: Colors.white,
          ),
        ],
      ),
      body: BlocConsumer(

        builder: (context , state){

          if(state is LoadingCourseFailed){
            return PlaceHolderWidget(
              placeHolderIcon: IconButton(icon: Icon(Icons.refresh), onPressed: (){
                courseBloc.add(FetchCourseInformation(
                  course: course,
                ));
              },),
              placeHolder: Text('Unable to load course lessons please try again in while'),
            );
          } else if(state is CourseLoadingStates){
            return Center(child: SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator()));
          }
          else
          return  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(course.courseTitle,
                          style: TextStyle(
                            color: AppColors.mainThemeColor,
                            fontSize: 20,
                          )),
                    ),
                    Image(
                      image: AssetImage(Resources.SETTINGS_IMAGE),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                course.courseStartTime.isAfter(DateTime.now()) ?  Expanded(child: Center(child: PlaceHolderWidget(placeHolder: Text(LocalKeys.COURSE_NOT_STARTED_YET).tr(),))) :course.courseLessons.length > 0 ?
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: course.courseLessons.length,
                    itemBuilder: (context, index) {
                      return singleLessonView(course.courseLessons[index]);
                    }) : Expanded(child: Center(child: PlaceHolderWidget(placeHolder: Text(LocalKeys.COURSE_HAS_NO_LESSONS).tr(),))),
              ],
            ),
          );
        },
        bloc: courseBloc,
        listener: (context,  state){
          if(state is CourseInformationLoaded){
            course = courseBloc.courseViewModel;
          }
        },
      ),
    );
  }

  Widget singleLessonView(LessonViewModel lesson) {
    return InkWell(
      onTap: ()async{
        await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> BlocProvider.value(
            value: courseBloc,
            child: ViewLesson(lesson: lesson , onDonePressed: onLessonDone))));
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.white, borderRadius: BorderRadius.circular(15)),
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                lesson.lessonNameEn ,
                style: TextStyle(
                    color: AppColors.mainThemeColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "video : ${lesson.isCompleted  ? 'done' : 'not done'}",
                style: TextStyle(
                    color: AppColors.mainThemeColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "quiz : ${lesson.quizMark}" ,
                style: TextStyle(color: AppColors.mainThemeColor, fontSize: 14),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "cards : ${lesson.flashCards}" ,
                    style: TextStyle(color: AppColors.mainThemeColor, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "View",
                    style: TextStyle(
                        color: AppColors.mainThemeColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  onLessonDone() {

    courseBloc.add(FetchCourseInformation(course: widget.course ?? courseBloc.courseViewModel));
    BlocProvider.of<AppDataBloc>(context).userDataBloc.coursesBloc.add(LoadUserCourses());
  }
}
