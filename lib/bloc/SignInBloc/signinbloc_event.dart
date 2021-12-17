part of 'signinbloc_bloc.dart';

@immutable
abstract class SigninblocEvent {}

class SignInInitialEvent extends SigninblocEvent {
  SignInInitialEvent() {}
}

class SignInButtonPressed extends SigninblocEvent {}

class SignOutButtonPressed extends SigninblocEvent {}
