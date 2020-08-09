import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/ui/widgets/EduButton.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:flutter/material.dart';

import 'CourseReview.dart';

class LessonQuizScreen extends StatefulWidget {
  @override
  _LessonQuizScreenState createState() => _LessonQuizScreenState();
}

class _LessonQuizScreenState extends State<LessonQuizScreen> {
  bool enable = false;
  int answerId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: EduAppBar(
        autoImplyLeading: true,
        backgroundColor: AppColors.mainThemeColor,
        logoWidth: MediaQuery.of(context).size.width / 3,
        logoHeight: 20,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(left: 7, right: 7),
                          decoration: BoxDecoration(
                            color: AppColors.mainThemeColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Counter: 00:00:00',
                            style: Styles.studyTextStyle,
                          )),
                      Container(
                          padding: EdgeInsets.only(left: 7, right: 7),
                          decoration: BoxDecoration(
                            color: AppColors.canaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Pause',
                            style: Styles.studyTextStyle,
                          )),
                      Container(
                          padding: EdgeInsets.only(left: 7, right: 7),
                          decoration: BoxDecoration(
                            color: AppColors.redBackgroundColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Cancel',
                            style: Styles.studyTextStyle,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Question 1  >',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20, color: AppColors.mainThemeColor),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      maxLines: 7,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                        hintText: "Text...",
                        hintStyle: TextStyle(
                            fontSize: 20, color: AppColors.mainThemeColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ListView.builder(
                    physics:  NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 4,
                      itemBuilder: (context ,index){
                        return InkWell(
                            onTap: (){
                             setState(() {
                               answerId = index;
                             });
                            },
                            child: answerBody(index));
                      })
                ],
              ),
            ),
          ),
          EduButton(
            title: LocalKeys.NextQuestion,
            onPressed: _navigateToCourseQuestion,
            bgColor: AppColors.mainThemeColor,
            style: Styles.studyTextStyle,
            cornerRadius: 0,
          ),
        ],
      ),
    );
  }

  void _navigateToCourseQuestion() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CourseReview()));
  }

  Widget answerBody(int index) {
    bool isSelected = answerId == index;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                isSelected ? Icons.check_circle : Icons.check_circle_outline,
                color: AppColors.mainThemeColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Answer $index',
                style: TextStyle(fontSize: 20, color: AppColors.mainThemeColor),
              ),
            ],
          )),
    );
  }
}
