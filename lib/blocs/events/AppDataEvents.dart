import 'package:edu360/data/models/IssueModel.dart';

abstract class AppDataEvents{}

class LoadApplicationConstantData extends AppDataEvents{}
class ReinitializeUser extends AppDataEvents{}

class SubmitIssue extends AppDataEvents{
  final IssueModel userIssue;
  SubmitIssue({this.userIssue});

}

