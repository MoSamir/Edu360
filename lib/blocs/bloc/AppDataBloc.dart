import 'package:edu360/Repository.dart';
import 'package:edu360/blocs/bloc/UserDataBloc.dart';
import 'package:edu360/blocs/events/AppDataEvents.dart';
import 'package:edu360/blocs/states/AppDataStates.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/models/GradeViewModel.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
import 'package:edu360/data/models/StudyFieldViewModel.dart';
import 'package:edu360/utilities/Constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDataBloc extends Bloc<AppDataEvents , AppDataStates>{

  UserDataBloc userDataBloc = UserDataBloc();
  List<GradeViewModel> systemGrades = List();
  List<StudyFieldViewModel> systemStudyFields = List();


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
    } else if(event is LoadApplicationConstantData){
      yield* _handleLoadingAppData(event);
      return;
    }
  }

  Stream<AppDataStates> _handleLoadingAppData(LoadApplicationConstantData event) async* {

    List<ResponseViewModel> responses = await Future.wait([Repository.getSystemGradesList() , Repository.getFieldsOfStudy()]);

    ResponseViewModel<List<GradeViewModel>> gradeListResponse = responses[0] ;
    ResponseViewModel<List<StudyFieldViewModel>> studyFieldsResponse = responses[1] ;

    if(gradeListResponse.isSuccess)
      systemGrades = gradeListResponse.responseData;

    if(studyFieldsResponse.isSuccess)
      systemStudyFields = studyFieldsResponse.responseData;

  }
}