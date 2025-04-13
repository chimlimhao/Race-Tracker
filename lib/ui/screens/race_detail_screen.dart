import 'package:flutter/material.dart';
import 'package:race_tracker/ui/screens/widgets/cards/race_detail_card.dart';

class RaceDetailScreen extends StatelessWidget {
  const RaceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Race Detail')),
      body: RaceDetailCard(),
    );
  }
}
