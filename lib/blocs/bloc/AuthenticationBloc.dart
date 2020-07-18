
import 'package:bloc/bloc.dart';
import 'package:edu360/blocs/events/AuthenticationEvents.dart';
import 'package:edu360/blocs/states/AuthenticationStates.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'file:///E:/Testing/edu360/lib/data/apis/helpers/NetworkUtilities.dart';
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
  }

  Stream<AuthenticationStates> _checkIfUserLoggedIn() async*{

    yield AuthenticationLoading();
    await Future.delayed(Duration(seconds: 3),()=>{});
    UserViewModel loggedInUser = await Repository.getUser();
    currentUser = loggedInUser;
    if(currentUser.userId == null || currentUser.userId.toString().length == 0){
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
      yield UserAuthenticated(
          currentUser: apiResponse.responseData);
      return;
    } else {
      yield AuthenticationFailed(error: apiResponse.errorViewModel , failedEvent: event);
      return;
    }
  }

  Stream<AuthenticationStates> _logoutUser(event) async*{

   ResponseViewModel responseViewModel = await Repository.logout( userId: currentUser.userId.toString());
   if(responseViewModel.isSuccess){
     currentUser = UserViewModel.fromAnonymousUser();
     await Repository.clearCache();
     yield UserAuthenticated(
         currentUser: UserViewModel.fromAnonymousUser());
   } else {
     yield AuthenticationFailed(failedEvent: event , error: responseViewModel.errorViewModel);
   }
  }
}

