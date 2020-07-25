import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';

class EduCircleAvatar extends StatelessWidget {
  final UserViewModel userModel ;
  final bool showUserInformation ;
  final Function onPressed ;
  final int userRate ;
  EduCircleAvatar({this.userModel , this.userRate , this.onPressed , this.showUserInformation});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? (){},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 75,
          height: 75,
          child: Stack(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: userModel.profileImagePath != null && userModel.profileImagePath.length > 0 ? NetworkImage(
                            userModel.profileImagePath,
                        ) : AssetImage(Resources.USER_PLACEHOLDER_IMAGE),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: showUserInformation ?? false,
                      replacement: Container(
                        width: 0,
                        height: 0,
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(userModel.userFullName ?? "Username"),
                          Text(userModel.userFieldOfStudy != null ? userModel.userFieldOfStudy.studyFieldNameEn : "English Literal" , style: TextStyle(
                            fontSize: 13,
                          ),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 25,
                  width: 25,
                  child: Center(child: Text(userRate.toString() , style: Styles.baseTextStyle)),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.mainThemeColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
