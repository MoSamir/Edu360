import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:edu360/Repository.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/models/ErrorViewModel.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
import 'package:edu360/data/models/StudyFieldViewModel.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/utilities/Constants.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edu360/blocs/events/RegistrationEvents.dart';
import 'package:edu360/blocs/states/RegistrationStates.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationBloc extends Bloc<RegistrationEvents, RegistrationStates>{
  @override
  RegistrationStates get initialState => RegistrationPageLoading();
  UserViewModel tobeRegistered = UserViewModel();
  File userImage ;
  List<File> userUploadedDocuments ;
  List<StudyFieldViewModel> userStudyFields = List();
  String authenticationCode ;

  @override
  Stream<RegistrationStates> mapEventToState(RegistrationEvents event) async*{

    bool isUserConnected = await NetworkUtilities.isConnected();

    if(isUserConnected == false){
      yield RegistrationFailed(
        failedEvent: event,
        error: Constants.CONNECTION_TIMEOUT,
      );
      return ;
    }

    if(event is LoadFieldsOfStudy){
      yield* _handleFieldsOfStudyLoading(event);
      return ;
    }
    if(event is RegisterUserWithCredentials){
      yield* _handleUserRegistration(event);
      return ;
    }
    else if (event is VerifyUserInformation){
      yield* _handleUserVerification(event);
      return;
    }
    else if(event is RequestPhoneVerification){
      yield* _handleUserAuthentication(event);
      return ;
    }
    else if(event is VerifyUserPhoneNumber){
      yield* _handlePhoneNumberAuthentication(event);
      return;
    } else if(event is MoveToState){
      yield event.targetState;
      return ;
    }
  }


  Stream<RegistrationStates> _handleUserRegistration(RegisterUserWithCredentials event) async*{
    yield RegistrationPageLoading();
    tobeRegistered = event.userViewModel ?? UserViewModel();
    ResponseViewModel<List<String>> uploadFilesResponse = await Repository.uploadFiles(event.userUploadedDocuments , event.profileImage);
    if(uploadFilesResponse.isSuccess){

      if(uploadFilesResponse.responseData != null && uploadFilesResponse.responseData.length > 0)
      for(int i = 0 ; i < uploadFilesResponse.responseData.length ; i++) {
        print(uploadFilesResponse.responseData[i].contains(".jpg"));
        print(uploadFilesResponse.responseData.length);
        if (uploadFilesResponse.responseData[i].contains(".jpg") ||
            uploadFilesResponse.responseData[i].contains(".png") ||
            uploadFilesResponse.responseData[i].contains(".jpeg")) {
          tobeRegistered.profileImagePath = uploadFilesResponse.responseData[i];
        }
      }
        uploadFilesResponse.responseData.remove(tobeRegistered.profileImagePath);
        tobeRegistered.userFiles = uploadFilesResponse.responseData;
    } else {
      yield RegistrationFailed(failedEvent: event,error: uploadFilesResponse.errorViewModel);
      return ;
    }

    print("Hello Now I'm registering You ");
    ResponseViewModel<int> registerUserResponse = await Repository.registerUser(tobeRegistered , event.profileImage);

   if(registerUserResponse.isSuccess) {
     tobeRegistered.userId = registerUserResponse.responseData;
     yield RegistrationSuccess(tobeRegistered.userEmail , tobeRegistered.userPassword);
     return ;
   }
   else {
     yield RegistrationFailed(failedEvent: event, error: registerUserResponse.errorViewModel);
     return ;
   }
  }
  Stream<RegistrationStates> _handleUserVerification(VerifyUserInformation event) async*{
    yield RegistrationPageLoading();
    ResponseViewModel<void> verifyUserResponse = await Repository.verifyUser(userID: tobeRegistered.userId.toString() , userVerificationCode: event.verificationCode);
    if(verifyUserResponse.isSuccess){
      yield RegistrationSuccess(tobeRegistered.userEmail , tobeRegistered.userPassword);
      return ;
    } else {
      yield RegistrationFailed(failedEvent: event,error: verifyUserResponse.errorViewModel);
      return ;
    }
  }
  Stream<RegistrationStates> _handleFieldsOfStudyLoading(LoadFieldsOfStudy event) async*{
    ResponseViewModel<List<StudyFieldViewModel>> fieldsOfStudyList = await Repository.getFieldsOfStudy();
    if(fieldsOfStudyList.isSuccess){
      userStudyFields = fieldsOfStudyList.responseData;
      yield RegistrationPageInitiated();
      return ;
    } else {
      yield RegistrationFailed(failedEvent: event,error: fieldsOfStudyList.errorViewModel);
      return ;
    }
  }
  Stream<RegistrationStates> _handleUserAuthentication(RequestPhoneVerification event) async*{
    yield RegistrationPageLoading();
    await Repository.requestPhoneAuthentication(phoneNumber: '${event.phoneNo}' , onTimeout: onTimeout , onAuthCompleted: onAuthComplete , onAuthFail: onAuthFailure , onCodeSent: onCodeSent);
    return;
  }
  Stream<RegistrationStates> _handlePhoneNumberAuthentication(VerifyUserPhoneNumber event) async*{
    ResponseViewModel<bool> verificationResult = await Repository.verifyPhoneCode(code : event.phoneCode , authId: authenticationCode);
    if(verificationResult.isSuccess){
      this.add(RegisterUserWithCredentials(profileImage: userImage , userUploadedDocuments: userUploadedDocuments ?? List() , userViewModel: tobeRegistered));
      return ;
    } else {
      yield RegistrationFailed(
        error: verificationResult.errorViewModel,
        failedEvent: event,
      );
    }
  }


  //-------------------------- Authentication Callbacks ----------------------------------


  void onAuthFailure(FirebaseAuthException authError) {


    String errorMessage ;

    if(authError.code.contains('invalid-verification-code')){
      errorMessage = (LocalKeys.INVALID_AUTH_CODE).tr();
    }
    else if(authError.code.contains('too-many-requests')){
      errorMessage = (LocalKeys.PHONE_NUMBER_IS_BLOCKED).tr();
    }
    else {
      errorMessage = (LocalKeys.INVALID_PHONE_NUMBER).tr();
    }



    add(MoveToState(targetState : RegistrationFailed(error : ErrorViewModel(
      errorCode: 503,
      errorMessage: errorMessage ?? authError.code,
    ))));
  }
  void onAuthComplete(AuthCredential authCredentials){
    print("On Auth Completed");
    this.add(RegisterUserWithCredentials(profileImage: userImage , userUploadedDocuments: userUploadedDocuments ?? List(), userViewModel: tobeRegistered));
    return ;
  }
  void onTimeout(String authId){
    authenticationCode = authId;
    return ;
  }
  void onCodeSent(String authId){
    print("On Code Sent");
    authenticationCode = authId;
    add(MoveToState(targetState: WaitingPhoneAuthenticationComplete()));
    return;
  }




}