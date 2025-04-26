import 'package:flutter/material.dart';
import 'package:race_tracker/ui/screens/widgets/cards/activity_card.dart';

class RecentActivitySection extends StatelessWidget {
  final List<ActivityItem> activities;
  final int maxItems;
  final VoidCallback? onViewAllPressed;

  const RecentActivitySection({
    super.key,
    required this.activities,
    this.maxItems = 3,
    this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    final displayedActivities =
        activities.length > maxItems
            ? activities.sublist(0, maxItems)
            : activities;

    final hasMoreActivities = activities.length > maxItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (hasMoreActivities)
              TextButton(
                onPressed: onViewAllPressed,
                child: const Text(
                  'View All',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        ...displayedActivities.map(
          (activity) => ActivityCard(
            title: activity.title,
            time: activity.time,
            icon: activity.icon,
          ),
        ),
        if (hasMoreActivities && onViewAllPressed == null)
          _buildViewMoreButton(context),
      ],
    );
  }

  Widget _buildViewMoreButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Could navigate to full activity list screen here
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'View ${activities.length - maxItems} more',
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class ActivityItem {
  final String title;
  final String time;
  final IconData icon;

  const ActivityItem({
    required this.title,
    required this.time,
    required this.icon,
  });
}
