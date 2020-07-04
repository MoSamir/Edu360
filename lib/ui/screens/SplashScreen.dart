import 'dart:io';

import 'package:edu360/blocs/bloc/AuthenticationBloc.dart';
import 'package:edu360/blocs/bloc/UserDataBloc.dart';
import 'package:edu360/blocs/events/AuthenticationEvents.dart';
import 'package:edu360/blocs/states/AuthenticationStates.dart';
import 'package:edu360/ui/screens/FeedsScreen.dart';
import 'package:edu360/ui/widgets/NetworkErrorView.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'HomeScreen.dart';
import 'LandingScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  AuthenticationBloc bloc ;
  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<UserDataBloc>(context).authenticationBloc;
    bloc.add(AuthenticateUser());
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer(
      listener: (context , state)
        {
        if (state is AuthenticationFailed) {
          if (state.error.errorCode == HttpStatus.requestTimeout) {
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
          else {
            Fluttertoast.showToast(
                msg: state.error.errorMessage ?? '',
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

          Navigator.of(context).push(MaterialPageRoute(builder: (context) => LandingScreen()));
        } else if(state is UserAuthenticated){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      },
      bloc: bloc,
      builder: (context, state){
        return ModalProgressHUD(
          inAsyncCall: state is AuthenticationLoading,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Resources.SPLASH_BG_IMAGE),
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      },
    );
  }



}


