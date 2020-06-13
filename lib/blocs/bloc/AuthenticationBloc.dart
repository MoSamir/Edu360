
import 'package:bloc/bloc.dart';
import 'package:edu360/blocs/events/AuthenticationEvents.dart';
import 'package:edu360/blocs/states/AuthenticationStates.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/utilities/NetworkUtilities.dart';
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

    yield AuthenticationLoading();
    if(event is AuthenticateUser){
      yield* _checkIfUserLoggedIn();
      return;
    } else if(event is LoginUser){
      yield* _loginUser(event.userPhoneNumber.trim() , event.userPassword.trim() , event);
      return ;
    } else if(event is Logout){
      yield* _logoutUser(event);
      return;
    }
  }

  Stream<AuthenticationStates> _checkIfUserLoggedIn() async*{
    // try retrieve the user from the shared preference to check if user exist or no

    UserViewModel loggedInUser = await Repository.getUser();
    currentUser = loggedInUser;
    // the getter method handles if the user not exist it returns anonymous user so no need to double check it
    yield UserAuthenticated(currentUser: loggedInUser);
    return ;
  }

  Stream<AuthenticationStates> _loginUser(String userPhoneNumber, String userPassword , event) async*{
    ResponseViewModel apiResponse = await Repository.signIn(userPhoneNumber:userPhoneNumber , userPassword:userPassword);
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

   ResponseViewModel responseViewModel = await Repository.signOut();
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