import 'package:edu360/blocs/bloc/HomePostsBloc.dart';
import 'package:edu360/blocs/bloc/UserProfileBloc.dart';
import 'package:edu360/blocs/events/PostEvents.dart';
import 'package:edu360/blocs/states/PostStates.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostBloc extends Bloc<PostEvents , PostStates>{

  UserProfileBloc profileBloc ;
  HomePostsBloc homePostsBloc ;
  PostBloc({this.homePostsBloc , this.profileBloc});


  @override
  PostStates get initialState => PostLoadedState();

  @override
  Stream<PostStates> mapEventToState(PostEvents event) async*{}
}