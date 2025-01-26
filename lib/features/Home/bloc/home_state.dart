part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

class HomeActionState extends HomeState{}

final class HomeInitial extends HomeState {}

class OpenAddNameOverlay extends HomeState{}

class NavigateToQuizScreen extends HomeActionState{
  final String name;
  NavigateToQuizScreen({required this.name});
}

class NavigateToLeaderboardScreen extends HomeActionState{}