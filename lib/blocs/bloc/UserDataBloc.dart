import 'package:edu360/blocs/bloc/AuthenticationBloc.dart';
import 'package:edu360/blocs/events/UserDataEvents.dart';
import 'package:edu360/blocs/states/UserDataStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDataBloc extends Bloc<UserDataEvents , UserDataStates>{
  AuthenticationBloc authenticationBloc = AuthenticationBloc() ;

  @override
  Future<void> close() {
    authenticationBloc.close();
    return super.close();
  }

  @override
  // TODO: implement initialState
  UserDataStates get initialState => UserDataInitializing();

  @override
  Stream<UserDataStates> mapEventToState(UserDataEvents event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}