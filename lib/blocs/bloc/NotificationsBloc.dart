import 'package:edu360/Repository.dart';
import 'package:edu360/blocs/events/NotificationsEvents.dart';
import 'package:edu360/blocs/states/NotificationsStates.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/models/NotificationViewModel.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
import 'package:edu360/utilities/Constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsBloc extends Bloc<NotificationsEvents , NotificationStates>{


  List<NotificationViewModel> userNotifications = List();
  int pageNo = 1 ;

  @override
  NotificationStates get initialState => NotificationsLoadingState();

  @override
  Stream<NotificationStates> mapEventToState(NotificationsEvents event) async*{
    bool isUserConnected = await NetworkUtilities.isConnected();
    if(isUserConnected == false){
      yield NotificationsLoadingFailed(
        failureEvent: event,
        error: Constants.CONNECTION_TIMEOUT,
      );
      return ;
    }

    if(event is LoadNotifications){
      yield* _handleNotificationsLoading(event);
      return;
    }
  }

  Stream<NotificationStates> _handleNotificationsLoading(LoadNotifications event)async* {
    ResponseViewModel<List<NotificationViewModel>> pageNotifications = await Repository.loadUserNotifications(pageNo: pageNo);
    if(pageNotifications.isSuccess){
      pageNo++;
      userNotifications.addAll(pageNotifications.responseData);
      yield NotificationsLoadedState();
    } else {
      yield NotificationsLoadingFailed(failureEvent: event , error: pageNotifications.errorViewModel);
      return ;
    }


  }
}