
import 'package:edu360/ui/screens/LoginScreen.dart';
import 'package:edu360/ui/screens/RegistrationScreen.dart';
import 'package:edu360/ui/widgets/EduButton.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenPadding =  MediaQuery.of(context).size.width * .1;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(child: Center(child: Hero(
                tag: Resources.SPLASH_LOGO_IMAGE,
                child: Image.asset(Resources.SPLASH_LOGO_IMAGE , height: MediaQuery.of(context).size.height * .25,)))),
            Container(
              color: AppColors.mainThemeColor,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenPadding , vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 30,),
                    EduButton( title: LocalKeys.SIGN_UP , onPressed: _navigateToRegistrationForm),
                    SizedBox(height: 20,),
                    EduButton( title: LocalKeys.ALREADY_HAVE_ACCOUNT , onPressed: _navigateToLoginForm),
                    SizedBox(height: MediaQuery.of(context).size.height * .05,),
                    Text(LocalKeys.SIGN_UP_TIPS , textScaleFactor: 1, textAlign: TextAlign.center ,style: Styles.baseTextStyle).tr(),
                    SizedBox(height: 5,),
                    GestureDetector(
                      onTap: (){},
                      child: Text(LocalKeys.SIGN_UP_TERMS, textAlign: TextAlign.center  ,textScaleFactor: 1,
                        style: Styles.baseTextStyle.copyWith(
                          decoration: TextDecoration.underline,
                        ),).tr(),),
                    SizedBox(height: 15,),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToRegistrationForm() {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => RegistrationScreen()));
  }
  void _navigateToLoginForm() {

    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginScreen()));
  }

}
