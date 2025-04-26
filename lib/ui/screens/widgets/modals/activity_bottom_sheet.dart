import 'package:flutter/material.dart';
import 'package:race_tracker/ui/screens/widgets/cards/activity_card.dart';
import 'package:race_tracker/ui/screens/widgets/sections/recent_activity_section.dart';

class ActivityBottomSheet extends StatelessWidget {
  final List<ActivityItem> activities;
  final String title;

  const ActivityBottomSheet({
    super.key,
    required this.activities,
    this.title = 'All Activities',
  });

  /// Shows the bottom sheet with all activities
  static void show(BuildContext context, List<ActivityItem> activities) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ActivityBottomSheet(activities: activities),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate height to take up to 70% of screen height
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomSheetHeight = screenHeight * 0.7;

    return Container(
      height: bottomSheetHeight,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHandle(),
          _buildHeader(context),
          Expanded(child: _buildActivityList()),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        height: 4,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList() {
    return activities.isEmpty
        ? const Center(child: Text('No activities'))
        : ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return ActivityCard(
              title: activity.title,
              time: activity.time,
              icon: activity.icon,
            );
          },
        );
  }
}
