import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker/models/race.dart';
import 'package:race_tracker/models/segment.dart';
import 'package:race_tracker/ui/providers/race_provider.dart';
import 'package:race_tracker/ui/screens/time-tracker/race_tracking_screen.dart';
import 'package:race_tracker/ui/screens/widgets/buttons/race_button.dart';
import 'package:race_tracker/ui/screens/widgets/cards/race_detail_card.dart';
import 'package:race_tracker/ui/screens/widgets/cards/race_segments.dart'
    as segments_card;

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
    _fetchRace();
  }

  void _fetchRace() {
    Future.microtask(
      () => context.read<RaceProvider>().fetchRace(widget.raceId),
    );
  }

  void _onSegmentTap(SegmentModel segModel) {
    final segEnum = Segment.values.firstWhere(
      (e) => e.name.toLowerCase() == segModel.name.toLowerCase(),
      orElse: () => Segment.swimming,
    );
    _navigateToTrackingScreen(segEnum);
  }

  void _navigateToTrackingScreen(Segment segment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => RaceTrackingScreen(raceId: widget.raceId, segment: segment),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<RaceProvider>();
    final loading = prov.loading;
    final race = prov.currentRace;

    if (loading || race == null) {
      return _buildLoadingScreen();
    }

    return Scaffold(
      appBar: AppBar(title: Text(race.title)),
      body: _buildBody(race, prov),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Race Detail')),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildBody(Race race, RaceProvider provider) {
    return Column(
      children: [
        RaceDetailCard(race: race),
        segments_card.RaceSegments(
          segments: race.segments,
          onTap: _onSegmentTap,
        ),
        Expanded(child: _buildRaceControls(race, provider)),
      ],
    );
  }

  Widget _buildRaceControls(Race race, RaceProvider provider) {
    // Determine button state
    final isStarted = race.raceStatus == RaceStatus.started;
    final isFinished = race.raceStatus == RaceStatus.finished;
    final btnType = isStarted ? ButtonType.stop : ButtonType.start;

    // Disable button if race is finished or provider is loading
    final canPress = !provider.loading && !isFinished;

    final buttonHelpText = _getButtonHelpText(isStarted, isFinished);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RaceButton(
            onPressed:
                canPress
                    ? () => _handleRaceButtonPress(isStarted, provider)
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
            buttonHelpText,
            style: const TextStyle(fontSize: 12, color: Color(0xFF7e7e7e)),
          ),
        ],
      ),
    );
  }

  String _getButtonHelpText(bool isStarted, bool isFinished) {
    if (isStarted) {
      return 'Tap to stop & finish the race';
    } else if (isFinished) {
      return 'This race has been completed';
    } else {
      return '**NOTE**: This button starts the race timer.';
    }
  }

  Future<void> _handleRaceButtonPress(
    bool isStarted,
    RaceProvider provider,
  ) async {
    if (isStarted) {
      await provider.finishRace();
    } else {
      await provider.startRace();
    }
  }
}
