import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/ui/screens/OtherUsersProfileScreen.dart';
import 'package:edu360/utilities/AppStyles.dart';
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
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child:ListView.builder(
                shrinkWrap: true,
                itemCount: widget.users != null ? widget.users.length : 0,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return story(widget.users[index] , index);
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
            CircleAvatar(
              backgroundColor: AppColors.mainThemeColor,
              backgroundImage: NetworkImage(user.profileImagePath ?? ''),
              radius: 30,
            ),
          SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(user.userFullName ,style: TextStyle(color: AppColors.mainThemeColor,fontWeight: FontWeight.bold),),
                SizedBox(
                  height: 5,
                ),
                Text(user.userEmail ,style: TextStyle(color: AppColors.mainThemeColor,)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
