import 'package:flutter/material.dart';

class ParticipantScreen extends StatelessWidget {
  const ParticipantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Participant'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              child: Text('Participant list'),
            )
          ],
        ),
      ),
    );
  }
}
