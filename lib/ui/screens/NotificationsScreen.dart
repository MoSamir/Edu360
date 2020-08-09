import 'dart:io';

import 'package:edu360/blocs/bloc/NotificationsBloc.dart';
import 'package:edu360/blocs/events/NotificationsEvents.dart';
import 'package:edu360/blocs/states/NotificationsStates.dart';
import 'package:edu360/ui/widgets/NetworkErrorView.dart';
import 'package:edu360/ui/widgets/NotificationCard.dart';
import 'package:edu360/ui/widgets/PlaceHolderWidget.dart';
import 'package:edu360/utilities/AppStyles.dart';
import 'package:edu360/utilities/LocalKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class NotificationsScreen extends StatefulWidget {
  final Function moveToScreen;
  NotificationsScreen(this.moveToScreen);
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationsBloc notificationsBloc = NotificationsBloc();
  ScrollController _notificationScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    notificationsBloc.add(LoadNotifications());
    _notificationScrollController.addListener(_loadMoreNotifications);
  }

  @override
  void dispose() {
    notificationsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundColor,
      child: BlocConsumer(
        listener: (context, state){

          if (state is NotificationsLoadingFailed) {
            if (state.error.errorCode == HttpStatus.requestTimeout|| state.error.errorCode == HttpStatus.badGateway) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return NetworkErrorView();
                  });
            }
            else if(state.error.errorCode == HttpStatus.serviceUnavailable){
              Fluttertoast.showToast(
                  msg: (LocalKeys.SERVER_UNREACHABLE).tr(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
            else if(notificationsBloc.userNotifications.length > 0){}
            else {
              Fluttertoast.showToast(
                  msg: state.error.errorMessage ?? '',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
          }
        },
        bloc: notificationsBloc,
        builder: (context, state){
          if(state is NotificationsLoadedState || notificationsBloc.userNotifications.length > 0){
            return notificationsBloc.userNotifications.length > 0 ?
            ModalProgressHUD(
              inAsyncCall: state is NotificationsLoadingState,
              child: ListView.builder(
                controller: _notificationScrollController,
                itemBuilder: (context,  index)=> NotificationCard(notificationViewModel: notificationsBloc.userNotifications[index],),itemCount: notificationsBloc.userNotifications.length, shrinkWrap: true, ),
            ):
             PlaceHolderWidget(placeHolder: Text(LocalKeys.NO_NOTIFICATION_PLACEHOLDER).tr(),);
          }
          else if(state is NotificationsLoadingState){
            return CircularProgressIndicator();
          }
          else {
            return Container();
          }
        },
      ),
    );
  }

  _loadMoreNotifications() {
    if (_notificationScrollController.offset <
        (_notificationScrollController.position.maxScrollExtent - 50) &&
        notificationsBloc.state is NotificationsLoadingState == false) {
      notificationsBloc.add(LoadNotifications());
      return;
    }
  }



}
