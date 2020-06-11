import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';

import 'PreLoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {




  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3) , ()=> _navigateToHome());
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Resources.SPLASH_BG_IMAGE),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  _navigateToHome() {
    try {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch(exception){}
  }

}


