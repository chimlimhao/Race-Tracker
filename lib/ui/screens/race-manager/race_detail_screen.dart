
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker/models/race.dart';
import 'package:race_tracker/models/segment.dart';
import 'package:race_tracker/ui/providers/race_provider.dart';
import 'package:race_tracker/ui/screens/time-tracker/race_tracking_screen.dart';
import 'package:race_tracker/ui/screens/widgets/buttons/race_button.dart';
import 'package:race_tracker/ui/screens/widgets/cards/race_detail_card.dart';
import 'package:race_tracker/ui/screens/widgets/cards/race_segments.dart' as segments_card;

class RaceDetailScreen extends StatefulWidget {
  final String raceId;
  const RaceDetailScreen({Key? key, required this.raceId}) : super(key: key);

  @override
  _RaceDetailScreenState createState() => _RaceDetailScreenState();
}

class _RaceDetailScreenState extends State<RaceDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Load this race via provider
    Future.microtask(() => context.read<RaceProvider>().fetchRace(widget.raceId));
  }

  void _onSegmentTap(SegmentModel segModel) {
    final segEnum = Segment.values.firstWhere(
      (e) => e.name.toLowerCase() == segModel.name.toLowerCase(),
      orElse: () => Segment.swimming,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RaceTrackingScreen(
          raceId: widget.raceId,
          segment: segEnum,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<RaceProvider>();
    final loading = prov.loading;
    final race = prov.currentRace;

    if (loading || race == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Race Detail')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Determine button state
    final isStarted = race.raceStatus == RaceStatus.started;
    final btnType = isStarted ? ButtonType.stop : ButtonType.start;
    final canPress = !prov.loading;

    return Scaffold(
      appBar: AppBar(title: Text(race.title)),
      body: Column(
        children: [
          RaceDetailCard(race: race),
          segments_card.RaceSegments(
            segments: race.segments,
            onTap: _onSegmentTap,
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RaceButton(
                    onPressed: canPress
                      ? () async {
                          if (isStarted) {
                            await prov.finishRace();
                          } else {
                            await prov.startRace();
                          }
                        }
                      : null,
                    type: btnType,
                    bgcolor: Colors.black,
                    textColor: Colors.white,
                    width: 200,
                    height: 75,
                    fontSize: 18,
                    iconSize: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isStarted
                      ? 'Tap to stop & finish the race'
                      : '**NOTE**: This button starts the race timer.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7e7e7e),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
