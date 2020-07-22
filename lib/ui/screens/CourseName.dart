import 'package:edu360/ui/screens/DetilesCourseName.dart';
import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/ui/widgets/EduButton.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CourseName extends StatefulWidget {
  @override
  _CourseNameState createState() => _CourseNameState();
}

class _CourseNameState extends State<CourseName> {
  var schoolStageItem = [
    {"name": "KG1"},
    {"name": "KG2"},
    {"name": "P1"},
    {"name": "P2"},
    {"name": "P3"},
    {"name": "P6"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
//      appBar:  EduAppBar(
//        backgroundColor: AppColors.mainThemeColor,
//        icon: Icons.search,
//        actions: <Widget>[Icon(Icons.message)],
//        logoWidth: MediaQuery.of(context).size.width / 3,
//        logoHeight: 20,
//      ),
      body: Stack(
        children: <Widget>[
          ListView(
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
              SizedBox(
                height: 50,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(),
                    itemCount: schoolStageItem.length,
                    itemBuilder: (context, index) {
                      return schoolStage(schoolStageItem[index]['name'], index);
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
                      child: Text('Learning outcomes:',
                          style: TextStyle(color: AppColors.mainThemeColor,fontWeight: FontWeight.bold)),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return learningOutcomes();
                        }),
                    SizedBox(
                      height: 15,
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
                            child: Text('1 lesson/week',
                                style: Styles.baseTextStyle,)),
                        SizedBox(width: 15,),
                        Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.mainThemeColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text('1 lesson/week',
                              style: Styles.baseTextStyle,)),
                      ],
                    ),
                    SizedBox(height: 15,),
                    EduButton( title: LocalKeys.Subscribe , onPressed: _navigateToDetailsCourseName,bgColor: AppColors.mainThemeColor,style: Styles.studyTextStyle,cornerRadius: 0,),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Teacher Description',
                            style: TextStyle(
                              color: AppColors.mainThemeColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                            )),
                          SizedBox(height: 10,),
                          Text('teacher description teacher description teacher description teacher description teacher description teacher description teacher description teacher description teacher description teacher description teacher description ',
                              style: TextStyle(
                                  color: AppColors.mainThemeColor,
                                  fontSize: 14,
                              )),
                        ],
                      ),
                    )

                  ],
                ),
              ),
              ],
          ),
          EduAppBar(
            backgroundColor: AppColors.mainThemeColor,
            icon: Icons.search,
            actions: <Widget>[

           Image(image: AssetImage(Resources.COMMENT_IMAGE ),color: Colors.white,),
            ],
            logoWidth: MediaQuery.of(context).size.width / 3,
            logoHeight: 20,
          ),
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
  void _navigateToDetailsCourseName() {

   Navigator.of(context).push(MaterialPageRoute(builder: (context)=> DetailsCourseName())
   );
  }
}

