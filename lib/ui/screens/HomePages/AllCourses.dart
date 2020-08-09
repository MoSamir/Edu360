import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/ui/screens/SingleCourseScreen.dart';
import 'package:edu360/ui/widgets/CourseCard.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class AllCourses extends StatefulWidget {

  final List<CourseViewModel> courses ;
  AllCourses(this.courses);

  @override
  _AllCoursesState createState() => _AllCoursesState();
}

class _AllCoursesState extends State<AllCourses> {


  @override
  void initState() {
    super.initState();
  }

  List<CourseViewModel> fieldCourses = List();

  @override
  Widget build(BuildContext context) {

    fieldCourses = widget.courses == null ? List():
    widget.courses.where((element) => BlocProvider.of<AppDataBloc>(context).userDataBloc.coursesBloc.userSubscribedCourses.contains(element) == false).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: ListView(
        children: <Widget>[
          Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Top Rated',
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: AppColors.mainThemeColor),),
                  ),
        fieldCourses!= null ?  GridView.count(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 17.0,
                      childAspectRatio: 0.545,
                      crossAxisCount: 2,
                      primary: false,
                      children:  List.generate(
                        fieldCourses.length,
                            (index) {
                          return CourseCard(course: fieldCourses[index], onCourseCardPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SingleCourseScreen(courseModel: fieldCourses[index],)));
                          },);
                        },
                      ) ) : Container(),
                ],
              )
          ),
        ],
      ),
    );
  }
}
