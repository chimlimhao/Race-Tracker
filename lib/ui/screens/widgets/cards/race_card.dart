import 'package:flutter/material.dart';
import 'package:race_tracker/ui/screens/race-manager/race_detail_screen.dart';
import 'package:race_tracker/ui/utils/segment_chip.dart';
import 'package:race_tracker/ui/utils/status_chip.dart';

class RaceCard extends StatelessWidget {
  const RaceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const RaceDetailScreen()),
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
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              padding: const EdgeInsets.all(18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sensok Race',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const StatusChip(status: Status.completed),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.black.withOpacity(0.1)),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(Icons.calendar_today_outlined, '12 May, 2025'),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.location_on_outlined, 'Location'),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.people_outline_outlined, 'Participants'),
                  const SizedBox(height: 22),
                  _buildSegmentTags(),
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
        Text(text, style: TextStyle(fontSize: 14, color: Colors.black)),
      ],
    );
  }

  Widget _buildSegmentTags() {
    return Row(
      children: [
        const SegmentChip(label: 'Swimming'),
        const SegmentChip(label: 'Cycling'),
        const SegmentChip(label: 'Running'),
      ],
    );
  }
}
