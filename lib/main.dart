import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Ui/homePage.dart';
import 'bloc/SignInBloc/signinbloc_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp() {
    //
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => SigninblocBloc()..add(SignInInitialEvent()),
        child: HomePage(),
      ),
    );
  }
}
