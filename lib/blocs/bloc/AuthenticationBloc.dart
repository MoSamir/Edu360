
import 'package:bloc/bloc.dart';
import 'package:edu360/blocs/events/AuthenticationEvents.dart';
import 'package:edu360/blocs/states/AuthenticationStates.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
import 'package:edu360/utilities/Constants.dart';
import 'package:edu360/Repository.dart';
class AuthenticationBloc extends Bloc<AuthenticationEvents , AuthenticationStates>{

  UserViewModel currentUser = UserViewModel.fromAnonymousUser();

  @override
  AuthenticationStates get initialState => AuthenticationInitiated();

  @override
  Stream<AuthenticationStates> mapEventToState(AuthenticationEvents event) async*{
    bool isUserConnected = await NetworkUtilities.isConnected();
    if(isUserConnected == false){
      yield AuthenticationFailed(
        failedEvent: event,
        error: Constants.CONNECTION_TIMEOUT,
      );
      return ;
    }
    if(event is AuthenticateUser){
      yield* _checkIfUserLoggedIn();
      return;
    }
    else if(event is LoginUser){
      yield* _loginUser(event.userEmail.trim() , event.userPassword.trim() , event);
      return ;
    }
    else if(event is Logout){
      yield* _logoutUser(event);
      return;
    }
    else if(event is UpdateUserInformation){
     yield* _reloadUser(event);
     return ;
    }
    else if(event is ForgetPassword){
      yield* _handleForgetPasswordFirstStep(event);
      return ;
    }
    else if(event is ResetPassword){
      yield* _handlePasswordReset(event);
      return ;
    }
  }

  Stream<AuthenticationStates> _checkIfUserLoggedIn() async*{

    yield AuthenticationLoading();
    await Future.delayed(Duration(seconds: 3),()=>{});
    UserViewModel loggedInUser = await Repository.getUser();
    currentUser = loggedInUser;
    if(currentUser.isAnonymous()){
      yield UserNotInitialized();
      return ;
    } else {
      yield UserAuthenticated(currentUser: loggedInUser);
      return ;
    }
  }

  Stream<AuthenticationStates> _loginUser(String userMail, String userPassword , event) async*{
    yield AuthenticationLoading();
    ResponseViewModel<UserViewModel> apiResponse = await Repository.login(userMail:userMail , userPassword:userPassword);
    if(apiResponse.isSuccess){
      await Repository.saveUser(apiResponse.responseData);
      await Repository.saveEncryptedPassword(userPassword);
      currentUser = apiResponse.responseData ;
      yield UserAuthenticated(currentUser: apiResponse.responseData);
      return;
    } else {
      yield AuthenticationFailed(error: apiResponse.errorViewModel , failedEvent: event);
      return;
    }
  }
  Stream<AuthenticationStates> _logoutUser(event) async*{

   ResponseViewModel responseViewModel = await Repository.logout( userId: currentUser.userId.toString());
   if(responseViewModel.isSuccess || responseViewModel.errorViewModel.errorCode == 401){
     currentUser = UserViewModel.fromAnonymousUser();
     await Repository.clearCache();
     yield UserAuthenticated(
         currentUser: UserViewModel.fromAnonymousUser());
   } else {
     yield AuthenticationFailed(failedEvent: event , error: responseViewModel.errorViewModel);
   }
  }

  Stream<AuthenticationStates> _reloadUser(UpdateUserInformation event) async*{
    yield AuthenticationLoading();
    ResponseViewModel<UserViewModel> apiResponse = await Repository.refreshUser();
    if(apiResponse.isSuccess){
      await Repository.saveUser(apiResponse.responseData);
      currentUser = apiResponse.responseData ;
      yield UserAuthenticated(currentUser: apiResponse.responseData);
      return;
    } else {
      yield AuthenticationFailed(error: apiResponse.errorViewModel , failedEvent: event);
      return;
    }
  }

  Stream<AuthenticationStates> _handleForgetPasswordFirstStep(ForgetPassword event) async*{

    yield AuthenticationLoading();
    ResponseViewModel<bool> apiResponse = await Repository.forgetPassword(userMail: event.userEmail);
    if(apiResponse.isSuccess){
      yield UserForgottenPasswordState(userMail : event.userEmail);
      return;
    } else {
      yield AuthenticationFailed(error: apiResponse.errorViewModel , failedEvent: event);
      return;
    }

  }

  Stream<AuthenticationStates> _handlePasswordReset(ResetPassword event) async*{
    yield AuthenticationLoading();
    ResponseViewModel<bool> apiResponse = await Repository.resetPassword(userMail: event.userEmail , userPassCode : event.userPassCode , newPassword : event.userNewPassword);
    if(apiResponse.isSuccess){
      this.add(LoginUser(userPassword: event.userNewPassword , userEmail: event.userEmail));
      return;
    } else {
      yield AuthenticationFailed(error: apiResponse.errorViewModel , failedEvent: event);
      return;
    }

  }




}

