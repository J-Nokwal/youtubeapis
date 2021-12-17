

// import 'package:googleapis/discovery/v1.dart';
// import 'package:googleapis_auth/googleapis_auth.dart';

// class Discovery {
//   late DiscoveryApi aa;
//   Discovery(AuthClient client) {
//     aa = DiscoveryApi(client);
//   }
//   fxn()async{
//     RestDescription bb = await aa.apis.getRest("youtube", "v3",$fields: "rest");
//     bb.
//   }
// }



import 'package:flutter/material.dart';

class hello extends StatefulWidget {
  const hello({ Key? key }) : super(key: key);

  @override
  _helloState createState() => _helloState();
}

class _helloState extends State<hello> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("hello world"),
      
    );
  }
}