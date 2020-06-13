import 'package:edu360/data/models/UserViewModel.dart';
class Repository {
  
  static Future<void> signUp(UserViewModel userModel) async{
   await Future.delayed(Duration(seconds: 2),()=>{});
  }

  static signIn({String userPhoneNumber, String userPassword}) async{
    await Future.delayed(Duration(seconds: 2),()=>{});
  }

  static saveUser(responseData)  async{
    await Future.delayed(Duration(seconds: 2),()=>{});
  }

  static saveEncryptedPassword(String userPassword) async {
    await Future.delayed(Duration(seconds: 2),()=>{});
  }

  static getUser() async {
    await Future.delayed(Duration(seconds: 2),()=>{});
  }

  static signOut() async {
    await Future.delayed(Duration(seconds: 2),()=>{});
  }

  static clearCache()async {
    await Future.delayed(Duration(seconds: 2),()=>{});
  }










}