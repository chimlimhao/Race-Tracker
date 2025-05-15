
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
              await RaceBottomSheet.show(context);
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
                return Dismissible(
                  key: ValueKey(race.id),
                  background: Container(
                    color: Colors.transparent,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.transparent,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Race?'),
                        content: Text('Are you sure you want to delete "${race.title}"?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                          TextButton(onPressed: () => Navigator.pop(ctx, true),  child: const Text('Delete')),
                        ],
                      ),
                    ) ?? false;
                  },
                  onDismissed: (_) {
                    context.read<RaceProvider>().deleteRace(race.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Deleted "${race.title}"')),
                    );
                  },
                  child: RaceCard(
                    race: race,
                    participantCount: race.segments.length,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RaceDetailScreen(raceId: race.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
