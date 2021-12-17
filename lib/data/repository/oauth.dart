import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

class Oauth {
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      YouTubeApi.youtubeReadonlyScope,
    ],
  );
  // Oauth({}){}
  GoogleSignInAccount? get getcurrentUser => googleSignIn.currentUser;
  String? get getclientId => googleSignIn.clientId;
  GoogleSignIn get googleSignInObj => googleSignIn;
  Future<AuthClient?> get httpClient async => await googleSignIn.authenticatedClient();
  Stream<GoogleSignInAccount?> get onCurrentUserChange => googleSignIn.onCurrentUserChanged;
  Future<GoogleSignInAccount?> handleSignIn() async {
    try {
      return await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> handleSignOut() async {
    try {
      await googleSignIn.signOut();
    } catch (error) {
      print(error);
    }
  }
}
