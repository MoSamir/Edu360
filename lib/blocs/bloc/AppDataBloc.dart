import 'package:edu360/blocs/bloc/UserDataBloc.dart';
import 'package:edu360/blocs/events/AppDataEvents.dart';
import 'package:edu360/blocs/states/AppDataStates.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/models/CategoryPostViewModel.dart';
import 'package:edu360/data/models/StudyFieldViewModel.dart';
import 'package:edu360/utilities/Constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDataBloc extends Bloc<AppDataEvents , AppDataStates>{

  UserDataBloc userDataBloc = UserDataBloc();


  @override
  Future<void> close() {
    userDataBloc.close();
    return super.close();
  }

  @override
  AppDataStates get initialState => AppDataLoading();

  @override
  Stream<AppDataStates> mapEventToState(AppDataEvents event) async*{

    bool isUserConnected = await NetworkUtilities.isConnected();
    if(isUserConnected == false){
      yield AppDataLoadingFailed(
        failureEvent: event,
        error: Constants.CONNECTION_TIMEOUT,
      );
      return ;
    }

  }
}