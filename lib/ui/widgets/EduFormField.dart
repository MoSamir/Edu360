import 'package:edu360/utilities/AppStyles.dart';
import 'package:flutter/material.dart';

class EduFormField extends StatefulWidget {


  final String placeHolder ;
  final TextEditingController fieldController ;
  final FocusNode focusNode , nextFocusNode;
  final bool obscureField , autoValidate , filled , forceLTR;
  final Function validatorFn;
  final TextInputAction afterSubmitKeyboardAction;
  final Widget trailingWidget , leadingWidget;




  @override
  _EduFormFieldState createState() => _EduFormFieldState();

  EduFormField({
      this.filled,
      this.placeHolder,
      this.fieldController,
      this.focusNode,
      this.nextFocusNode,
      this.obscureField,
      this.autoValidate,
      this.validatorFn,
      this.afterSubmitKeyboardAction,
      this.trailingWidget,
      this.leadingWidget,
      this.forceLTR});
}

class _EduFormFieldState extends State<EduFormField> {

  String placeHolder ;
  TextEditingController fieldController ;
  FocusNode focusNode , nextFocusNode;
  bool obscureField , autoValidate , filled , forceLTR;
  Function validatorFn;
  TextInputAction afterSubmitKeyboardAction;
   Widget trailingWidget , leadingWidget;


  @override
  void initState() {
    super.initState();
    filled = widget.filled;
    placeHolder = widget.placeHolder;
    fieldController = widget.fieldController;
    focusNode = widget.focusNode;
    nextFocusNode = widget.nextFocusNode ;
    obscureField = widget.obscureField;
    autoValidate = widget.autoValidate;
    validatorFn = widget.validatorFn;
    afterSubmitKeyboardAction = widget.afterSubmitKeyboardAction;
    trailingWidget = widget.trailingWidget;
    leadingWidget = widget.leadingWidget;
    forceLTR = widget.forceLTR;
  }


  @override
  Widget build(BuildContext context) {
    return getFormField(
      filled: filled,
      forceLTR: forceLTR,
      afterSubmitKeyboardAction: afterSubmitKeyboardAction,
      autoValidate: autoValidate,
      fieldController: fieldController,
      focusNode: focusNode,
      nextFocusNode: nextFocusNode,
      obscureField: obscureField,
      placeHolder: placeHolder,
      trailingWidget: trailingWidget,
      leadingWidget : leadingWidget,
      validatorFn: validatorFn,
    );
  }



  Widget getFormField({String placeHolder , TextEditingController fieldController , FocusNode focusNode , bool obscureField, bool autoValidate,
    FocusNode nextFocusNode , Function validatorFn, TextInputAction afterSubmitKeyboardAction , Widget trailingWidget  , Widget leadingWidget , bool filled, bool forceLTR}){

    if(forceLTR ?? false)
      return TextFormField(
      textAlign: TextAlign.start,
      controller: fieldController ,
      focusNode: focusNode ,
      textDirection: TextDirection.ltr,
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
        prefix: leadingWidget ?? Container(height: 0, width: 0,),
        filled: filled ?? true,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        fillColor: AppColors.white,
        hintText: placeHolder ?? '',
        alignLabelWithHint: true,
        hintStyle: Styles.baseTextStyle.copyWith(
          color: AppColors.registrationTextPlaceholderColor,
        ),
      ),
    );
    else
      return TextFormField(
        textAlign: TextAlign.start,
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
          prefix: leadingWidget ?? Container(height: 0, width: 0,),
          filled: filled ?? true,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          fillColor: AppColors.white,
          hintText: placeHolder ?? '',
          alignLabelWithHint: true,
          hintStyle: Styles.baseTextStyle.copyWith(
            color: AppColors.registrationTextPlaceholderColor,
          ),
        ),
      );
  }



}

