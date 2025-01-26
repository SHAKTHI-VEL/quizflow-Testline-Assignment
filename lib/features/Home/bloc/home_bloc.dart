import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<StartButtonClicked>(startButtonClicked);
    on<LeaderboardButtonClicked>(leaderboardButtonClicked);
    on<ContinueButtonClicked>(continueButtonClicked);
  }
  
  FutureOr<void> startButtonClicked(StartButtonClicked event,Emitter<HomeState> emit){
    emit(OpenAddNameOverlay());
  }

  FutureOr<void> leaderboardButtonClicked(LeaderboardButtonClicked event,Emitter<HomeState> emit){
    emit(NavigateToLeaderboardScreen());
  }

  FutureOr<void> continueButtonClicked(ContinueButtonClicked event,Emitter<HomeState> emit){
    emit(NavigateToQuizScreen(name: event.name));
  }
}
