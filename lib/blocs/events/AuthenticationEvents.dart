abstract class AuthenticationEvents {}

class AuthenticateUser extends AuthenticationEvents{}

class LoginUser extends AuthenticationEvents{
  final String userPhoneNumber ;
  final String userPassword ;
  LoginUser({this.userPhoneNumber , this.userPassword});
}

class Logout extends AuthenticationEvents{}