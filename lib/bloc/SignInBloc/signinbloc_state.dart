part of 'signinbloc_bloc.dart';

@immutable
abstract class SigninblocState {}

class SigninblocInitial extends SigninblocState {}

class SigninblocSignedInState extends SigninblocState {
  final GoogleSignInAccount currentUser;
  final AuthClient client;
  SigninblocSignedInState({required this.currentUser, required this.client}) {
    // print("${currentUser!.displayName} authenticated");
  }
}

class SigninblocSignedOutState extends SigninblocState {}
