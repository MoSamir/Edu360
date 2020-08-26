import 'package:edu360/blocs/events/ExploreEevnts.dart';
import 'package:edu360/data/models/ErrorViewModel.dart';

abstract class ExploreStates {}

class ExploreScreenLoading extends ExploreStates{}
class ExploreScreenErrorState extends ExploreStates{
  final ErrorViewModel error ;
  final ExploreEvents failureEvent ;
  ExploreScreenErrorState({this.failureEvent , this.error});
}
class ExploreScreenLoaded extends ExploreStates{}