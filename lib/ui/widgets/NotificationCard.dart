import 'package:edu360/data/models/NotificationViewModel.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {

  final NotificationViewModel notificationViewModel;
  final Function onNotificationClick ;
  NotificationCard({this.notificationViewModel , this.onNotificationClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4 , horizontal: 0),
      child: GestureDetector(
        onTap: onNotificationClick ?? (){},
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.mainThemeColor,
                    image: DecorationImage(
                      image: NetworkImage(notificationViewModel.notificationURL),
                    ),
                  ),
                  child: notificationViewModel.notificationURL == null ? Center(child: Text(notificationViewModel.notificationBody[0] , style: Styles.baseTextStyle.copyWith(
                    color: AppColors.white,
                  ),) ,) :  Container()),
                SizedBox(width: 5,),
                Expanded(
                  child: Text( notificationViewModel.notificationBody ?? 'this is testing notification hello world i need you to speak up for me please please please please please , hello world i need you to speak up for me please please please please please ', style: Styles.baseTextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainThemeColor,
                  ),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
