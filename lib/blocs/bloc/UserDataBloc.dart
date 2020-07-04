import 'package:edu360/blocs/bloc/AuthenticationBloc.dart';
import 'package:edu360/blocs/bloc/UserProfileBloc.dart';
import 'package:edu360/blocs/events/UserDataEvents.dart';
import 'package:edu360/blocs/events/UserProfileEvents.dart';
import 'package:edu360/blocs/states/UserDataStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDataBloc extends Bloc<UserDataEvents , UserDataStates>{
  AuthenticationBloc authenticationBloc = AuthenticationBloc() ;
  UserProfileBloc userProfileBloc = UserProfileBloc();

  @override
  Future<void> close() {
    userProfileBloc.close();
    authenticationBloc.close();
    return super.close();
  }

  UserDataBloc(){
   authenticationBloc.listen((authenticationState) {
     userProfileBloc.add(LoadUserProfile());
   });
  }


  @override
  UserDataStates get initialState => UserDataInitializing();

  @override
  Stream<UserDataStates> mapEventToState(UserDataEvents event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}