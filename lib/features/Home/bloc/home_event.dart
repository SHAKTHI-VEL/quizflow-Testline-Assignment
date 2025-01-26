part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class StartButtonClicked extends HomeEvent{}

class LeaderboardButtonClicked extends HomeEvent{}

class ContinueButtonClicked extends HomeEvent{
  final String name;

  ContinueButtonClicked({required this.name});
}