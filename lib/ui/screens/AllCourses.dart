import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';

import 'CourseName.dart';

class AllCourses extends StatefulWidget {
  @override
  _AllCoursesState createState() => _AllCoursesState();
}

class _AllCoursesState extends State<AllCourses> {
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

                    Container(
                      padding: EdgeInsets.only(left: 10,bottom: 10, right: 10 , top: 25),
                      height: MediaQuery.of(context).size.height * .4,
                      width: MediaQuery.of(context).size.width,
                      color: AppColors.mainThemeColor,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  'Mr. Ahmed',
                                  style: Styles.studyTextStyle.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Text(
                                  'Ad',
                                  style: Styles.studyTextStyle.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            flex: 3,
                            child: getDataCourses(),
                          ),
                        ],
                      ),
                    ),
                    GridView.count(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20.0),
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 17.0,
                        childAspectRatio: 0.545,
                        crossAxisCount: 2,
                        primary: false,
                        children: List.generate(
                          7,
                              (index) {
                            return getDataCourses();
                          },
                        ))
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget getDataCourses(){
    return InkWell(
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>CourseName())),
      child: Container(

        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20)
        ),
        child:  Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Material(
                  type: MaterialType.card,
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            'Course Name',
                            textScaleFactor: 1,
                            style: TextStyle(
                                color: AppColors.mainThemeColor,
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Progress: 85%',
                            textScaleFactor: 1,
                            style: TextStyle(
                                color: AppColors.mainThemeColor,
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Grade: 90% ',
                            textScaleFactor: 1,
                            style: TextStyle(
                              color: AppColors.mainThemeColor,
                              fontSize: 15,),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Text(
              'Subscribe Now',
              textScaleFactor: 1,
              style: TextStyle(
                  color: AppColors.mainThemeColor,
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
