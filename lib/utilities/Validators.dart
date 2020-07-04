import 'package:edu360/utilities/LocalKeys.dart';
import 'package:easy_localization/easy_localization.dart';
class Validator{

static String mailOrPhoneValidator(String inputString){
    String isEmptyCheck = requiredField(inputString);
    if(isEmptyCheck != null){
      return isEmptyCheck;
    }
    String isValidPhone = phoneValidator(inputString);
    String isValidMail = mailValidator(inputString);
    return (isValidMail == null || isValidPhone == null)
        ? null : (LocalKeys.INVALID_MAIL_OR_PHONE).tr();
  }
static String phoneValidator(String phoneNumber){

  String isEmptyCheck = requiredField(phoneNumber);
  if(isEmptyCheck != null){
    return isEmptyCheck;
  }
    String preFix = phoneNumber.substring(0,3);
    int phoneNumberLength = phoneNumber.length ;
    bool validPreFix = preFix == '011' || preFix == '010' || preFix == '012' || preFix == '015';
    bool validPhoneLength = phoneNumberLength == 11;
    return (validPreFix && validPhoneLength) ? null : (LocalKeys.INVALID_PHONE).tr();
}
static String requiredField(String text){
  return (text == null || text.trim().length == 0) ?  (LocalKeys.REQUIRED_FIELD).tr() : null ;
}
static String mailValidator(String text){
    String isEmptyCheck = requiredField(text);
    if(isEmptyCheck != null){
      return isEmptyCheck;
    }

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(text) ? null : (LocalKeys.INVALID_MAIL).tr();

  }

}