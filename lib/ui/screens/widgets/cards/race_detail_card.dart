import 'dart:async';
import 'package:flutter/material.dart';
import 'package:race_tracker/models/race.dart';
// import 'package:race_tracker/data/repositories/firebase/firebase_service.dart';
import 'package:race_tracker/models/segment.dart';

// import 'package:race_tracker/ui/screens/time-tracker/race_tracking_screen.dart';
// import 'package:race_tracker/ui/screens/widgets/buttons/race_button.dart';

/// Card showing elapsed time for a race
class RaceDetailCard extends StatefulWidget {
  final Race race;
  const RaceDetailCard({super.key, required this.race});

  @override
  State<RaceDetailCard> createState() => _RaceDetailCardState();
}

class _RaceDetailCardState extends State<RaceDetailCard> {
  late Timer _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateElapsed();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateElapsed(),
    );
  }

  void _updateElapsed() {
    final race = widget.race;

    // ← NEW: show zero until the race actually starts
    if (race.raceStatus == RaceStatus.notStarted || race.startTime <= 0) {
      setState(() => _elapsed = Duration.zero);
      return;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final start = race.startTime;
    final end = race.raceStatus == RaceStatus.finished ? race.endTime : now;

    setState(() => _elapsed = Duration(milliseconds: end - start));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final txt = _formatDuration(_elapsed);
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.access_time_outlined, size: 38),
            const SizedBox(width: 12),
            Text(
              txt,
              style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}

/// Dynamic segments list that navigates to tracking
class RaceSegments extends StatelessWidget {
  final List<SegmentModel> segments;
  final void Function(SegmentModel) onTap;

  const RaceSegments({Key? key, required this.segments, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Segments',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children:
                segments.map((seg) {
                  return InkWell(
                    onTap: () => onTap(seg),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7.5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        seg.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
