import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:race_tracker/models/race.dart';
import 'package:race_tracker/ui/utils/segment_chip.dart';
import 'package:race_tracker/ui/utils/status_chip.dart';
import 'package:race_tracker/ui/screens/race-manager/race_detail_screen.dart';

class RaceCard extends StatelessWidget {
  final Race race;
  final int participantCount;
  final VoidCallback? onTap;

  const RaceCard({
    Key? key,
    required this.race,
    this.participantCount = 0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // map your model’s RaceStatus to the UI Status enum
    Status uiStatus;
    switch (race.raceStatus) {
      case RaceStatus.notStarted:
        uiStatus = Status.pending;
        break;
      case RaceStatus.started:
        uiStatus = Status.pending;
        break;
      case RaceStatus.finished:
      default:
        uiStatus = Status.completed;
        break;
    }

    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RaceDetailScreen(raceId: race.id),
              ),
            );
          },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with title & status
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              padding: const EdgeInsets.all(18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    race.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  StatusChip(status: uiStatus),
                ],
              ),
            ),

            Divider(height: 1, color: Colors.black.withOpacity(0.1)),
          
            // Body with date, location, participants, segments
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    Icons.calendar_today_outlined,
                    DateFormat('dd MMM, yyyy').format(race.date),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.location_on_outlined,
                    race.location,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.people_outline_outlined,
                    '$participantCount participant${participantCount == 1 ? '' : 's'}',
                  ),
                  const SizedBox(height: 22),

                  // Segment chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: race.segments
                        .map((seg) => SegmentChip(label: seg.name))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style: TextStyle(fontSize: 14, color: Colors.black),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
