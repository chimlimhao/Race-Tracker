import 'package:flutter/material.dart';
import 'package:race_tracker/ui/screens/home_screen.dart';
import 'package:race_tracker/ui/screens/participant_screen.dart';
import 'package:race_tracker/ui/screens/race_screen.dart';
import 'package:race_tracker/ui/screens/result_screen.dart';
import 'package:race_tracker/ui/screens/widgets/navigations/bottom_navbar.dart';

class NavContainer extends StatefulWidget {
  const NavContainer({super.key});

  @override
  State<NavContainer> createState() => _NavContainerState();
}

class _NavContainerState extends State<NavContainer> {
  int currentIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    RaceScreen(),
    ParticipantScreen(),
    ResultScreen(),
  ];

  void onTapSelected(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavbar(
        currentIndex: currentIndex,
        onTap: onTapSelected,
      ),
    );
  }
}
