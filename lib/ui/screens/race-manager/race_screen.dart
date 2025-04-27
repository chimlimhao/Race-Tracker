import 'package:flutter/material.dart';
import 'package:race_tracker/ui/screens/widgets/inputs/search_input.dart';
import 'package:race_tracker/ui/screens/widgets/cards/race_card.dart';
import 'package:race_tracker/ui/screens/widgets/modals/race_bottom_sheet.dart';

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
              RaceBottomSheet.show(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SearchInput(),
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
