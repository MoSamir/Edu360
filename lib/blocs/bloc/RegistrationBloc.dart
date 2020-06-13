import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edu360/blocs/events/RegistrationEvents.dart';
import 'package:edu360/blocs/states/RegistrationStates.dart';
class RegistrationBloc extends Bloc<RegistrationEvents, RegistrationStates>{
  @override
  // TODO: implement initialState
  RegistrationStates get initialState => RegistrationPageInitiated();

  @override
  Stream<RegistrationStates> mapEventToState(RegistrationEvents event) async*{
  }
}