import 'package:edu360/blocs/events/AppDataEvents.dart';
import 'package:edu360/data/models/ErrorViewModel.dart';

abstract class AppDataStates {}

class AppDataLoading extends AppDataStates{}
class AppDataLoaded extends AppDataStates{}

class AppDataLoadingFailed extends AppDataStates{

  final AppDataEvents failureEvent;
  final ErrorViewModel error ;
  AppDataLoadingFailed({this.failureEvent , this.error});


}
