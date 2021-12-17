import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:youtubeapis/data/repository/oauth.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

part 'signinbloc_event.dart';
part 'signinbloc_state.dart';

class SigninblocBloc extends Bloc<SigninblocEvent, SigninblocState> {
  // ignore: cancel_subscriptions
  StreamSubscription<GoogleSignInAccount?>? ss;
  AuthClient? as;
  SigninblocBloc() : super(SigninblocInitial()) {
    on<SignInInitialEvent>((event, emit) async {
      GoogleSignInAccount? user;

      if (oauth.getcurrentUser == null) {
        user = await oauth.googleSignIn.signInSilently();
      } else {
        user = oauth.getcurrentUser;
      }
      if (user == null) {
        emit(SigninblocSignedOutState());
      } else {
        emit(SigninblocSignedInState(currentUser: user, client: (await oauth.httpClient)!));
      }
      listenForUserChange();
    });

    on<SignInButtonPressed>((event, emit) async {
      await oauth.handleSignIn();
      listenForUserChange();
      emit(SigninblocSignedInState(currentUser: oauth.getcurrentUser!, client: (await oauth.httpClient)!));
    });
    on<SignOutButtonPressed>((event, emit) async {
      await oauth.handleSignOut();
      ss!.cancel();
      emit(SigninblocSignedOutState());
    });
  }
  Oauth oauth = Oauth();
  void listenForUserChange() {
    ss = oauth.onCurrentUserChange.listen((GoogleSignInAccount? account) {
      add(SignInInitialEvent());
    });
  }

  // StreamSubscription<GoogleSignInAccount?>? ss;
  // AuthClient? as;
  // @override
  // Stream<SigninblocState> mapEventToState(
  //   SigninblocEvent event,
  // ) async* {
  //   if (event is SignInInitialEvent) {
  //     GoogleSignInAccount? user;

  //     if (oauth.getcurrentUser == null) {
  //       user = await oauth.googleSignIn.signInSilently();
  //     } else {
  //       user = oauth.getcurrentUser;
  //     }
  //     if (user == null) {
  //       yield SigninblocSignedOutState();
  //     } else {
  //       yield SigninblocSignedInState(currentUser: user, client: (await oauth.httpClient)!);
  //     }
  //     listenForUserChange();
  //   } else if (event is SignInButtonPressed) {
  //     await oauth.handleSignIn();
  //     listenForUserChange();
  //     yield SigninblocSignedInState(currentUser: oauth.getcurrentUser!, client: (await oauth.httpClient)!);
  //   } else if (event is SignOutButtonPressed) {
  //     await oauth.handleSignOut();
  //     ss!.cancel();
  //     yield SigninblocSignedOutState();
  //   }
  // }
}
