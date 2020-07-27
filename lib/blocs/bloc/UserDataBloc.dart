import 'package:edu360/blocs/bloc/AuthenticationBloc.dart';
import 'package:edu360/blocs/bloc/HomePostsBloc.dart';
import 'package:edu360/blocs/bloc/UserProfileBloc.dart';
import 'package:edu360/blocs/bloc/UserSubscribedCoursesBloc.dart';
import 'package:edu360/blocs/events/CoursesEvents.dart';
import 'package:edu360/blocs/events/HomePostsEvent.dart';
import 'package:edu360/blocs/events/UserDataEvents.dart';
import 'package:edu360/blocs/events/UserProfileEvents.dart';
import 'package:edu360/blocs/states/AuthenticationStates.dart';
import 'package:edu360/blocs/states/UserDataStates.dart';
import 'package:edu360/data/apis/helpers/NetworkUtilities.dart';
import 'package:edu360/utilities/Constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDataBloc extends Bloc<UserDataEvents , UserDataStates>{
  AuthenticationBloc authenticationBloc = AuthenticationBloc() ;
  UserProfileBloc userProfileBloc = UserProfileBloc();
  HomePostsBloc homePostsBloc = HomePostsBloc();
  UserSubscribedCoursesBloc coursesBloc = UserSubscribedCoursesBloc();


  @override
  Future<void> close() {
    homePostsBloc.close();
    userProfileBloc.close();
    authenticationBloc.close();
    coursesBloc.close();
    return super.close();
  }

  UserDataBloc(){
   authenticationBloc.listen((authenticationState) {
     if(authenticationState is UserAuthenticated){
       userProfileBloc.add(LoadUserProfile());
       homePostsBloc.add(LoadHomeUserPosts());
       coursesBloc.add(LoadUserCourses());
     }
   });
  }

  @override
  UserDataStates get initialState => UserDataInitializing();

  @override
  Stream<UserDataStates> mapEventToState(UserDataEvents event) async*{
    bool isUserConnected = await NetworkUtilities.isConnected();
    if(isUserConnected == false){
      yield UserDataInitializationFailed(
          failureEvent: event,
          error: Constants.CONNECTION_TIMEOUT,
      );
      return ;
    }
  }
}