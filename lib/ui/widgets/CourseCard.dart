import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
class CourseCard extends StatelessWidget {
  final CourseViewModel course ;
  final Function onCourseCardPressed ;
  CourseCard({this.course , this.onCourseCardPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCourseCardPressed ?? (){},
      child: Material(
        color: AppColors.backgroundColor,
          elevation: 2,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          type: MaterialType.card,
          child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              course.courseImage ?? '',
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(course.courseTitle ?? '', style: Styles.baseTextStyle,),
                Text(course.instructorName ?? '', style: Styles.baseTextStyle,),
                Text(course.targetClasses.join(',') ?? '', style: Styles.baseTextStyle,),
              ],
            ),
            Column(
              children: <Widget>[
                Text(course.feesPerMonth.toString(), style: Styles.baseTextStyle.copyWith(fontSize: 20),),
                Text(LocalKeys.EGP_PER_MONTH, style: Styles.baseTextStyle,).tr(),
              ],
            ),
          ],
        ),
      ),
     ),
    );
  }
}
