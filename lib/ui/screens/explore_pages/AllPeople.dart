import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/ui/screens/OtherUsersProfileScreen.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class AllPeople extends StatefulWidget {


  List<UserViewModel> users ;
  AllPeople(this.users);

  @override
  _AllPeopleState createState() => _AllPeopleState();
}

class _AllPeopleState extends State<AllPeople> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.users != null ? widget.users.length : 0,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return story(widget.users[index] , index);
          }),
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
                  Text(user.userFullName , overflow: TextOverflow.ellipsis,style: TextStyle(color: AppColors.mainThemeColor,fontWeight: FontWeight.bold),),
                  SizedBox(
                    height: 5,
                  ),
                  Text(user.userEmail ,style: TextStyle(color: AppColors.mainThemeColor,) , overflow: TextOverflow.ellipsis,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
