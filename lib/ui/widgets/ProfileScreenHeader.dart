import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';

class ProfileScreenHeader extends StatelessWidget {

  final UserViewModel user;
  final bool isMe , isMyFriend ;
  final Function onFollowClicked ;
  final TextStyle _headerTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  ProfileScreenHeader({this.user , this.isMe , this.isMyFriend , this.onFollowClicked});


  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.mainThemeColor,
      elevation: 3,
      child: Container(
        height: 160,
        color: AppColors.transparent,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        image: DecorationImage(
                          image: NetworkImage(user.profileImagePath),
                          onError: (error , stackTrace){
                            return AssetImage(Resources.USER_PLACEHOLDER_IMAGE);
                          },
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 8,),
                    Text(user.userFullName , style: _headerTextStyle,),
                    SizedBox(height: 2,),
                    Text(user.userEmail, style: _headerTextStyle,),
                  ],
                ),
              ),
              Visibility(
                replacement: Container(
                  width: 0,
                  height: 0,
                ),
                visible: !isMe,
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: onFollowClicked,
                        child: Chip(
                          label: Text(getChipText() , softWrap: true,  style: _headerTextStyle.copyWith(
                            color: AppColors.mainThemeColor,
                          )),
                          backgroundColor: AppColors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: AppColors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String getChipText() {
    return isMyFriend ? LocalKeys.UN_FOLLOW : LocalKeys.FOLLOW;
  }
}
