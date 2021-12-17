import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:youtubeapis/bloc/SignInBloc/signinbloc_bloc.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  GoogleSignInAccount? currentUser;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SigninblocBloc, SigninblocState>(
      builder: (context, state) {
        if (state is SigninblocSignedInState) {
          currentUser = state.currentUser;
        } else if (state is SigninblocSignedOutState) {
          currentUser = null;
        }
        return ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: SelectableText(
                currentUser?.displayName! ?? "Not Signed In",
              ),
              accountEmail: (currentUser != null) ? SelectableText(currentUser!.email) : null,
              currentAccountPicture: (currentUser != null)
                  ? CircleAvatar(backgroundImage: NetworkImage(currentUser!.photoUrl!))
                  : CircleAvatar(
                      backgroundColor: Theme.of(context).backgroundColor,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 2,
                child: ListTile(
                  title: Text((currentUser != null) ? "Sign Out" : "Sign In"),
                  onTap: () {
                    if (currentUser != null) {
                      BlocProvider.of<SigninblocBloc>(context)..add(SignOutButtonPressed());
                    } else {
                      BlocProvider.of<SigninblocBloc>(context)..add(SignInButtonPressed());
                    }
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
