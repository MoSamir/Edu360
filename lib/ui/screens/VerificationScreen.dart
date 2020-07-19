import 'dart:io';
import 'package:edu360/blocs/bloc/RegistrationBloc.dart';
import 'package:edu360/blocs/events/RegistrationEvents.dart';
import 'package:edu360/blocs/states/RegistrationStates.dart';
import 'package:edu360/ui/screens/TabHolderScreen.dart';
import 'package:edu360/ui/widgets/EduButton.dart';
import 'package:edu360/ui/widgets/EduFormField.dart';
import 'package:edu360/ui/widgets/NetworkErrorView.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:edu360/utilities/Validators.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
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
      body: BlocConsumer(
        bloc: _registrationBloc,
        builder: (context, state){
          return ModalProgressHUD(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(screenPadding),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(Resources.SPLASH_BG_IMAGE),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Form(
                  key: _verificationCodeFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
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
          else if(state is RegistrationSuccess){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> TabsHolderScreen()), (route) => false);
          }
        },
      ),
    );
  }
  _verifyUser() {
    if(_verificationCodeFormKey.currentState.validate())
    _registrationBloc.add(VerifyUserInformation(verificationCode: _verificationCodeController.text.trim()));
  }
}
