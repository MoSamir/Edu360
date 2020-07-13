import 'package:edu360/Repository.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
import 'package:edu360/data/models/StudyFieldViewModel.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/utilities/Constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edu360/blocs/events/RegistrationEvents.dart';
import 'package:edu360/blocs/states/RegistrationStates.dart';
class RegistrationBloc extends Bloc<RegistrationEvents, RegistrationStates>{
  @override
  RegistrationStates get initialState => RegistrationPageLoading();
  UserViewModel tobeRegistered = UserViewModel();
  List<StudyFieldViewModel> userStudyFields = List();

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
    } else if (event is VerifyUserInformation){
      yield* _handleUserVerification(event);
      return;
    }
  }


  Stream<RegistrationStates> _handleUserRegistration(RegisterUserWithCredentials event) async*{
    yield RegistrationPageLoading();
    tobeRegistered = event.userViewModel ?? UserViewModel();
    ResponseViewModel<List<String>> uploadFilesResponse = await Repository.uploadFiles(event.userUploadedDocuments , event.profileImage);
    if(uploadFilesResponse.isSuccess){

      if(uploadFilesResponse.responseData != null && uploadFilesResponse.responseData.length > 0) {
        if (uploadFilesResponse.responseData[0].endsWith(".jpg") ||
            uploadFilesResponse.responseData[0].endsWith(".png") ||
            uploadFilesResponse.responseData[0].endsWith(".jpeg"))
        tobeRegistered.profileImagePath = uploadFilesResponse.responseData[0];

        uploadFilesResponse.responseData.removeAt(0);
        tobeRegistered.userFiles = uploadFilesResponse.responseData;
      }
    } else {
      yield RegistrationFailed(failedEvent: event,error: uploadFilesResponse.errorViewModel);
      return ;
    }
    ResponseViewModel<int> registerUserResponse = await Repository.registerUser(tobeRegistered , event.profileImage);

   if(registerUserResponse.isSuccess) {
     tobeRegistered.userId = registerUserResponse.responseData;
     yield RegistrationPendingVerification();
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
      yield RegistrationSuccess();
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
}