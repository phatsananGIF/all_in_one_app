import 'package:all_in_one_app/screen/my_calculator_page/my_calculator_page.dart';
import 'package:all_in_one_app/screen/my_home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'All in one',
      theme:ThemeData(
        scaffoldBackgroundColor: Color(0xFFF9F8FD),
        primaryColor: Color(0xFF0C9869),
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Color(0xFF3C4046)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyCalculatorPage(),
    );
  }
}
