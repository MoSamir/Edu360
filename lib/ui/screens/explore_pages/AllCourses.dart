import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/data/models/GradeViewModel.dart';
import 'package:edu360/ui/screens/SingleCourseScreen.dart';
import 'package:edu360/ui/widgets/CourseCard.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:easy_localization/easy_localization.dart';
class AllCourses extends StatefulWidget {

  final List<CourseViewModel> courses ;
  AllCourses(this.courses);

  @override
  _AllCoursesState createState() => _AllCoursesState();
}

class _AllCoursesState extends State<AllCourses> {





  BehaviorSubject<List<CourseViewModel>> coursesList = BehaviorSubject<List<CourseViewModel>>();
  GradeViewModel selectedGrade ;

  getDropDownMenu(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Icon(Icons.filter_list),
          SizedBox(width: 10,),
          Expanded(
            child: DropdownButton<GradeViewModel>(
              elevation: 5,
            isExpanded: true,
              hint:  Text(LocalKeys.ALL_GRADES).tr(),
              value: selectedGrade,
              onChanged: (GradeViewModel gradeId) {
                setState(() {
                  selectedGrade = gradeId;
                  List<CourseViewModel> filteredCourses = widget.courses.where((element) => element.targetClasses[0].getGradeName(context) == gradeId.getGradeName(context)).toList();

                  fieldCourses = widget.courses == null ? List():
                  filteredCourses = filteredCourses.where((element) => BlocProvider.of<AppDataBloc>(context).userDataBloc.coursesBloc.userSubscribedCourses.contains(element) == false).toList();
                  coursesList.sink.add(filteredCourses);
                });
              },
              items: BlocProvider.of<AppDataBloc>(context).systemGrades.map((GradeViewModel gradeModel) {
                return  DropdownMenuItem<GradeViewModel>(
                  value: gradeModel,
                  child: Text(gradeModel.getGradeName(context) , textAlign: TextAlign.center,),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    coursesList.sink.add(widget.courses);
  }

  List<CourseViewModel> fieldCourses = List();

  @override
  Widget build(BuildContext context) {
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
                  getDropDownMenu(),
                   StreamBuilder<List<CourseViewModel>>(
                     builder: (context , snapshot){
                       return snapshot.data != null ?  GridView.count(
                           shrinkWrap: true,
                           padding: EdgeInsets.symmetric(
                               horizontal: 10.0, vertical: 20.0),
                           crossAxisSpacing: 10.0,
                           mainAxisSpacing: 17.0,
                           childAspectRatio: 0.545,
                           crossAxisCount: 2,
                           primary: false,
                           children:  List.generate(
                             snapshot.data.length,
                                 (index) {
                               return CourseCard(course: snapshot.data[index], onCourseCardPressed: (){
                                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SingleCourseScreen(courseModel: snapshot.data[index],)));
                               },);
                             },
                           ) ) : Container();
                     },
                     initialData: widget.courses,
                     stream: coursesList,
                   ),
                ],
              )
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    coursesList.close();
    super.dispose();
  }
}
