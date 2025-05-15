// home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:race_tracker/models/race.dart';
import 'package:race_tracker/ui/providers/participant_provider.dart';
import 'package:race_tracker/ui/providers/race_provider.dart';
import 'package:race_tracker/ui/screens/widgets/cards/dashboard_race_card.dart';

import 'package:race_tracker/ui/screens/widgets/modals/activity_bottom_sheet.dart';
import 'package:race_tracker/ui/screens/widgets/sections/recent_activity_section.dart';
import 'package:race_tracker/ui/screens/widgets/sections/stats_summary_section.dart';
import 'package:race_tracker/ui/utils/status_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load all races so we can pick the last created
    Future.microtask(() => context.read<RaceProvider>().fetchRaces());
    // Optionally load participants if needed for stats
    Future.microtask(() => context.read<ParticipantProvider>().fetchParticipants());
  }

  @override
  Widget build(BuildContext context) {
    final raceProv = context.watch<RaceProvider>();
    final races    = raceProv.races;
    final loading  = raceProv.loading;

    final lastRace = races.isNotEmpty ? races.last : null;

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
                // Last created race card
                if (loading)
                  const Center(child: CircularProgressIndicator())
                else if (lastRace != null)
                  DashboardRaceCard(
                    title: lastRace.title,
                    location: lastRace.location,
                    startTime: 'Scheduled: ${DateFormat('dd MMM, yyyy').format(lastRace.date)}',
                    status: _mapStatus(lastRace.raceStatus),
                    segments: lastRace.segments.map((seg) {
                      return SegmentInfo(
                        distance: seg.distance,
                        label: seg.name,
                      );
                    }).toList(),
                  )
                else
                  const Text(
                    'No races yet. Tap + to create your first race.',
                    style: TextStyle(fontSize: 16),
                  ),

                const SizedBox(height: 24),

                // Stats summary
                _buildStatsSummary(context),
                const SizedBox(height: 32),

                // Recent activity
                // _buildRecentActivity(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Status _mapStatus(RaceStatus rs) {
    switch (rs) {
      case RaceStatus.notStarted:
        return Status.pending;
      case RaceStatus.started:
        return Status.active;
      case RaceStatus.finished:
      default:
        return Status.completed;
    }
  }

  Widget _buildStatsSummary(BuildContext context) {
    final partCount = context.watch<ParticipantProvider>().participants.length;
    final inProg = context
        .watch<RaceProvider>()
        .races
        .where((r) => r.raceStatus == RaceStatus.started)
        .length.toString();
    final finished = context
        .watch<RaceProvider>()
        .races
        .where((r) => r.raceStatus == RaceStatus.finished)
        .length.toString();

    return StatsSummarySection(
      participantsCount: partCount.toString(),
      inProgressCount: inProg,
      finishedCount: finished,
    );
  }

  // Widget _buildRecentActivity(BuildContext context) {
  //   final activities = context.watch<ActivityProvider>().recentActivities;
  //   return RecentActivitySection(
  //     activities: activities,
  //     maxItems: 3,
  //     onViewAllPressed: () {
  //       ActivityBottomSheet.show(context, activities);
  //     },
  //   );
  // }
}
