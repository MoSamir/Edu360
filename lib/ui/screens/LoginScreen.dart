import 'dart:io';

import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:edu360/blocs/bloc/AuthenticationBloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:edu360/blocs/bloc/UserDataBloc.dart';
import 'package:edu360/blocs/events/AuthenticationEvents.dart';
import 'package:edu360/blocs/states/AuthenticationStates.dart';
import 'package:edu360/ui/screens/WallScreen.dart';
import 'package:edu360/ui/screens/TabHolderScreen.dart';
import 'package:edu360/ui/widgets/EduButton.dart';
import 'package:edu360/ui/widgets/EduFormField.dart';
import 'package:edu360/ui/widgets/NetworkErrorView.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:edu360/utilities/Validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  TextEditingController _userEmailController , _userPasswordController ;
  FocusNode _userEmailFocusNode , _userPasswordFocusNode ;
  GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();




  @override
  void initState() {
    super.initState();
    _userEmailController = TextEditingController();
    _userPasswordController = TextEditingController();
    _userEmailFocusNode = FocusNode();
    _userPasswordFocusNode = FocusNode();
  }


  @override
  Widget build(BuildContext context) {

    final double screenPadding =  24;

    return Scaffold(
      body: BlocConsumer(
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
              child: Form(
                key: _loginFormKey,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenPadding),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              EduFormField(
                                afterSubmitKeyboardAction: TextInputAction.next,
                                autoValidate: false,
                                focusNode: _userEmailFocusNode,
                                nextFocusNode: _userPasswordFocusNode,
                                fieldController: _userEmailController,
                                placeHolder: LocalKeys.EMAIL,
                                obscureField: false,
                                validatorFn: Validator.mailValidator,
                              ),
                              SizedBox(height: 20,),
                              EduFormField(
                                afterSubmitKeyboardAction: TextInputAction.done,
                                autoValidate: false,
                                focusNode: _userPasswordFocusNode,
                                fieldController: _userPasswordController,
                                placeHolder: LocalKeys.PASSWORD,
                                obscureField: true,
                                validatorFn: Validator.requiredField,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: EduButton(
                              onPressed: _loginButtonPressed,
                              title: LocalKeys.LOGIN,
                            ),
                          ),
                        ),
                        SizedBox(height: 40,),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context , state){
          if (state is AuthenticationFailed) {
            if (state.error.errorCode == HttpStatus.requestTimeout) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return NetworkErrorView();
                  });
            }
            else if(state.error.errorCode == HttpStatus.serviceUnavailable){
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
          else if(state is UserAuthenticated){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> TabsHolderScreen()));
          }
        },
        bloc: BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc,
      ),
    );
  }

  void _loginButtonPressed() {

    if(_loginFormKey.currentState.validate()){
      BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc.add(LoginUser(userEmail: _userEmailController.text, userPassword: _userPasswordController.text));
    }

  //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> HomeScreen()), (route) => false);
  }
}







