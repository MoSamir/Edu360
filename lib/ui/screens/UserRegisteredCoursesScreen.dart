import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:edu360/blocs/states/CourseStates.dart';
import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/ui/screens/SingleCourseScreen.dart';
import 'package:edu360/ui/widgets/CourseCard.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class UserRegisteredCoursesScreen extends StatefulWidget {
  @override
  _UserRegisteredCoursesScreenState createState() => _UserRegisteredCoursesScreenState();
}

class _UserRegisteredCoursesScreenState extends State<UserRegisteredCoursesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      builder: (context, state){
        return ModalProgressHUD(
          inAsyncCall: state is UserCoursesLoading,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(crossAxisCount: 3 ,crossAxisSpacing: 5 , mainAxisSpacing: 5 ,childAspectRatio: .45 ,shrinkWrap: true,
              children: BlocProvider.of<AppDataBloc>(context).userDataBloc.coursesBloc.userSubscribedCourses.map((CourseViewModel course) => CourseCard(course: course, onCourseCardPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SingleCourseScreen(courseModel :course)));

              },)).toList(),),
          ),
        );
      },
      bloc: BlocProvider.of<AppDataBloc>(context).userDataBloc.coursesBloc,
      listener: (context , state){},
    );
  }
}
