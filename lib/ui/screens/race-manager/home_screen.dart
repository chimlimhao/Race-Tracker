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
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);

    // Load data concurrently for efficiency
    await Future.wait([_loadRaces(), _loadParticipants()]);

    setState(() => _isLoading = false);
  }

  Future<void> _loadRaces() async {
    await context.read<RaceProvider>().fetchRaces();
  }

  Future<void> _loadParticipants() async {
    await context.read<ParticipantProvider>().fetchParticipants();
  }

  /// Get the most relevant race to display
  /// Priority: 1. Active races 2. Most recent created race 3. Most recently completed
  Race? _getLatestRace(List<Race> races) {
    if (races.isEmpty) return null;

    // First priority: Any active race (most recently started)
    final activeRaces =
        races.where((r) => r.raceStatus == RaceStatus.started).toList();
    if (activeRaces.isNotEmpty) {
      activeRaces.sort((a, b) => b.startTime.compareTo(a.startTime));
      return activeRaces.first;
    }

    // Second priority: Pending races (most recently created)
    final pendingRaces =
        races.where((r) => r.raceStatus == RaceStatus.notStarted).toList();
    if (pendingRaces.isNotEmpty) {
      pendingRaces.sort((a, b) => b.date.compareTo(a.date));
      return pendingRaces.first;
    }

    // Third priority: Completed races (most recently finished)
    final completedRaces =
        races.where((r) => r.raceStatus == RaceStatus.finished).toList();
    if (completedRaces.isNotEmpty) {
      completedRaces.sort((a, b) => b.endTime.compareTo(a.endTime));
      return completedRaces.first;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final raceProv = context.watch<RaceProvider>();
    final races = raceProv.races;
    final latestRace = _getLatestRace(races);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(latestRace),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Race Tracker'),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    );
  }

  Widget _buildBody(Race? latestRace) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadInitialData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeaturedRaceCard(latestRace),
                const SizedBox(height: 24),
                _buildStatsSummary(),
                const SizedBox(height: 32),
                _buildRecentActivity(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedRaceCard(Race? race) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (race == null) {
      return const Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No races yet. Tap + to create your first race.',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return DashboardRaceCard(
      title: race.title,
      location: race.location,
      startTime: 'Scheduled: ${DateFormat('dd MMM, yyyy').format(race.date)}',
      status: _mapStatus(race.raceStatus),
      segments:
          race.segments.map((seg) {
            return SegmentInfo(distance: seg.distance, label: seg.name);
          }).toList(),
    );
  }

  Status _mapStatus(RaceStatus rs) {
    switch (rs) {
      case RaceStatus.notStarted:
        return Status.pending;
      case RaceStatus.started:
        return Status.active;
      case RaceStatus.finished:
        return Status.completed;
    }
  }

  Widget _buildStatsSummary() {
    final participantProvider = context.watch<ParticipantProvider>();
    final raceProvider = context.watch<RaceProvider>();

    final partCount = participantProvider.participants.length.toString();
    final inProg =
        raceProvider.races
            .where((r) => r.raceStatus == RaceStatus.started)
            .length
            .toString();
    final finished =
        raceProvider.races
            .where((r) => r.raceStatus == RaceStatus.finished)
            .length
            .toString();

    return StatsSummarySection(
      participantsCount: partCount,
      inProgressCount: inProg,
      finishedCount: finished,
    );
  }

  Widget _buildRecentActivity() {
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
      onViewAllPressed: () => _showAllActivities(activities),
    );
  }

  void _showAllActivities(List<ActivityItem> activities) {
    ActivityBottomSheet.show(context, activities);
  }
}
