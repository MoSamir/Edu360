
import 'package:edu360/blocs/events/CreateNewContentEvents.dart';
import 'package:edu360/data/models/ErrorViewModel.dart';

abstract class CreateNewContentStates {}


class PostCreationLoading extends CreateNewContentStates {}

class PostCreationSuccess extends CreateNewContentStates {}

class PostCreationFailed extends CreateNewContentStates {
  final CreateNewContentEvents failedEvent ;
  final ErrorViewModel error ;
  PostCreationFailed({this.failedEvent, this.error});

}

class PostCreationInitialized extends CreateNewContentStates{}