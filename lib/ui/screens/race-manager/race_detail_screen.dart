import 'package:flutter/material.dart';
import 'package:race_tracker/ui/screens/time-tracker/race_tracking_screen.dart';
import 'package:race_tracker/ui/screens/widgets/buttons/race_button.dart';
import 'package:race_tracker/ui/screens/widgets/cards/race_segments.dart';
import 'package:race_tracker/ui/screens/widgets/cards/race_detail_card.dart';

class RaceDetailScreen extends StatelessWidget {
  const RaceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void onSegmentTap() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RaceTrackingScreen()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Race Detail')),
      body: Column(
        children: [
          RaceDetailCard(),
          RaceSegments(onTap: onSegmentTap),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaceButton(
                  onPressed: () {
                    // TODO: Implement start race
                  },
                  type: ButtonType.start,
                  bgcolor: Colors.black,
                  textColor: Colors.white,
                  width: 200,
                  height: 75,
                  fontSize: 18,
                  iconSize: 32,
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: 250,
                  child: Text(
                    "**NOTE**: This button will start the race for all participant in the race.",
                    style: TextStyle(fontSize: 12, color: Color(0xFF7e7e7e)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
