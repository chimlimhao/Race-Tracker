import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;
  const BottomNavbar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.sports), label: 'Race'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Participant'),
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Result'),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      onTap: onTap,
    );
  }
}
