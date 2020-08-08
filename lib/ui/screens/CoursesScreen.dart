import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:edu360/blocs/bloc/SingleCourseBloc.dart';
import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/ui/screens/CourseLessonsScreen.dart';
import 'package:edu360/ui/widgets/CourseCard.dart';
import 'package:edu360/utilities/AppStyles.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CoursesScreen extends StatefulWidget {
  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: GridView.count(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20.0),
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 17.0,
                    childAspectRatio: 0.545,
                    crossAxisCount: 2,
                    primary: false,
                    children: List.generate(
                      BlocProvider.of<AppDataBloc>(context).userDataBloc.coursesBloc.userSubscribedCourses!= null ? BlocProvider.of<AppDataBloc>(context).userDataBloc.coursesBloc.userSubscribedCourses.length : 0,
                          (index) {
                        return CourseCard(course: BlocProvider.of<AppDataBloc>(context).userDataBloc.coursesBloc.userSubscribedCourses[index], onCourseCardPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>BlocProvider.value(value: SingleCourseBloc() , child: CourseLessonsScreen(course: BlocProvider.of<AppDataBloc>(context).userDataBloc.coursesBloc.userSubscribedCourses[index]),)));
                            },);

                      },
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
