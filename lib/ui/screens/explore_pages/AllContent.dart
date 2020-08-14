import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/ui/widgets/CourseCard.dart';
import 'package:edu360/ui/widgets/PlaceHolderWidget.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';

import '../../UIHelper.dart';
import '../OtherUsersProfileScreen.dart';
import '../SingleCourseScreen.dart';

class AllContent extends StatefulWidget {


  final List<UserViewModel> users , teachers ;
  final List<PostViewModel> posts ;
  final List<CourseViewModel> courses ;
  AllContent({this.courses , this.teachers , this.users , this.posts });



  @override
  _AllContentState createState() => _AllContentState();
}

class _AllContentState extends State<AllContent> {
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: ListView(
        children: <Widget>[
          Visibility(
            visible: widget.courses != null && widget.courses.length > 0,
            child: GridView.count(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                    horizontal: 10.0, ),
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 17.0,
                childAspectRatio: 0.545,
                crossAxisCount: 2,
                primary: false,
                children:  List.generate(
                  widget.courses.length,
                      (index) {
                    return CourseCard(course: widget.courses[index], onCourseCardPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SingleCourseScreen(courseModel: widget.courses[index],)));
                    },);
                  },
                ) ),
            replacement: Container(width: 0, height: 0,),
          ),
          Visibility(
            visible:  false , //widget.posts != null && widget.posts.length > 0,
            replacement: Container(width: 0, height: 0,),
            child: GridView.count(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                horizontal: 10.0, ),
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 17.0,
                childAspectRatio: 0.545,
                crossAxisCount: 2,
                primary: false,
                children: List.generate(
                   widget.posts.length,
                      (index) {
                    return UIHelper.getProfilePostView(widget.posts[index], context , postAction: (){});
                  },
                )),
          ),
          Visibility(
            visible: widget.users != null && widget.users.length > 0,
            replacement: Container(width: 0, height: 0,),
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.users.length ,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return story(widget.users[index] , index);
                }),
          ),
          Visibility(
            visible: widget.teachers != null && widget.teachers.length > 0,
            replacement: Container(width: 0, height: 0,),
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.teachers.length ,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return story(widget.teachers[index] , index);
                }),
          ),
        ],
      ),
    );
  }

  Widget story(UserViewModel user ,  int index) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> OtherUsersProfileScreen(userId: user.userId,)));
      },
      child: Container(
        padding: EdgeInsets.all(5),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: FadeInImage.assetNetwork(placeholder: Resources.USER_PLACEHOLDER_IMAGE, image: user.profileImagePath , fit: BoxFit.cover,),
              ),
            ),
            SizedBox(width: 20,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(user.userFullName ,style: TextStyle(color: AppColors.mainThemeColor,fontWeight: FontWeight.bold),),
                  SizedBox(
                    height: 5,
                  ),
                  Text(user.userEmail ,style: TextStyle(color: AppColors.mainThemeColor,)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}
