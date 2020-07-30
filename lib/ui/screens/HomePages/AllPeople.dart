import 'package:edu360/utilities/AppStyles.dart';
import 'package:flutter/material.dart';
class AllPeople extends StatefulWidget {
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
                itemCount: 10,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return story(index);
                }),
          ),

        ],
      ),
    );
  }
  Widget story(int index) {
    return Container(
      padding: EdgeInsets.all(5),
      color: Colors.white,
      child: Row(

        children: <Widget>[
          CircleAvatar(
            backgroundColor: AppColors.mainThemeColor,
            radius: 30,
          ),
        SizedBox(width: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Yousef Elshazly',style: TextStyle(color: AppColors.mainThemeColor,fontWeight: FontWeight.bold),),
              SizedBox(
                height: 5,
              ),
              Text('Entrepreneurship',style: TextStyle(color: AppColors.mainThemeColor,)),
            ],
          )
        ],
      ),
    );
  }
}
