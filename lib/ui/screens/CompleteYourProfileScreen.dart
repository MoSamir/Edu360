import 'dart:io';
import 'dart:math';

import 'package:edu360/blocs/bloc/RegistrationBloc.dart';
import 'package:edu360/blocs/events/RegistrationEvents.dart';
import 'package:edu360/blocs/states/RegistrationStates.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/ui/screens/VerificationScreen.dart';
import 'package:edu360/ui/widgets/EduFormField.dart';
import 'package:edu360/ui/widgets/NetworkErrorView.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:edu360/utilities/Validators.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class CompleteYourProfileScreen extends StatefulWidget {

  final String fullNumber;
  final List<File> userDocuments;
  final UserViewModel user;
  CompleteYourProfileScreen({this.user, this.userDocuments , this.fullNumber});


  @override
  _CompleteYourProfileScreenState createState() => _CompleteYourProfileScreenState();
}

class _CompleteYourProfileScreenState extends State<CompleteYourProfileScreen> {

  /* , _educationController  , _educationFocusNode */

  TextEditingController _firstNameController , _lastNameController ,
  _birthDayController ;
  FocusNode _firstNameFocusNode , _lastNameFocusNode  , _birthDayFocusNode ;
  File userImage ;
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  UserViewModel user ;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    _bloc = BlocProvider.of<RegistrationBloc>(context);

