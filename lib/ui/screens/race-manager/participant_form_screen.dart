import 'package:flutter/material.dart';
import 'package:race_tracker/ui/screens/widgets/forms/participant_form.dart';

class ParticipantFormScreen extends StatelessWidget {
  const ParticipantFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add new participant',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ParticipantForm(),
    );
  }
}
