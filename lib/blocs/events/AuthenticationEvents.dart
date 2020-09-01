abstract class AuthenticationEvents {}

class AuthenticateUser extends AuthenticationEvents{}

class LoginUser extends AuthenticationEvents{
  final String userEmail ;
  final String userPassword ;
  LoginUser({this.userEmail , this.userPassword});
}

class Logout extends AuthenticationEvents{}

class UpdateUserInformation extends AuthenticationEvents{}

class ForgetPassword extends AuthenticationEvents{
  final String userEmail ;
  ForgetPassword({this.userEmail});
}


class ResetPassword extends AuthenticationEvents{
  final userEmail , userPassCode , userNewPassword ;
  ResetPassword({this.userEmail , this.userNewPassword , this.userPassCode});
}