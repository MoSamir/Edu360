import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';

import 'ViewListen.dart';

class DetailsCourseName extends StatefulWidget {
  @override
  _DetailsCourseNameState createState() => _DetailsCourseNameState();
}

class _DetailsCourseNameState extends State<DetailsCourseName> {
  var lesionsItem = [
    {
      'name': "Leeson 1#",
      'video': "done",
      'quzi': "90",
      'cards': "Off"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar:  EduAppBar(
        backgroundColor: AppColors.mainThemeColor,
        icon:   Image.asset(Resources.WHITE_LOGO_IMAGE)  , //ImageIcon(),
        actions: <Widget>[ Image(image: AssetImage(Resources.COMMENT_IMAGE ),color: Colors.transparent,),],
        logoWidth: MediaQuery.of(context).size.width / 3,
        logoHeight: 20,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Course Name',
                    style: TextStyle(
                      color: AppColors.mainThemeColor,
                      fontSize: 20,
                    )),
                Image(
                  image: AssetImage(Resources.SETTINGS_IMAGE),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return lesions();
                }),
          ],
        ),
      ),
    );
  }

  Widget lesions() {
    return InkWell(
      onTap: ()=>  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewListen())),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.white, borderRadius: BorderRadius.circular(15)),
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Listen 1#" ,
                style: TextStyle(
                    color: AppColors.mainThemeColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "video : done",
                style: TextStyle(
                    color: AppColors.mainThemeColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "quiz : 90%" ,
                style: TextStyle(color: AppColors.mainThemeColor, fontSize: 14),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "cards : off" ,
                    style: TextStyle(color: AppColors.mainThemeColor, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "View",
                    style: TextStyle(
                        color: AppColors.mainThemeColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
