import 'package:all_in_one_app/src/screen/my_calculator_page/my_calculator_page.dart';
import 'package:all_in_one_app/src/screen/my_todo/my_todo_page.dart';
import 'package:all_in_one_app/src/screen/people/people_list.dart';
import 'package:flutter/material.dart';

class Launcher extends StatefulWidget {
  Launcher({Key key}) : super(key: key);

  @override
  _LauncherState createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  List _screens = [MyToDoPage(), MyCalculatorPage(), PeoPleList()];
  final List icons = [
    Icons.today_outlined,
    Icons.calculate_outlined,
    Icons.person_outline
  ];
  final List activeIcons = [
    Icons.today_rounded,
    Icons.calculate_rounded,
    Icons.person_rounded
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
        type: BottomNavigationBarType.fixed,
        items: icons
            .asMap()
            .map(
              (key, value) => MapEntry(
                key,
                buildBottomNavigationBarItem(key),
              ),
            )
            .values
            .toList(),
      ),
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(int key) {
    return BottomNavigationBarItem(
      label: "",
      icon: Icon(icons[key], color: Colors.grey),
      activeIcon: Icon(activeIcons[key], color: Colors.grey.shade700),
    );
  }
}
