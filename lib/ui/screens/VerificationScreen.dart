import 'dart:io';
import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:edu360/blocs/bloc/RegistrationBloc.dart';
import 'package:edu360/blocs/events/AuthenticationEvents.dart';
import 'package:edu360/blocs/events/RegistrationEvents.dart';
import 'package:edu360/blocs/states/RegistrationStates.dart';
import 'package:edu360/ui/screens/TabHolderScreen.dart';
import 'package:edu360/ui/widgets/EduButton.dart';
import 'package:edu360/ui/widgets/EduFormField.dart';
import 'package:edu360/ui/widgets/NetworkErrorView.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:edu360/utilities/Validators.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'ContactUsScreen.dart';
class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {

  GlobalKey<FormState> _verificationCodeFormKey = GlobalKey<FormState>();
  TextEditingController _verificationCodeController = TextEditingController();
  RegistrationBloc _registrationBloc ;

  @override
  Widget build(BuildContext context) {
    final double screenPadding =  24;
    _registrationBloc = BlocProvider.of<RegistrationBloc>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainThemeColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.error_outline , color: AppColors.redBackgroundColor, size: 25,),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ContactUsScreen()));
            },
          ),
        ],
      ),
      body: BlocConsumer(
        bloc: _registrationBloc,
        builder: (context, state){
          return ModalProgressHUD(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(screenPadding),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _verificationCodeFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                      Hero(
                          tag: Resources.SPLASH_LOGO_IMAGE,
                          child: Image.asset(Resources.SPLASH_LOGO_IMAGE , height: MediaQuery.of(context).size.height * .25,)),
                      SizedBox(height: 30,),
                      EduFormField(
                        validatorFn: Validator.requiredField,
                        obscureField: false,
                        placeHolder: (LocalKeys.VERIFICATION_CODE).tr(),
                        fieldController: _verificationCodeController,
                        filled: true,
                        afterSubmitKeyboardAction: TextInputAction.done,
                      ),
                      SizedBox(height: 25,),
                      Center(
                        child: SizedBox(
                            width: 200,
                            child: EduButton(title: LocalKeys.VERIFY_ME_BUTTON_LABEL, onPressed: _verifyUser,)),
                      ) ,
                    ],
                  ),
                ),
              ),

            ),
            inAsyncCall: state is RegistrationPageLoading,
          );
        },
        listener: (context, state){
          if (state is RegistrationFailed) {
            if (state.error.errorCode == HttpStatus.requestTimeout|| state.error.errorCode == HttpStatus.badGateway) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return NetworkErrorView();
                  });

              Future.delayed(Duration(seconds: 2), () {
                Navigator.pop(context);
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
          else if(state is RegistrationSuccess){

            BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc.add(LoginUser(userEmail: state.userName , userPassword: state.userPassword));

            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> TabsHolderScreen()), (route) => false);
          }
        },
      ),
    );
  }
  _verifyUser() {
    if(_verificationCodeFormKey.currentState.validate())
    _registrationBloc.add(VerifyUserPhoneNumber(phoneCode: _verificationCodeController.text.trim()));
  }
}
