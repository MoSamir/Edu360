import 'dart:io';

import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:edu360/blocs/bloc/AuthenticationBloc.dart';
import 'package:edu360/blocs/events/AuthenticationEvents.dart';
import 'package:edu360/blocs/states/AuthenticationStates.dart';
import 'package:edu360/ui/screens/LoginScreen.dart';
import 'package:edu360/ui/screens/TabHolderScreen.dart';
import 'package:edu360/ui/widgets/EduButton.dart';
import 'package:edu360/ui/widgets/EduFormField.dart';
import 'package:edu360/ui/widgets/NetworkErrorView.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:edu360/utilities/Validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:easy_localization/easy_localization.dart';
import 'ContactUsScreen.dart';

class PasswordResetScreen extends StatefulWidget {

  final String userEmail;
  PasswordResetScreen({this.userEmail});

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {

  AuthenticationBloc authenticationBloc ;
  TextEditingController _userCodeController , _userNewPasswordController , _userConfirmPasswordController ;
  FocusNode _userCodeNode , _userPasswordNode , _userConfirmPasswordNode;
  GlobalKey<FormState> _resetPasswordFormKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    authenticationBloc = BlocProvider.of<AppDataBloc>(context).userDataBloc.authenticationBloc;
    _userCodeController = TextEditingController();
    _userNewPasswordController = TextEditingController();
    _userConfirmPasswordController = TextEditingController();

    _userCodeNode = FocusNode();
    _userPasswordNode = FocusNode();
    _userConfirmPasswordNode = FocusNode();

  }



  @override
  Widget build(BuildContext context) {
    final double screenPadding =  24;
    return Scaffold(
      persistentFooterButtons: <Widget>[
        EduButton(
          title: (LocalKeys.RESET_PASSWORD).tr(),
          onPressed: (){
            if(_resetPasswordFormKey.currentState.validate()){
              authenticationBloc.add(ResetPassword(
                userEmail: widget.userEmail,
                userNewPassword: _userConfirmPasswordController.text,
                userPassCode: _userCodeController.text,
              ));
            }
          },
        ),
      ],
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
        builder: (context, state){
          return ModalProgressHUD(
            inAsyncCall: state is AuthenticationLoading,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(screenPadding),
                child: Form(
                  key: _resetPasswordFormKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).size.height * .1,),

                      Hero(
                          tag: Resources.SPLASH_LOGO_IMAGE,
                          child: Image.asset(Resources.SPLASH_LOGO_IMAGE , height: MediaQuery.of(context).size.height * .25,)),
                      SizedBox(height: 10,),
                      Text((LocalKeys.RESET_PASSWORD_FOR).tr(args:[widget.userEmail]), textAlign: TextAlign.center,),
                      SizedBox(height: 10,),
                      EduFormField(
                        fieldController: _userCodeController,
                        forceLTR: false,
                        placeHolder: (LocalKeys.VERIFICATION_CODE).tr(),
                        afterSubmitKeyboardAction: TextInputAction.next,
                        validatorFn: Validator.requiredField,
                        filled: true,
                        focusNode: _userCodeNode,
                        nextFocusNode: _userPasswordNode,
                      ),
                      SizedBox(height: 10,),
                      EduFormField(placeHolder: (LocalKeys.PASSWORD).tr() , fieldController: _userNewPasswordController
                          , focusNode: _userPasswordNode , nextFocusNode: _userConfirmPasswordNode ,
                          validatorFn: Validator.requiredField ,  afterSubmitKeyboardAction: TextInputAction.next , obscureField: true),
                      SizedBox(height: 10,),
                      EduFormField(placeHolder: (LocalKeys.CONFIRM_PASSWORD).tr() , fieldController: _userConfirmPasswordController
                          , focusNode: _userConfirmPasswordNode , autoValidate: true,
                          validatorFn: (passwordConfirmation){
                            return passwordConfirmation == _userNewPasswordController.text ? null : (LocalKeys.CONFIRM_PASSWORD_ERROR).tr();
                          } ,  afterSubmitKeyboardAction: TextInputAction.done , obscureField: true),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context , state){

          if(state is UserAuthenticated){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
              builder: (context)=> TabsHolderScreen(index: 0,),
            ), (route) => false);
          }
          else if(state is AuthenticationFailed){
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
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
              builder: (context)=> LoginScreen(),
            ), (route) => false);
          }



        },
        bloc: authenticationBloc,
      ),
    );
  }
}

