import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;
  const BottomNavbar({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.sports), label: 'Race'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Participant'),
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Result'),
      ],
      onTap: onTap,
      currentIndex: currentIndex,
      unselectedItemColor: Colors.black,
      unselectedLabelStyle: TextStyle(color: Colors.black),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.amber,
    );
  }
}
