// result_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:race_tracker/ui/providers/race_provider.dart';
import 'package:race_tracker/ui/screens/race-manager/result_detail_screen.dart';

import 'package:race_tracker/ui/screens/widgets/cards/race_card.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<RaceProvider>().fetchRaces());
  }

  @override
  Widget build(BuildContext context) {
    final raceProv = context.watch<RaceProvider>();
    final races = raceProv.races;
    final loading = raceProv.loading;

    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : races.isEmpty
              ? const Center(child: Text('No races available'))
              : ListView.builder(
                itemCount: races.length,
                itemBuilder: (ctx, i) {
                  final r = races[i];
                  return RaceCard(
                    race: r,
                    participantCount: r.segments.length, // or real count
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ResultDetailScreen(raceId: r.id),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
