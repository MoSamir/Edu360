import 'package:edu360/blocs/events/CategoriesEvents.dart';
import 'package:edu360/data/models/ErrorViewModel.dart';

abstract class CategoriesStates {}

class CategoriesLoading extends CategoriesStates{}

class CategoriesLoaded extends CategoriesStates{}

class CategoriesLoadingFailed extends CategoriesStates{

  final ErrorViewModel error ;
  final CategoriesEvents failureEvent ;
  CategoriesLoadingFailed({this.error , this.failureEvent});
}

