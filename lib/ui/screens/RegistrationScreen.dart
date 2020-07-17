import 'package:edu360/blocs/events/RegistrationEvents.dart';
import 'package:edu360/blocs/states/RegistrationStates.dart';
import 'package:edu360/data/models/StudyFieldViewModel.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/ui/widgets/EduFormField.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:edu360/utilities/Resources.dart';
import 'package:edu360/utilities/Validators.dart';
import 'package:file_picker/file_picker.dart';
import 'package:edu360/blocs/bloc/RegistrationBloc.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'CompleteYourProfileScreen.dart';
class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  GlobalKey<FormState> _formGlobalKey = GlobalKey<FormState>();
  TextEditingController _usernameController , _passwordController , _confirmPasswordController ;
  FocusNode  _usernameNode, _passwordNode , _passwordConfirmationNode ;
  List<File> uploadedDocuments  = List();
  RegistrationBloc _registrationBloc = RegistrationBloc();
  UserViewModel user = UserViewModel();

  @override
  void initState() {
    initControllers();
    _registrationBloc.add(LoadFieldsOfStudy());
    super.initState();
  }

  void initControllers() {
    _formGlobalKey = GlobalKey<FormState>();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _usernameNode = FocusNode();
    _passwordNode = FocusNode();
    _passwordConfirmationNode = FocusNode();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer(
        listener: (context, state){
          if(state is RegistrationPageInitiated){
            if(user.userFieldOfStudy == null){
              user.userFieldOfStudy = _registrationBloc.userStudyFields[0] ?? null;
            }
          }
        },
        bloc: _registrationBloc,
        builder: (context , state){
          return ModalProgressHUD(
            inAsyncCall: state is RegistrationPageLoading,
            child: Container(
              color: AppColors.mainThemeColor,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 100, left: 30 , right: 30) ,
              child: SingleChildScrollView(
                child: Form(
                  key: _formGlobalKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Image.asset(Resources.WHITE_LOGO_IMAGE , height: 50,),
                      SizedBox(height: 20,),
                      SizedBox(height: MediaQuery.of(context).size.height * .15, child: Center(child: Text(LocalKeys.REGISTRATION_MESSAGE, textScaleFactor: 1, textAlign:TextAlign.center , style: Styles.baseTextStyle,).tr(),),),
                      EduFormField(placeHolder: (LocalKeys.EMAIL).tr() , fieldController: _usernameController
                          , focusNode: _usernameNode , nextFocusNode: _passwordNode ,
                          trailingWidget: GestureDetector(
                              onTap: _openEmailHintDialog
                              ,child: Container(width: 25, height: 25, child: Center(child: Text('?',textScaleFactor: 1),),  decoration: BoxDecoration(shape: BoxShape.circle , color: AppColors.canaryColor),)),
                          validatorFn: Validator.mailValidator ,  afterSubmitKeyboardAction: TextInputAction.next , obscureField: false),
                      SizedBox(height: 10,),
                      EduFormField(placeHolder: (LocalKeys.PASSWORD).tr() , fieldController: _passwordController
                          , focusNode: _passwordNode , nextFocusNode: _passwordConfirmationNode ,
                          validatorFn: Validator.requiredField ,  afterSubmitKeyboardAction: TextInputAction.next , obscureField: true),
                      SizedBox(height: 10,),
                      EduFormField(placeHolder: (LocalKeys.CONFIRM_PASSWORD).tr() , fieldController: _confirmPasswordController
                          , focusNode: _passwordConfirmationNode , autoValidate: true,
                          validatorFn: (passwordConfirmation){
                            return passwordConfirmation == _passwordController.text ? null : (LocalKeys.CONFIRM_PASSWORD_ERROR).tr();
                          } ,  afterSubmitKeyboardAction: TextInputAction.done , obscureField: true),
                      SizedBox(height: 10,),
                      getFieldsOfStudySpinner(),
                      SizedBox(height: 10,),
                      getFilesList(),
                      SizedBox(height: 30,),
                      GestureDetector(
                        onTap: (){
                          if(_formGlobalKey.currentState.validate() && uploadedDocuments!=null && uploadedDocuments.length > 0) {
                            print("${user.userFieldOfStudy}");
                            user = UserViewModel(
                              userFieldOfStudy: user.userFieldOfStudy,
                              userEmail: _usernameController.text,
                              userPassword: _passwordController.text,
                            );
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) =>
                                    BlocProvider.value(
                                      value: _registrationBloc,
                                      child: CompleteYourProfileScreen(
                                        user: user,
                                        userDocuments: uploadedDocuments,),

                                    )));
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(LocalKeys.SIGN_UP , textScaleFactor: 1 ,style: Styles.baseTextStyle.copyWith(
                              color: AppColors.mainThemeColor,
                            ),).tr(),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openEmailHintDialog() {
    showDialog(context: context ,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
          elevation: 2,
          backgroundColor:AppColors.canaryColor,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          contentPadding: EdgeInsets.all(0),
          content: Container(
            height: 200,
            width: MediaQuery.of(context).size.width * .8,

            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text((LocalKeys.YOU_HAVE_TO_VERIFY) , textScaleFactor: 1,style: Styles.baseTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),).tr(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16 , horizontal: 6),
                  child: Text(LocalKeys.WHAT_YOU_HAVE_TO_VERIFY , textScaleFactor: 1,textAlign: TextAlign.center , style: Styles.baseTextStyle.copyWith(
                    fontSize: 14,
                  ),).tr(),
                ),
              ],
            ),
          ),),
    );
  }
  Widget getFilesList() {
    List<Widget> filesWidget = List();
    for(int i = 0 ; i < uploadedDocuments.length;i++){
      String ext = uploadedDocuments[i].path.substring(uploadedDocuments[i].path.lastIndexOf('.')+1);

      filesWidget.add(
          Material(
        type: MaterialType.card,
        elevation: 2,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: ext == 'pdf' ? getPdfView() : getDocView(),
        ),
      ));
    }

    if(uploadedDocuments.length == 0){
      filesWidget.add(Text(LocalKeys.PLEASE_UPLOAD_DOCUMENTS ,textScaleFactor: 1, style: Styles.baseTextStyle,).tr());
    }
    filesWidget.add(Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: GestureDetector(
        onTap: () async{
          try{
            FilePicker.getMultiFile(
              type: FileType.custom, allowedExtensions: ['pdf', 'doc'],).then((value){
            if(value!= null){
                uploadedDocuments.addAll(value);
                setState(() {});
              }
            });
          } catch(exception){
            print("Exception while picking file => $exception");
          }
        },
        child: Container(
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
    ),
      child: Center(child: Icon(Icons.add , color: Colors.black,),),
    ),
      ),
    ));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Wrap(children: filesWidget,spacing: 10,),
    );
  }
  getPdfView(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.red,
      ),

      child: Center(child: Text('PDF' , textScaleFactor: 1,style: Styles.baseTextStyle,),),
    );
  }
  getDocView(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue,
      ),
      child: Center(child: Text('DOC',textScaleFactor: 1,style: Styles.baseTextStyle,),),
    );
  }

  getFieldsOfStudySpinner() {

    return SizedBox(
//      height: 50,
      child: DropdownButtonFormField(
          validator: (StudyFieldViewModel studyField){
            return user.userFieldOfStudy != null ? null : (LocalKeys.REQUIRED_FIELD).tr();
          },
          isDense: true,
          hint: Text((LocalKeys.FIELD_OF_STUDY)).tr(),
          decoration: InputDecoration(
            filled: true,
            enabledBorder: OutlineInputBorder(
              gapPadding: 0,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            fillColor: AppColors.white,
            border: InputBorder.none,
          ),
          value: user.userFieldOfStudy,
          onChanged: (StudyFieldViewModel studyFieldViewModel) {
            print("User Selected Field Of study");
            user.userFieldOfStudy = studyFieldViewModel;
            setState(() {});
          },
          items: _registrationBloc.userStudyFields != null
              ? _registrationBloc.userStudyFields.map<DropdownMenuItem<StudyFieldViewModel>>(
                (StudyFieldViewModel studyField) {
              return DropdownMenuItem<StudyFieldViewModel>(
                value: studyField,
                child: Text(
                  studyField.studyFieldNameEn,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1,
                ),
              );
            },
          ).toList() : List<DropdownMenuItem<StudyFieldViewModel>>()),
    );
  }
}