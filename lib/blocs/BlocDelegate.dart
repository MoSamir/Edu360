import 'package:bloc/bloc.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print('-----------------------------');
    print("Event => $event Dispatched");
    print('-----------------------------');
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('-----------------------------');
    print("Transition from : ${transition.currentState} To : ${transition.nextState}");
    print('-----------------------------');

  }
}