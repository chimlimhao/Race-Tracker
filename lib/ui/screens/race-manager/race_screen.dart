import 'package:flutter/material.dart';
import 'package:race_tracker/data/repositories/firebase/firebase_service.dart';
import 'package:race_tracker/models/race.dart';
import 'package:race_tracker/ui/screens/race-manager/race_detail_screen.dart';
import 'package:race_tracker/ui/screens/widgets/cards/race_card.dart';
import 'package:race_tracker/ui/screens/widgets/modals/race_bottom_sheet.dart';

class RaceScreen extends StatelessWidget {
  const RaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Races'), actions: [ IconButton(onPressed: () {
         RaceBottomSheet.show(context); 
      }, icon: Icon(Icons.add))],),
      
      body: FutureBuilder<List<Race>>(
        future: FirebaseService().getAllRaces(),
        
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final races = snapshot.data ?? [];
          if (races.isEmpty) {
            return const Center(child: Text('No races found.'));
          }
          return ListView.builder(
            itemCount: races.length,
            itemBuilder: (ctx, i) {
              final race = races[i];
              return RaceCard(
                race: race,
                // if you want real participant count, fetch separately:
                participantCount: 0,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          RaceDetailScreen(raceId: race.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
