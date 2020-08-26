import 'dart:io';

import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' as ll;
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreenHeader extends StatelessWidget {

  final UserViewModel user;
  final bool isMe , isMyFriend ;
  final Function onFollowClicked ;
  final TextStyle _headerTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
  final Function onEditProfileImageClicked ;
  final File userProfileImage ;

  ProfileScreenHeader({this.user , this.userProfileImage ,this.isMe , this.onEditProfileImageClicked , this.isMyFriend , this.onFollowClicked});
  @override
  Widget build(BuildContext context) {
    if(user.userFieldOfStudy.getStudyFieldName(context) == null || user.userFieldOfStudy.getStudyFieldName(context).length == 0){
      if(user.userFieldOfStudy.studyFieldId != null){
        user.userFieldOfStudy = BlocProvider.of<AppDataBloc>(context).systemStudyFields.firstWhere((element) => element.studyFieldId == user.userFieldOfStudy.studyFieldId);
      }
    }
    return Container(
      height: 200,
      color: AppColors.mainThemeColor,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 10,),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width:90,
                          height: 90,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: userProfileImage != null ?
                                Image.file(userProfileImage,fit: BoxFit.cover,)
                                :FadeInImage.assetNetwork(placeholder: Resources.USER_PLACEHOLDER_IMAGE, image: user.profileImagePath , fit: BoxFit.cover,),
                          ),
                        ),
                        isMe ? Positioned.directional(
                          textDirection: ll.EasyLocalization.of(context).locale.languageCode == "en" ? TextDirection.ltr : TextDirection.rtl,
                          //alignment: AlignmentDirectional.bottomEnd,
                          bottom: 10,
                          end: 10,


                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(Radius.circular(13)),
                            ),
                            child: Center(
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                onPressed: onEditProfileImageClicked,
                                icon: Icon(Icons.edit , size: 15, color: Colors.white,),
                              ),
                            ),
                          ),
                        ) : Container(width: 0, height: 0,),
                      ],
                    ),
                  ),
                  SizedBox(height: 8,),
                  Expanded(child: Text(user.userFullName!= null ? user.userFullName ?? ""  :"", style: _headerTextStyle, maxLines: 1,)),
                  Expanded(child: Text(user.userEmail != null ? user.userEmail ?? "" : "", style: _headerTextStyle,)),
                  Expanded(child: Text(user.userFieldOfStudy.getStudyFieldName(context) ?? 'No field',style: _headerTextStyle,)),
                ],
              ),
            ),
            Visibility(
              replacement: Container(
                width: 0,
                height: 0,
              ),
              visible: !isMe,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: onFollowClicked,
                    child: Chip(
                      label: Text(getChipText() , softWrap: true,  style: _headerTextStyle.copyWith(
                        color: AppColors.mainThemeColor,
                      )).tr(),
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
            )
          ],
        ),
      ),
    );
  }
  String getChipText() {
    return isMyFriend ? LocalKeys.UN_FOLLOW : LocalKeys.FOLLOW;
  }
}
