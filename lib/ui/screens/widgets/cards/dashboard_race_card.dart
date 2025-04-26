import 'package:flutter/material.dart';
import 'package:race_tracker/ui/utils/status_chip.dart';

class DashboardRaceCard extends StatelessWidget {
  final String title;
  final String location;
  final String startTime;
  final Status status;
  final List<SegmentInfo> segments;

  const DashboardRaceCard({
    super.key,
    required this.title,
    required this.location,
    required this.startTime,
    required this.status,
    required this.segments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    StatusChip(status: status),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      startTime,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.black.withOpacity(0.1)),
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildSegmentWidgets(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSegmentWidgets() {
    final List<Widget> result = [];

    for (int i = 0; i < segments.length; i++) {
      if (i > 0) {
        result.add(_buildSegmentDivider());
      }
      result.add(_buildSegmentInfo(segments[i]));
    }

    return result;
  }

  Widget _buildSegmentDivider() {
    return Container(height: 24, width: 1, color: Colors.grey[100]);
  }

  Widget _buildSegmentInfo(SegmentInfo segment) {
    return Column(
      children: [
        Text(
          segment.distance,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          segment.label,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }
}

class SegmentInfo {
  final String distance;
  final String label;

  const SegmentInfo({required this.distance, required this.label});
}
