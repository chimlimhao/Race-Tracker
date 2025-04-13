import 'package:flutter/material.dart';
import 'package:race_tracker/ui/screens/race_form_screen.dart';
import 'package:race_tracker/ui/screens/widgets/buttons/race_search.dart';
import 'package:race_tracker/ui/screens/widgets/cards/race_card.dart';

class RaceScreen extends StatelessWidget {
  const RaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Race'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RaceFormScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          RaceSearch(),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return RaceCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}
