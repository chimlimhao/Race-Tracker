// race_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker/models/race.dart';

import 'package:race_tracker/ui/providers/race_provider.dart';
import 'package:race_tracker/ui/screens/race-manager/race_detail_screen.dart';
import 'package:race_tracker/ui/screens/widgets/cards/race_card.dart';
import 'package:race_tracker/ui/screens/widgets/modals/race_bottom_sheet.dart';

class RaceScreen extends StatefulWidget {
  const RaceScreen({Key? key}) : super(key: key);

  @override
  _RaceScreenState createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  @override
  void initState() {
    super.initState();
    // fetch all races once when screen loads
    Future.microtask(() => context.read<RaceProvider>().fetchRaces());
  }

  @override
  Widget build(BuildContext context) {
    final raceProv = context.watch<RaceProvider>();
    final races    = raceProv.races;
    final loading  = raceProv.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Races'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // show your bottom‐sheet to create a race
              await RaceBottomSheet.show(context);
              // reload after it's dismissed
              await context.read<RaceProvider>().fetchRaces();
            },
          ),
        ],
      ),
      body: loading
        ? const Center(child: CircularProgressIndicator())
        : races.isEmpty
          ? const Center(child: Text('No races found.'))
          : ListView.builder(
              itemCount: races.length,
              itemBuilder: (ctx, i) {
                final race = races[i];
                return RaceCard(
                  race: race,
                  participantCount: race.segments.length, // or whatever count you track
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RaceDetailScreen(raceId: race.id),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
