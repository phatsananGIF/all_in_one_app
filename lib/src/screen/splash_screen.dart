import 'package:all_in_one_app/src/screen/launcher.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  pushToLauncher(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Launcher()));
  }

  @override
  Widget build(BuildContext context) {
    pushToLauncher(context);
    return Scaffold(
      backgroundColor: Colors.indigo.shade300,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.dashboard,
            size: 150,
            color: Colors.white,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'ALL-IN-ONE',
            style: TextStyle(
                color: Color(0xff30384c),
                fontSize: 40,
                fontWeight: FontWeight.bold),
          )
        ],
      )),
    );
  }
}
