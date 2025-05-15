import 'package:flutter/material.dart';
import 'package:race_tracker/models/race.dart';
import 'package:race_tracker/data/repositories/firebase/firebase_service.dart';
import 'package:race_tracker/models/segment.dart';
import 'package:race_tracker/ui/screens/time-tracker/race_tracking_screen.dart';
import 'package:race_tracker/ui/screens/widgets/buttons/race_button.dart';
import 'package:race_tracker/ui/screens/widgets/cards/race_segments.dart';
import 'package:race_tracker/ui/screens/widgets/cards/race_detail_card.dart';
import 'package:race_tracker/ui/screens/widgets/cards/race_detail_card.dart';
import 'package:race_tracker/ui/screens/widgets/cards/race_segments.dart'
    as segments_card;

// ...


/// Full detail screen with start button and segments
class RaceDetailScreen extends StatefulWidget {
  final String raceId;
  const RaceDetailScreen({Key? key, required this.raceId}) : super(key: key);
  @override
  _RaceDetailScreenState createState() => _RaceDetailScreenState();
}

class _RaceDetailScreenState extends State<RaceDetailScreen> {
  final _service = FirebaseService();
  Race? _race;
  bool _loading = true;
  bool _updating = false;

  @override
  void initState() {
    super.initState();
    _loadRace();
  }

  Future<void> _loadRace() async {
    setState(() => _loading = true);
    _race = await _service.getRace(widget.raceId);
    setState(() => _loading = false);
  }

  Future<void> _startRace() async {
    if (_race == null) return;
    setState(() {
      _updating = true;
      _race!.markStarted();
    });
    await _service.updateRace(_race!);
    setState(() => _updating = false);
  }

    Future<void> _finishRace() async {
    if (_race == null) return;
    setState(() {
      _updating = true;
      _race!.markFinished();   // ← your model’s “complete” helper
    });
    await _service.updateRace(_race!);
    setState(() => _updating = false);
  }
void _onSegmentTap(SegmentModel segModel) {
  // e.name is the enum’s .name (e.g. 'swimming'), segModel.name is 'Swimming'
  final segEnum = Segment.values.firstWhere(
    (e) => e.name.toLowerCase() == segModel.name.toLowerCase(),
    orElse: () => Segment.swimming,
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => RaceTrackingScreen(
        raceId: widget.raceId,
        segment: segEnum,   // now a Segment, not a String
      ),
    ),
  );
}
 @override
  Widget build(BuildContext context) {
    if (_loading || _race == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Race Detail')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final race      = _race!;
    final isStarted = race.raceStatus == RaceStatus.started;
    // no separate “isFinished” check needed since stop==finished

    // Toggle between start & stop
    final btnType = isStarted 
        ? ButtonType.stop 
        : ButtonType.start;

    // Only disable while we’re waiting on firebase
    final canPress = !_updating;

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
                      ? (isStarted ? _finishRace : _startRace)
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
