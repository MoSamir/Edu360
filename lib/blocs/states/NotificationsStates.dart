import 'package:edu360/blocs/events/NotificationsEvents.dart';
import 'package:edu360/data/models/ErrorViewModel.dart';

abstract class NotificationStates{}


class NotificationsLoadedState extends NotificationStates{}

class NotificationsLoadingState extends NotificationStates{}


class NotificationsLoadingFailed extends NotificationStates{

  final NotificationsEvents failureEvent ;
  final ErrorViewModel error;
  NotificationsLoadingFailed({this.failureEvent, this.error});



}