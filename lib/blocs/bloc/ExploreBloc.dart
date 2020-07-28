import 'package:edu360/Repository.dart';
import 'package:edu360/blocs/events/ExploreEevnts.dart';
import 'package:edu360/blocs/states/ExploreStates.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/data/models/CourseViewModel.dart';
import 'package:edu360/data/models/PostViewModel.dart';
import 'package:edu360/data/models/ResponseViewModel.dart';
import 'package:edu360/data/models/UserViewModel.dart';
import 'package:edu360/utilities/Constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreBloc extends Bloc<ExploreEvents,ExploreStates>{

  @override
  ExploreStates get initialState => ExploreScreenLoading();

  List<UserViewModel> teachers = List();
  List<UserViewModel> users = List();
  List<CourseViewModel> courses = List();
  List<PostViewModel> posts = List();

  @override
  Stream<ExploreStates> mapEventToState(ExploreEvents event) async*{
    bool isUserConnected = await NetworkUtilities.isConnected();
    if(isUserConnected == false){
      yield ExploreScreenErrorState(
        failureEvent: event,
        error: Constants.CONNECTION_TIMEOUT,
      );
      return ;
    }

    if(event is LoadExploreInformation){
     yield* _handleLoadingExploreInformation(event);
      return ;
    }
  }

  Stream<ExploreStates> _handleLoadingExploreInformation(LoadExploreInformation event) async*{
     yield ExploreScreenLoading();
     List<ResponseViewModel> responses = await Future.wait([
       Repository.loadStudyFieldTeachers() ,
       Repository.loadStudyFieldUsers() ,
       Repository.loadStudyFieldPosts() ,
       Repository.loadStudyFieldCourses(),
     ]);

     if(responses[0].isSuccess){
       teachers = responses[0].responseData;
     }
     else {
       teachers = null;
     }
     if(responses[1].isSuccess){
       teachers = responses[1].responseData;
     }
     else {
       users = null;
     }

     if(responses[2].isSuccess){
       posts = responses[2].responseData;
     }
     else {
       posts = null;
     }

     if(responses[3].isSuccess){
       courses = responses[3].responseData;
     }
     else {
       courses = null;
     }

     yield ExploreScreenLoaded();
  }
}