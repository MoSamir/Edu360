import 'package:edu360/data/models/QuizQuestion.dart';
import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/ui/widgets/EduButton.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:flutter/material.dart';

import 'CourseReview.dart';

class LessonQuizScreen extends StatefulWidget {

  final List<QuizQuestion> questions ;
  LessonQuizScreen({this.questions});

  @override
  _LessonQuizScreenState createState() => _LessonQuizScreenState();
}

class _LessonQuizScreenState extends State<LessonQuizScreen> {
  bool enable = false;
  int answerId , currentQuestionIndex = 0 , correctAnswersCount = 0 ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: <Widget>[
        EduButton(
          title: LocalKeys.NextQuestion,
          onPressed: _navigateToCourseQuestion,
          bgColor: AppColors.mainThemeColor,
          style: Styles.studyTextStyle,
          cornerRadius: 0,
        ),
      ],
      backgroundColor: AppColors.backgroundColor,
      appBar: EduAppBar(
        autoImplyLeading: true,
        backgroundColor: AppColors.mainThemeColor,
        logoWidth: MediaQuery.of(context).size.width / 3,
        logoHeight: 20,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            'Question ${currentQuestionIndex+1} ',
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
                hintText: widget.questions[currentQuestionIndex].questionBody,
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
              itemCount: widget.questions[currentQuestionIndex].questionAnswers.length,
              itemBuilder: (context , answerIndex){
                return InkWell(
                    onTap: (){
                      setState(() {
                        answerId = answerIndex;
                      });
                    },
                    child: answerBody(widget.questions[currentQuestionIndex].questionAnswers[answerIndex] ,answerIndex));
              }),
        ],
      ),
    );
  }

  void _navigateToCourseQuestion() {

    if(answerId == widget.questions[currentQuestionIndex].correctAnswer) correctAnswersCount++;


    if(currentQuestionIndex == (widget.questions.length -1)) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => CourseReview(correctAnswersCount , widget.questions.length)),result: ((correctAnswersCount/widget.questions.length) * 100));
    } else {
      currentQuestionIndex ++ ;
      answerId = -1;
      setState(() {});
    }

  }

  Widget answerBody(String answer , int index) {
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
                answer,
                style: TextStyle(fontSize: 20, color: AppColors.mainThemeColor),
              ),
            ],
          )),
    );
  }
}
