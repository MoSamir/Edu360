 import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
class ComplainResultScreen extends StatelessWidget {

  final bool successResult ;
  ComplainResultScreen({this.successResult});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EduAppBar(
        backgroundColor: AppColors.mainThemeColor,
        autoImplyLeading: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          getResultIcon(),
          SizedBox(height: 10,),
          getResultMessage(),
          SizedBox(height: 10,),
          Center(
            child: GestureDetector(
                onTap: ()=> Navigator.pop(context),
                child: Text(LocalKeys.BACK_LABEL).tr()),
          ),
        ],
      ),

    );
  }

  getResultIcon() {
    return successResult ? Icon(Icons.check_circle_outline , color: AppColors.mainThemeColor, size: 50,) :
    Icon(Icons.cancel , color: AppColors.redBackgroundColor, size: 50,);
  }

  getResultMessage() {
    return Text(successResult ? LocalKeys.SUCCESS_COMPLAINT_MESSAGE : LocalKeys.ERROR_COMPLAINT_MESSAGE , textAlign: TextAlign.center, ).tr() ;
  }
}
