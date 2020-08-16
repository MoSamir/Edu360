import 'package:edu360/data/models/NotificationViewModel.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/Resources.dart';
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
                  ),
                  child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage.assetNetwork(placeholder: Resources.USER_PLACEHOLDER_IMAGE, image: notificationViewModel.notificationURL, fit: BoxFit.cover,),
              ),),
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
