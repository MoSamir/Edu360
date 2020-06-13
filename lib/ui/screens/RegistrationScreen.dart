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
class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  GlobalKey<FormState> _formGlobalKey ;
  TextEditingController _usernameController , _passwordController , _confirmPasswordController ;
  FocusNode  _usernameNode, _passwordNode , _passwordConfirmationNode ;
  List<File> uploadedDocuments  = List();
  RegistrationBloc _registrationBloc = RegistrationBloc();


  @override
  void initState() {
    initControllers();
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
        listener: (context, state){},
        bloc: _registrationBloc,
        builder: (context , state){
          return Container(
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
                    SizedBox(height: MediaQuery.of(context).size.height * .15, child: Center(child: Text(LocalKeys.REGISTRATION_MESSAGE, textAlign:TextAlign.center , style: Styles.baseTextStyle,).tr(),),),
                    getFormField(placeHolder: (LocalKeys.EMAIL_OR_PHONE).tr() , fieldController: _usernameController
                        , focusNode: _usernameNode , nextFocusNode: _passwordNode ,
                        trailingWidget: GestureDetector(
                            onTap: _openEmailHintDialog
                            ,child: Container(width: 25, height: 25, child: Center(child: Text('?'),),  decoration: BoxDecoration(shape: BoxShape.circle , color: AppColors.canaryColor),)),
                        validatorFn: Validator.mailOrPhoneValidator ,  afterSubmitKeyboardAction: TextInputAction.next , obscureField: false),
                    SizedBox(height: 10,),
                    getFormField(placeHolder: (LocalKeys.PASSWORD).tr() , fieldController: _passwordController
                        , focusNode: _passwordNode , nextFocusNode: _passwordConfirmationNode ,
                        validatorFn: Validator.requiredField ,  afterSubmitKeyboardAction: TextInputAction.next , obscureField: true),
                    SizedBox(height: 10,),
                    getFormField(placeHolder: (LocalKeys.CONFIRM_PASSWORD).tr() , fieldController: _confirmPasswordController
                        , focusNode: _passwordConfirmationNode , autoValidate: true,
                        validatorFn: (passwordConfirmation){
                          return passwordConfirmation == _passwordController.text ? null : (LocalKeys.CONFIRM_PASSWORD_ERROR).tr();
                        } ,  afterSubmitKeyboardAction: TextInputAction.done , obscureField: true),
                    getFilesList(),
                    SizedBox(height: 50,),
                    RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 14,horizontal: 8),
                      onPressed: (){},
                      elevation: 5,
                      color: AppColors.white,
                      child: Text(LocalKeys.SIGN_UP , style: Styles.baseTextStyle.copyWith(
                        color: AppColors.mainThemeColor,
                      ),).tr(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget getFormField({String placeHolder , TextEditingController fieldController , FocusNode focusNode , bool obscureField, bool autoValidate,
                      FocusNode nextFocusNode , Function validatorFn, TextInputAction afterSubmitKeyboardAction , Widget trailingWidget }){

    return TextFormField(
      controller: fieldController ,
      focusNode: focusNode ,
      obscureText:  obscureField ?? false,
      onEditingComplete: (){
        if(nextFocusNode != null){
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
      },
      textInputAction: afterSubmitKeyboardAction ?? TextInputAction.done,
      validator: validatorFn ?? (text)=> null,
      autovalidate: autoValidate ?? false,
      decoration: InputDecoration(
        suffix: trailingWidget ?? Container(height: 0, width: 0,),
        filled: true,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        fillColor: AppColors.white,
        hintText: placeHolder ?? '',
        hintStyle: Styles.baseTextStyle.copyWith(
          color: AppColors.registrationTextPlaceholderColor,
        ),
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
                Text((LocalKeys.YOU_HAVE_TO_VERIFY) , style: Styles.baseTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),).tr(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16 , horizontal: 6),
                  child: Text(LocalKeys.WHAT_YOU_HAVE_TO_VERIFY , textAlign: TextAlign.center , style: Styles.baseTextStyle.copyWith(
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
    filesWidget.add(Material(
        type: MaterialType.card,
        elevation: 2,
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(Icons.add , color: Colors.black,),
            iconSize: 30,
            color: AppColors.white,
            onPressed: () async{
              List<File> selectedImage = await FilePicker.getMultiFile(
                type: FileType.custom,
                allowedExtensions: ['pdf', 'doc'],
              );
              try {
                uploadedDocuments.addAll(selectedImage);
              }catch(exception){}
              setState(() {});
            },
          ),
        ),
      ));



    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(children: filesWidget,spacing: 10,),
    );
  }
  getPdfView(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.red,
      ),

      child: Center(child: Text('PDF' , style: Styles.baseTextStyle,),),
    );
  }
  getDocView(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue,
      ),

      child: Center(child: Text('DOC',style: Styles.baseTextStyle,),),
    );
  }

}


