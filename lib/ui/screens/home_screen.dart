import 'package:flutter/material.dart';
// import 'widgets/navigations/bottom_navbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
          child: Column(
        children: [
          Container(
            child: Text('stats'),
          ),
          Container(
            child: Text('summary races'),
          )
        ],
      )),
    );
  }
}
