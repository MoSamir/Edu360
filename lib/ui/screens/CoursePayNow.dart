import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/ui/widgets/EduButton.dart';
import 'package:edu360/ui/widgets/EduIconImage.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'CourseQuestion.dart';
class CoursePayNow extends StatefulWidget {
  @override
  _CoursePayNowState createState() => _CoursePayNowState();
}

class _CoursePayNowState extends State<CoursePayNow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: Stack(
        children: <Widget>[

          Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    SizedBox(height: 80,),
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
                            'Course Name',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Education',
                                style: Styles.studyTextStyle,
                              ),
                              Text(
                                '100 EGP/mo',
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
                    Center(
                      child: Column(
                        children: <Widget>[
                          Text('Subscribe to Course',style: TextStyle(color:  AppColors.mainThemeColor,fontSize: 20),),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.mainThemeColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text('2 lesson/week',
                                    style: Styles.studyTextStyle,)),
                              SizedBox(width: 15,),
                              Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.mainThemeColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text('8 Months left',
                                    style: Styles.studyTextStyle,)),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                               Expanded(
                                   flex: 4,
                                   child:  RichText(
                                     text: TextSpan(
                                       style: TextStyle(color: Colors.black, fontSize: 16),
                                       children: <TextSpan>[
                                         TextSpan(text: 'Oops, you have missed '),
                                         TextSpan(text: ' 5 ',style: TextStyle(color: Colors.red)),
                                         TextSpan(text: 'months, you can access the full course by paying for missed months.')
                                       ],
                                     ),
                                   )),
                               Expanded(
                                   flex: 2,
                                   child: Column(
                                     children: <Widget>[
                                       Text('+500 EGP',style: TextStyle(color:  AppColors.mainThemeColor,fontSize: 20,fontWeight: FontWeight.bold)),
                                     SizedBox(height: 7,),
                                       Container(
                                           padding: EdgeInsets.all(10),
                                           decoration: BoxDecoration(
                                             color: AppColors.mainThemeColor,
                                             borderRadius: BorderRadius.circular(20),
                                           ),
                                           child: FittedBox(
                                             child: Text('Include full course',
                                               style: Styles.baseTextStyle,),
                                           )),
                                     ],
                                   )
                               
                               ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Total',style: TextStyle(color:  AppColors.mainThemeColor,fontSize: 20),),
                        Text('100 EGP/mo',style: TextStyle(color:  AppColors.mainThemeColor,fontSize: 20),),
                      ],
                    ),
                  ),
                  EduButton( title: LocalKeys.PayNow , onPressed: _navigateToCoursePayNow,bgColor: AppColors.mainThemeColor,style: Styles.studyTextStyle,cornerRadius: 0,),
                ],
              ),
            ],
          ),
          EduAppBar(
            backgroundColor: AppColors.mainThemeColor,
            icon: SvgPicture.asset( Resources.LOGO_IMAGE_SVG, width: 25, height: 25,),
            actions: <Widget>[
              Image(
                image: AssetImage(Resources.COMMENT_IMAGE),
                color: Colors.white,
              ),
            ],
            logoWidth: MediaQuery.of(context).size.width / 3,
            logoHeight: 20,
          )
        ],
      ),
    );
  }

  Widget schoolStage(String name, int index) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 20),
        child: Container(
          width: 60,
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
  Widget learningOutcomes() {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.arrow_right, color: AppColors.mainThemeColor),
          Text('Learning outcomes',
              style: TextStyle(color: AppColors.mainThemeColor)),
        ],
      ),
    );
  }
  void _navigateToCoursePayNow() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CourseQuestion()));
  }
}
