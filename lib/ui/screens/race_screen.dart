import 'package:flutter/material.dart';

class RaceScreen extends StatefulWidget {
  const RaceScreen({super.key});

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Race'),
      ),
      body: Text('RAce'),
    );
  }
}
