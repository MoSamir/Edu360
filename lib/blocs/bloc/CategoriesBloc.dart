import 'package:edu360/blocs/events/CategoriesEvents.dart';
import 'package:edu360/blocs/states/CategoriesStates.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/models/CategoryPostViewModel.dart';
import 'package:edu360/utilities/Constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesBloc extends Bloc<CategoriesEvents , CategoriesStates>{

  List<CategoryPostViewModel> systemCategories = List();

  @override
  CategoriesStates get initialState => CategoriesLoading();

  @override
  Stream<CategoriesStates> mapEventToState(CategoriesEvents event) async*{
    bool isUserConnected = await NetworkUtilities.isConnected();
    if(isUserConnected == false){
      yield CategoriesLoadingFailed(
        failureEvent: event,
        error: Constants.CONNECTION_TIMEOUT,
      );
      return ;
    }
  }
}