    initControls();
  }
  void initControls() {


    _firstNameController = TextEditingController(text: "");
    _lastNameController = TextEditingController(text: "");
   // _educationController = TextEditingController(text: "");
    _birthDayController =TextEditingController();


    if(_bloc.tobeRegistered.userFullName != null && _bloc.tobeRegistered.userFullName.split(' ').length > 1 &&  _bloc.tobeRegistered.userFullName.contains(' ')){
      _firstNameController.text = _bloc.tobeRegistered.userFullName.split(' ')[0];
      _lastNameController.text = _bloc.tobeRegistered.userFullName.split(' ')[1];
    }
//    if(_bloc.tobeRegistered.userEducation != null){
//      _educationController.text = _bloc.tobeRegistered.userEducation;
//    }
    if(_bloc.tobeRegistered.userBirthDay != null){
      DateTime picked = _bloc.tobeRegistered.userBirthDay;
      _birthDayController.text = "${picked.day}/${picked.month}/${picked.year}";

    }

    _firstNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();
    //_educationFocusNode = FocusNode();
    _birthDayFocusNode = FocusNode();

  }

  RegistrationBloc _bloc ;
  @override
  Widget build(BuildContext context) {

    _bloc = BlocProvider.of<RegistrationBloc>(context);
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        extendBody: false,
        resizeToAvoidBottomPadding: true,
        backgroundColor: AppColors.backgroundColor,
        body: BlocConsumer(
          listener: (context , state){
            if(state is WaitingPhoneAuthenticationComplete){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> BlocProvider.value(value: _bloc , child: VerificationScreen(),)));
            }
            else if (state is RegistrationFailed) {
              if (state.error.errorCode == HttpStatus.requestTimeout || state.error.errorCode == HttpStatus.badGateway) {
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
          },
          builder: (context , state){
            return ModalProgressHUD(
              inAsyncCall: state is RegistrationPageLoading,
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8 , vertical: 20),
                    child: Form(
                      key: _globalKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(height: MediaQuery.of(context).size.height * .12,),
                          Image.asset(Resources.BLUE_LOGO_IMAGE , width: 70, height: 70, fit: BoxFit.contain,),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            shadowColor: Colors.black38,
                            elevation: 5,
                            borderOnForeground: true,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0 , vertical: 20),
                              child: Column(
                                children: <Widget>[
                                  Text(LocalKeys.COMPLETE_YOUR_PROFILE, textScaleFactor: 1,).tr(),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                    onTap: getUserImage,
                                    child: Container(
                                      height: 100,
                                      child: Center(
                                        child: Stack(
                                          children: <Widget>[
                                            Center(child:   (userImage !=null)? Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1,
                                                  color: AppColors.mainThemeColor,
                                                  style: BorderStyle.solid,
                                                ),
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: FileImage(userImage),
                                                ),
                                              ),
                                            ) : Icon(Icons.account_circle , color: AppColors.mainThemeColor, size: 100,)),
                                            Padding(
                                              padding: const EdgeInsetsDirectional.only(end: 50 , bottom: 10),
                                              child: Align(alignment: AlignmentDirectional.bottomCenter, child: Icon(Icons.add_circle , size: 30, color: AppColors.backgroundColor,),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: <Widget>[
                                      Expanded(child: EduFormField(placeHolder: (LocalKeys.FIRST_NAME).tr() , fieldController: _firstNameController
                                          , focusNode: _firstNameFocusNode , nextFocusNode: _lastNameFocusNode ,
                                          validatorFn: Validator.requiredField ,  afterSubmitKeyboardAction: TextInputAction.next , obscureField: false)),
                                      SizedBox(width: 10,),
                                      Expanded(child: EduFormField(placeHolder: (LocalKeys.LAST_NAME).tr() , fieldController: _lastNameController
                                          , focusNode: _lastNameFocusNode , nextFocusNode: _birthDayFocusNode ,
                                          validatorFn: Validator.requiredField ,  afterSubmitKeyboardAction: TextInputAction.next , obscureField: false)),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                    onTap: ()async{

                                      await _openCalendar(context);
                                    },
                                    child: Container(
                                      color: AppColors.transparent,
                                      child: IgnorePointer(
                                        child: EduFormField(placeHolder: (LocalKeys.BIRTHDAY).tr() , fieldController: _birthDayController
                                            , focusNode: _birthDayFocusNode ,  //nextFocusNode: _educationFocusNode ,
                                            validatorFn: Validator.requiredField ,  afterSubmitKeyboardAction: TextInputAction.next , obscureField: false),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
//                                EduFormField(placeHolder: (LocalKeys.EDUCATION).tr() , fieldController: _educationController
//                                    , focusNode: _educationFocusNode ,
//                                    validatorFn: Validator.requiredField ,  afterSubmitKeyboardAction: TextInputAction.done , obscureField: false),
                                  SizedBox(height: 10,),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          GestureDetector(
                            onTap: () {
                              UserViewModel tobeRegistered = UserViewModel(
                                  userFieldOfStudy: widget.user.userFieldOfStudy,
                                  userAge: 25,//(DateTime.now().difference(user.userBirthDay).inDays / 365).floor(),
                                  userBirthDay: user.userBirthDay,
                                  userEducation:  '', //_educationController.text ,
                                  userEmail: user.userEmail,
                                  userFullName: '${_firstNameController.text} ${_lastNameController.text}',
                                  userPassword: user.userPassword,
                                  userMobileNumber: user.userMobileNumber
                              );

                              _bloc.tobeRegistered = tobeRegistered;

                              print("isValid ${tobeRegistered.isValid()}");

                              if(_globalKey.currentState.validate() && tobeRegistered.isValid()){


                                _bloc.add(RequestPhoneVerification(phoneNo: widget.fullNumber));
                              }
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(LocalKeys.SIGN_UP, textScaleFactor: 1 , style: Styles.baseTextStyle.copyWith(
                                  color: AppColors.mainThemeColor,
                                ),).tr(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          bloc: _bloc,
        ),
      ),
    );
  }


  getUserImage()async{
    try {
      userImage = await FilePicker.getFile(
        type: FileType.image,
      );
      setState(() {});
    } catch(exception){}
  }

  _openCalendar(context) async{
      DateTime picked = DateTime.now();

     if(Platform.isAndroid){
       picked = await showDatePicker(
         context: context,
         locale: EasyLocalization.of(context).locale,
         initialEntryMode: DatePickerEntryMode.calendar,
         builder: (BuildContext context, Widget child) {
           return child;
         },
         initialDate: DateTime(DateTime.now().year-1 , 1),
         firstDate: DateTime(DateTime.now().year-100, 1),
         lastDate: DateTime(DateTime.now().year-1 , 1) ,
       );
     } else if(Platform.isIOS){
       picked = await showModalBottomSheet(context: context , builder: (context)=> SizedBox(
         height: 190,
         width: MediaQuery.of(context).size.width,
         child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: <Widget>[
             SizedBox(height: 8,),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 12.0),
               child: SizedBox(height: 25, child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                   FlatButton(
                     child: Text(LocalKeys.CONFIRM_LABEL).tr(),
                     onPressed: (){
                       Navigator.pop(context,picked);
                     },
                   ),
                   FlatButton(
                     child: Text(LocalKeys.CANCEL_LABEL).tr(),
                     onPressed: (){
                       Navigator.pop(context,null);
                     },
                   ),
                 ],
               ),),
             ),
             SizedBox(height: 5,),
             SizedBox(
               height: 150,
               child: CupertinoDatePicker(
                 initialDateTime: DateTime.now(),
                 minimumDate: DateTime.now().subtract(Duration(days: 365 * 100)),
                 maximumDate: DateTime.now(),
                 minuteInterval: 1,
                 mode: CupertinoDatePickerMode.date,
                 onDateTimeChanged: (DateTime dateTime) {
                   picked = dateTime;
                 },
               ),
             ),
           ],
         ),
       ));
     }
    if (picked != null && picked != DateTime.now() && picked.isBefore(DateTime.now())){
      _birthDayController.text = "${picked.day}/${picked.month}/${picked.year}";
      user.userBirthDay = picked;
    //FocusScope.of(context).requestFocus(_educationFocusNode);
      setState((){});
    }
  }
}



