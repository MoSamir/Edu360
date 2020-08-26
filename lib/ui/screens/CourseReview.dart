import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/ui/widgets/EduButton.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
class CourseReview extends StatefulWidget {

  final int correctAnswerCount , totalQuestionsCount ;
  CourseReview(this.correctAnswerCount , this.totalQuestionsCount);

  @override
  _CourseReviewState createState() => _CourseReviewState();
}

class _CourseReviewState extends State<CourseReview> {
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
              child: Center(
                child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text((LocalKeys.YOUR_GRADE).tr() ,style: TextStyle(color: AppColors.mainThemeColor,fontSize: 18)),
                  SizedBox(height: 5,),
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: AppColors.redBackgroundColor,
                    child: Text('${widget.correctAnswerCount}/${widget.totalQuestionsCount}',style: TextStyle(fontSize: 50,color: Colors.white,fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(height: 10,),
                  Visibility(
                    replacement: Container(width: 0, height: 0,),
                      visible: false,
                      child: Text('Oops, No problem!',style: TextStyle(color: AppColors.mainThemeColor,fontSize: 18))),
                ],
            ),
          ),
              )),
//          Padding(
//            padding: const EdgeInsets.only(left: 10,right: 10),
//            child: EduButton(
//              title:"Use your retake for the week",
//              onPressed: _navigateToCourseReview,
//              bgColor: AppColors.mainThemeColor,
//              style: Styles.studyTextStyle,
//              cornerRadius: 15,
//            ),
//          ),
//          SizedBox(height: 10,),
//          Padding(
//            padding: const EdgeInsets.only(left: 10,right: 10),
//            child: EduButton(
//              title:"Review",
//              onPressed: _navigateToCourseReview,
//              bgColor: AppColors.white,
//              style: TextStyle(color:  AppColors.mainThemeColor,fontSize: 20),
//              cornerRadius: 15,
//            ),
//          ),
//          SizedBox(height: 10,),
          EduButton(
            title: (LocalKeys.DONE).tr(),
            onPressed: _navigateToCourseReview,
            bgColor: AppColors.mainThemeColor,
            style: Styles.studyTextStyle,
            cornerRadius: 0,
          ),
        ],
      ),
    );
  }

  void _navigateToCourseReview() {
    Navigator.pop(context , (widget.correctAnswerCount / widget.totalQuestionsCount) * 100);

//    Navigator.of(context)
//        .push(MaterialPageRoute(builder: (context) => CourseReview()));
  }
}
