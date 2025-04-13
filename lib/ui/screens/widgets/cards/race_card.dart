import 'package:flutter/material.dart';
import 'package:race_tracker/ui/screens/race_detail_screen.dart';
import 'package:race_tracker/ui/utils/segment_chip.dart';
import 'package:race_tracker/ui/utils/status_chip.dart';

class RaceCard extends StatefulWidget {
  const RaceCard({super.key});

  @override
  State<RaceCard> createState() => _RaceCardState();
}

class _RaceCardState extends State<RaceCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sensok Race',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  StatusChip(status: Status.pending),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(children: [Icon(Icons.date_range), Text('12 May, 2025')]),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined),
                      Text('Location'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.people_outline_outlined),
                      Text('Participants'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      SegmentChip(),
                      SizedBox(width: 4),
                      SegmentChip(),
                      SizedBox(width: 4),
                      SegmentChip(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const RaceDetailScreen()),
        );
      },
    );
  }
}
