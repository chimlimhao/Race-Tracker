import 'package:flutter/material.dart';
import 'package:race_tracker/ui/screens/widgets/forms/race_form.dart';

class RaceFormScreen extends StatelessWidget {
  const RaceFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create new race',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: RaceForm(),
    );
  }
}
