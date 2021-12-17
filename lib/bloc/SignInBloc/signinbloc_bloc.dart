import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:youtubeapis/data/repository/oauth.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

part 'signinbloc_event.dart';
part 'signinbloc_state.dart';

class SigninblocBloc extends Bloc<SigninblocEvent, SigninblocState> {
  SigninblocBloc() : super(SigninblocInitial()) {
    // on<SigninblocEvent>((event, emit) {
    //   if (event is SignInButtonPressed) {
    //     emit SigninblocSignedInState();
    //   }
    // });
  }
  Oauth oauth = Oauth();
  void listenForUserChange() {
    ss = oauth.onCurrentUserChange.listen((GoogleSignInAccount? account) {
      mapEventToState(SignInInitialEvent());
    });
  }

  StreamSubscription<GoogleSignInAccount?>? ss;
  AuthClient? as;
  @override
  Stream<SigninblocState> mapEventToState(
    SigninblocEvent event,
  ) async* {
    if (event is SignInInitialEvent) {
      GoogleSignInAccount? user;

      if (oauth.getcurrentUser == null) {
        user = await oauth.googleSignIn.signInSilently();
      } else {
        user = oauth.getcurrentUser;
      }
      if (user == null) {
        yield SigninblocSignedOutState();
      } else {
        yield SigninblocSignedInState(currentUser: user, client: (await oauth.httpClient)!);
      }
      listenForUserChange();
    } else if (event is SignInButtonPressed) {
      await oauth.handleSignIn();
      listenForUserChange();
      yield SigninblocSignedInState(currentUser: oauth.getcurrentUser!, client: (await oauth.httpClient)!);
    } else if (event is SignOutButtonPressed) {
      await oauth.handleSignOut();
      ss!.cancel();
      yield SigninblocSignedOutState();
    }
  }
}
