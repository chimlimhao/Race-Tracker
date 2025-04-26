import 'package:flutter/material.dart';
import 'package:race_tracker/ui/screens/widgets/cards/dashboard_race_card.dart';
import 'package:race_tracker/ui/screens/widgets/modals/activity_bottom_sheet.dart';
import 'package:race_tracker/ui/screens/widgets/sections/recent_activity_section.dart';
import 'package:race_tracker/ui/screens/widgets/sections/stats_summary_section.dart';
import 'package:race_tracker/ui/utils/status_chip.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Race Tracker'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Race card
                _buildCurrentRaceCard(),
                const SizedBox(height: 24),

                // Stats summary
                _buildStatsSummary(),
                const SizedBox(height: 32),

                // Recent activity
                _buildRecentActivity(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentRaceCard() {
    return DashboardRaceCard(
      title: 'Sensok Race',
      location: 'Phnom Penh, Cambodia',
      startTime: 'Started at 7:30 AM',
      status: Status.active,
      segments: const [
        SegmentInfo(distance: '750m', label: 'Swim'),
        SegmentInfo(distance: '20km', label: 'Bike'),
        SegmentInfo(distance: '5km', label: 'Run'),
      ],
    );
  }

  Widget _buildStatsSummary() {
    return const StatsSummarySection(
      participantsCount: '42',
      inProgressCount: '28',
      finishedCount: '14',
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    // Sample list with more activities than we want to display
    final activities = [
      ActivityItem(
        title: 'Limhao completed swim',
        time: '2 min ago',
        icon: Icons.pool_outlined,
      ),
      ActivityItem(
        title: 'Porchheng completed bike',
        time: '5 min ago',
        icon: Icons.directions_bike_outlined,
      ),
      ActivityItem(
        title: 'Gechleang finished race',
        time: '8 min ago',
        icon: Icons.flag_outlined,
      ),
      ActivityItem(
        title: 'Dara completed swim',
        time: '10 min ago',
        icon: Icons.pool_outlined,
      ),
      ActivityItem(
        title: 'Sokun completed bike',
        time: '12 min ago',
        icon: Icons.directions_bike_outlined,
      ),
      ActivityItem(
        title: 'Bopha completed swim',
        time: '15 min ago',
        icon: Icons.pool_outlined,
      ),
      ActivityItem(
        title: 'Chamroeun completed bike',
        time: '18 min ago',
        icon: Icons.directions_bike_outlined,
      ),
      ActivityItem(
        title: 'Sopheap finished race',
        time: '22 min ago',
        icon: Icons.flag_outlined,
      ),
    ];

    return RecentActivitySection(
      activities: activities,
      maxItems: 3, // Only show 3 activities on dashboard
      onViewAllPressed: () {
        // Show bottom sheet with all activities
        ActivityBottomSheet.show(context, activities);
      },
    );
  }
}
