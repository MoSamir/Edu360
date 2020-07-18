import 'package:edu360/Repository.dart';
import 'package:edu360/blocs/events/CategoriesEvents.dart';
import 'package:edu360/blocs/events/UserProfileEvents.dart';
import 'package:edu360/blocs/states/CategoriesStates.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/models/CategoryPostViewModel.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
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

    if(event is LoadAppCategories){
      yield* _handleCategoryLoading(event);
      return ;
    }
  }

  Stream<CategoriesStates> _handleCategoryLoading(LoadAppCategories event) async*{
    ResponseViewModel<List<CategoryPostViewModel>> loadingCategoriesResponse = await Repository.loadUserCategories();
    if(loadingCategoriesResponse.isSuccess){
      systemCategories = loadingCategoriesResponse.responseData;
      yield CategoriesLoaded();
          return ;
    } else {
     yield CategoriesLoadingFailed(error: loadingCategoriesResponse.errorViewModel , failureEvent: event);
      return ;
    }
  }
}