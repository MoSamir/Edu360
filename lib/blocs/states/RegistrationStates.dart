import 'package:edu360/data/models/ErrorViewModel.dart';
import 'package:edu360/blocs/events/RegistrationEvents.dart';

abstract class RegistrationStates {}


class WaitingPhoneAuthenticationComplete extends RegistrationStates{}

class RegistrationPageInitiated extends RegistrationStates{}

class RegistrationPendingVerification extends RegistrationStates{}

class RegistrationPageLoading extends RegistrationStates{}

class RegistrationSuccess extends RegistrationStates{
  final String userName , userPassword;
  RegistrationSuccess(this.userName , this.userPassword);

}

class RegistrationFailed extends RegistrationStates{
  final ErrorViewModel error ;
  final RegistrationEvents failedEvent;
  RegistrationFailed({this.error, this.failedEvent});

}

