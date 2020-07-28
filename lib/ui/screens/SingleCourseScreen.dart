import 'package:edu360/blocs/bloc/SingleCourseBloc.dart';
import 'package:edu360/blocs/events/SingleCourseEvents.dart';
import 'package:edu360/blocs/states/SingleCourseStates.dart';
import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/ui/screens/DetilesCourseName.dart';
import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/ui/widgets/EduButton.dart';
import 'package:edu360/ui/widgets/EduIconImage.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SingleCourseScreen extends StatefulWidget {

  final CourseViewModel courseModel;
  SingleCourseScreen({this.courseModel});

  @override
  _SingleCourseScreenState createState() => _SingleCourseScreenState();
}

class _SingleCourseScreenState extends State<SingleCourseScreen> {


  SingleCourseBloc _singleCourseBloc ;

  @override
  void initState() {
    super.initState();
    _singleCourseBloc = SingleCourseBloc();
    _singleCourseBloc.add(FetchCourseInformation(course: widget.courseModel));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocConsumer(
        listener: (context, state){},
        builder: (context , state){
          return ModalProgressHUD(
            inAsyncCall: state is CourseLoadingStates,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: Container(
                                  height: MediaQuery.of(context).size.height * .3,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainThemeColor.withOpacity(.8),
                                    image: DecorationImage(
                                      image: AssetImage(Resources.USER_PROFILE_IMAGE),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: Container(
                                  height: MediaQuery.of(context).size.height * .3,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainThemeColor.withOpacity(.4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            color: AppColors.mainThemeColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.courseModel.courseTitle,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                    widget.courseModel.courseField.studyFieldNameEn,
                                    style: Styles.studyTextStyle,
                                    ),
                                    Text(
                                      '${widget.courseModel.feesPerMonth} ${(LocalKeys.EGP_PER_MONTH).tr()}',
                                      style: Styles.studyTextStyle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 50,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: widget.courseModel.targetClasses.length,
                                itemBuilder: (context, index) {
                                  return schoolStage(widget.courseModel.targetClasses[index], index);
                                }),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 7,top: 10,bottom: 10),
                                  child: Text(LocalKeys.COURSE_LEARNING_OUTCOMES,
                                      style: TextStyle(color: AppColors.mainThemeColor,fontWeight: FontWeight.bold)),
                                ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: _singleCourseBloc.courseViewModel != null && _singleCourseBloc.courseViewModel.courseOutcomes != null ? _singleCourseBloc.courseViewModel.courseOutcomes.length ?? 0 : 0,
                                    itemBuilder: (context, index) {
                                      return learningOutcomes(_singleCourseBloc.courseViewModel.courseOutcomes[index]);
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    EduButton( title: LocalKeys.Subscribe , onPressed: _navigateToDetailsCourseName,bgColor: AppColors.mainThemeColor,style: Styles.studyTextStyle,cornerRadius: 0,),

                  ],
                ),

              ],
            ),
          );
        },
        bloc: _singleCourseBloc,
      ),
    );
  }

  Widget schoolStage(String name, int index) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 20),
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.mainThemeColor,
              borderRadius: BorderRadius.circular(15)),
          padding: EdgeInsets.all(5),
          child: Text(
            name,
            style: Styles.baseTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
  Widget learningOutcomes(String outcome) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.arrow_right, color: AppColors.mainThemeColor),
          Text(outcome, style: TextStyle(color: AppColors.mainThemeColor)),
        ],
      ),
    );
  }
  void _navigateToDetailsCourseName() {
   Navigator.of(context).push(MaterialPageRoute(builder: (context)=> DetailsCourseName())
   );
  }
}

