
import 'package:edu360/ui/screens/RegistrationScreen.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenPadding =  MediaQuery.of(context).size.width * .1;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Resources.SPLASH_BG_IMAGE),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal:  screenPadding, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Image.asset(Resources.SPLASH_LOGO_IMAGE , height: 80,),
              SizedBox(height: 30,),
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                height: 50,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.transparent),
                  ),
                  elevation: 2,
                  onPressed: _navigateToRegistrationForm,
                  child: Text(LocalKeys.SIGN_UP , style:  Styles.baseTextStyle.copyWith(
                    fontSize: 16,
                  ),).tr(),
                 color: AppColors.mainThemeColor,
                ),
              ),
              SizedBox(height: 20,),
              ButtonTheme(
                minWidth: MediaQuery.of(context).size.width,
                height: 50,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.transparent),
                  ),
                  elevation: 2,
                  onPressed: (){},
                  child: Text(LocalKeys.ALREADY_HAVE_ACCOUNT , style: Styles.baseTextStyle.copyWith(
                    color: AppColors.mainThemeColor,
                    fontSize: 16,
                  ),).tr(),
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .05,),
              Text(LocalKeys.SIGN_UP_TIPS , textAlign: TextAlign.center ,style: Styles.baseTextStyle).tr(),
              SizedBox(height: 5,),
              GestureDetector(
                onTap: (){},
                child: Text(LocalKeys.SIGN_UP_TERMS,
                  style: Styles.baseTextStyle.copyWith(
                    decoration: TextDecoration.underline,
                  ),).tr(),),
              SizedBox(height: 15,),
            ],
          ),
        ),
      ),
    );
  }
  _navigateToRegistrationForm() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => RegistrationScreen()));
  }

}
