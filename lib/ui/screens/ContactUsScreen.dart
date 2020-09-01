import 'dart:io';

import 'package:edu360/blocs/bloc/AppDataBloc.dart';
import 'package:edu360/blocs/events/AppDataEvents.dart';
import 'package:edu360/blocs/states/AppDataStates.dart';
import 'package:edu360/data/models/IssueModel.dart';
import 'package:edu360/ui/screens/ComplainResultScreen.dart';
import 'package:edu360/ui/widgets/EduAppBar.dart';
import 'package:edu360/ui/widgets/EduButton.dart';
import 'package:edu360/ui/widgets/EduFormField.dart';
import 'package:edu360/ui/widgets/NetworkErrorView.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Validators.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  TextEditingController userMailController , userNameController , userPhoneNumberController ,
  issueTitleController , issueBodyController ;
  FocusNode userMailNode , userNameNode , userPhoneNumberNode , issueTitleNode , issueBodyNode;

  GlobalKey<FormState> issueFormKey = GlobalKey<FormState>();

   IssueModel userIssue ;
   AppDataBloc applicationBloc ;

  @override
  void initState() {
    super.initState();
    userMailController = TextEditingController();
    userNameController = TextEditingController();
    userPhoneNumberController = TextEditingController();
    issueTitleController = TextEditingController();
    issueBodyController = TextEditingController();

    userMailNode = FocusNode() ;
    userNameNode = FocusNode() ;
    userPhoneNumberNode = FocusNode();
    issueTitleNode = FocusNode();
    issueBodyNode = FocusNode();
    userIssue = IssueModel();
    applicationBloc = BlocProvider.of<AppDataBloc>(context);

    if(applicationBloc.userDataBloc.authenticationBloc.currentUser != null) {
      userIssue.issuerPhoneNumber = applicationBloc.userDataBloc.authenticationBloc.currentUser.userPassword ?? '';
      userIssue.issuerName = applicationBloc.userDataBloc.authenticationBloc.currentUser.userFullName ?? '';
      userIssue.issuerMail = applicationBloc.userDataBloc.authenticationBloc.currentUser.userEmail ?? '';
      userMailController.text = userIssue.issuerMail ?? '';
      userNameController.text = userIssue.issuerName ?? '';
      userPhoneNumberController.text = userIssue.issuerPhoneNumber ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EduAppBar(
        backgroundColor: AppColors.mainThemeColor,
        autoImplyLeading: false,
      centerTitle: true,
        title: (LocalKeys.CONTACT_US).tr(),
      ),
      persistentFooterButtons: <Widget>[
        EduButton(
          title: (LocalKeys.SEND_LABEL).tr(),
          bgColor: AppColors.mainThemeColor,
//          borderColor: AppColors.mainThemeColor,
          onPressed: (){
            if(issueFormKey.currentState.validate()){
              userIssue = IssueModel(
                issueBody: issueBodyController.text,
                issuerMail: userMailController.text,
                issuerName: userNameController.text,
                issuerPhoneNumber: userPhoneNumberController.text,
                issueTitle: issueTitleController.text,
              );
              applicationBloc.add(SubmitIssue(userIssue: userIssue));
            }
          },
        ),
      ],
      body: BlocConsumer(
        bloc: applicationBloc,
        builder: (context , state){
          return ModalProgressHUD(
            inAsyncCall: state is IssueCreationLoading,
            child: SingleChildScrollView(
              child: Form(
                key: issueFormKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10,),
                      EduFormField(placeHolder: (LocalKeys.USER_NAME).tr() , fieldController: userNameController
                          , focusNode: userNameNode , nextFocusNode: userMailNode , forceLTR: true ,
                          afterSubmitKeyboardAction: TextInputAction.next ,
                          validatorFn: Validator.requiredField,
                          obscureField: false),
                      SizedBox(height: 10,),
                      EduFormField(placeHolder: (LocalKeys.EMAIL).tr() , fieldController: userMailController
                          , focusNode: userMailNode , nextFocusNode: userPhoneNumberNode , forceLTR: true ,
                          afterSubmitKeyboardAction: TextInputAction.next ,
                          validatorFn: Validator.mailValidator,
                          obscureField: false),
                      SizedBox(height: 10,),
                      EduFormField(placeHolder: (LocalKeys.PHONE_NUMBER).tr() , fieldController: userPhoneNumberController
                          , focusNode: userPhoneNumberNode , nextFocusNode: issueTitleNode , forceLTR: true ,
                          validatorFn: Validator.phoneValidator,
                          afterSubmitKeyboardAction: TextInputAction.next , obscureField: false),
                      SizedBox(height: 10,),
                      EduFormField(placeHolder: (LocalKeys.ISSUE_TITLE).tr() , fieldController: issueTitleController
                          , focusNode: issueTitleNode , nextFocusNode: issueBodyNode , forceLTR: false ,
                          validatorFn: Validator.requiredField,
                          afterSubmitKeyboardAction: TextInputAction.next , obscureField: false),
                      SizedBox(height: 10,),
                      EduFormField(placeHolder: (LocalKeys.ISSUE_BODY).tr() , fieldController: issueBodyController
                          , focusNode: issueBodyNode ,  forceLTR: false , maxLines: 10,
                          validatorFn: Validator.requiredField,
                          afterSubmitKeyboardAction: TextInputAction.done , obscureField: false),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context , state){
          if(state is IssueCreationSuccess){
            // Navigate to proper screen ;

            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> ComplainResultScreen(successResult: true,)));
          }
          else if (state is IssueCreationFailed || state is AppDataLoadingFailed) {
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
        },
      ),






    );
  }
}
