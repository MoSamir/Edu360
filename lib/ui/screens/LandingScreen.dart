
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
              EduButton( title: LocalKeys.SIGN_UP , onPressed: _navigateToRegistrationForm),
              SizedBox(height: 20,),
              EduButton( title: LocalKeys.ALREADY_HAVE_ACCOUNT , onPressed: _navigateToLoginForm),
              SizedBox(height: MediaQuery.of(context).size.height * .05,),
              Text(LocalKeys.SIGN_UP_TIPS , textScaleFactor: 1, textAlign: TextAlign.center ,style: Styles.baseTextStyle).tr(),
              SizedBox(height: 5,),
              GestureDetector(
                onTap: (){},
                child: Text(LocalKeys.SIGN_UP_TERMS, textScaleFactor: 1,
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

  void _navigateToRegistrationForm() {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => RegistrationScreen()));
  }
  void _navigateToLoginForm() {

    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginScreen()));
  }

}
