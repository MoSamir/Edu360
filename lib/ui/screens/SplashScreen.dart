import 'dart:io';

import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:edu360/blocs/bloc/AuthenticationBloc.dart';
import 'package:edu360/blocs/events/AuthenticationEvents.dart';
import 'package:edu360/blocs/states/AuthenticationStates.dart';
import 'package:edu360/ui/widgets/NetworkErrorView.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'TabHolderScreen.dart';
import 'LandingScreen.dart';
import 'dart:math' as Math;
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{

  AnimationController rotationController;
  AuthenticationBloc bloc ;
  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc;
    bloc.add(AuthenticateUser());
    rotationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    rotationController.forward();
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer(
      listener: (context , state)
        {
        if (state is AuthenticationFailed) {
          if (state.error.errorCode == HttpStatus.requestTimeout|| state.error.errorCode == HttpStatus.badGateway) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return NetworkErrorView();
                });
          }
          else if (state.error.errorCode == HttpStatus.serviceUnavailable) {
            Fluttertoast.showToast(
                msg: (LocalKeys.SERVER_UNREACHABLE).tr(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }
        }
        else if (state is UserNotInitialized) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LandingScreen()));
        } else if(state is UserAuthenticated){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => TabsHolderScreen()));
        }
      },
      bloc: bloc,
      builder: (context, state){
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(child: RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(rotationController),
            child: Hero(
                tag: Resources.SPLASH_LOGO_IMAGE,
                child: Image.asset(Resources.SPLASH_LOGO_IMAGE , height: MediaQuery.of(context).size.height * .4,)),
          ))
        );
      },
    );
  }



}


