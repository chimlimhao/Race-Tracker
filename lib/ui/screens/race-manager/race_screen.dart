import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker/models/race.dart';
import 'package:race_tracker/ui/providers/race_provider.dart';
import 'package:race_tracker/ui/screens/race-manager/race_detail_screen.dart';
import 'package:race_tracker/ui/screens/widgets/cards/race_card.dart';
import 'package:race_tracker/ui/screens/widgets/modals/race_bottom_sheet.dart';

class RaceScreen extends StatefulWidget {
  const RaceScreen({Key? key}) : super(key: key);

  @override
  _RaceScreenState createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  bool _isInitialized = false;

  // MARK: - Lifecycle Methods

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _tabController = TabController(length: 3, vsync: this);
      _fetchRaces();
      _isInitialized = true;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh races when app comes to foreground
      _fetchRaces();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController?.dispose();
    super.dispose();
  }

  // MARK: - Data Methods

  void _fetchRaces() {
    Future.microtask(() => context.read<RaceProvider>().fetchRaces());
  }

  List<Race> _sortPendingRaces(List<Race> races) {
    races.sort((a, b) => b.date.compareTo(a.date));
    return races;
  }

  List<Race> _sortActiveRaces(List<Race> races) {
    races.sort((a, b) => b.startTime.compareTo(a.startTime));
    return races;
  }

  List<Race> _sortCompletedRaces(List<Race> races) {
    races.sort((a, b) => b.endTime.compareTo(a.endTime));
    return races;
  }

  // MARK: - UI Building

  @override
  Widget build(BuildContext context) {
    if (_tabController == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final raceProv = context.watch<RaceProvider>();
    final races = raceProv.races;
    final loading = raceProv.loading;

    // Filter races by status
    final pendingRaces = _sortPendingRaces(
      races.where((r) => r.raceStatus == RaceStatus.notStarted).toList(),
    );

    final activeRaces = _sortActiveRaces(
      races.where((r) => r.raceStatus == RaceStatus.started).toList(),
    );

    final completedRaces = _sortCompletedRaces(
      races.where((r) => r.raceStatus == RaceStatus.finished).toList(),
    );

    return Scaffold(
      appBar: _buildAppBar(),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: () async {
                  await context.read<RaceProvider>().fetchRaces();
                },
                child: _buildTabBarView(
                  pendingRaces,
                  activeRaces,
                  completedRaces,
                ),
              ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('All Races'),
      actions: [
        IconButton(icon: const Icon(Icons.add), onPressed: _showAddRaceModal),
      ],
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Pending'),
          Tab(text: 'Active'),
          Tab(text: 'Completed'),
        ],
      ),
    );
  }

  Widget _buildTabBarView(
    List<Race> pendingRaces,
    List<Race> activeRaces,
    List<Race> completedRaces,
  ) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildRaceList(pendingRaces),
        _buildRaceList(activeRaces),
        _buildRaceList(completedRaces),
      ],
    );
  }

  Widget _buildRaceList(List<Race> races) {
    if (races.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No races found in this category.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: races.length,
      separatorBuilder:
          (_, __) => const Divider(height: 1, color: Color(0xffe9e9e9)),
      padding: EdgeInsets.zero,
      itemBuilder: (ctx, i) => _buildRaceItem(races[i]),
    );
  }

  Widget _buildRaceItem(Race race) {
    return Dismissible(
      key: ValueKey(race.id),
      background: _buildDismissibleBackground(alignment: Alignment.centerLeft),
      secondaryBackground: _buildDismissibleBackground(
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (direction) => _confirmDismiss(race),
      onDismissed: (_) => _deleteRace(race),
      child: RaceCard(
        race: race,
        participantCount: race.segments.length,
        onTap: () => _navigateToRaceDetail(race.id),
      ),
    );
  }

  Widget _buildDismissibleBackground({required Alignment alignment}) {
    return Container(
      color: Colors.red.shade700,
      alignment: alignment,
      padding: EdgeInsets.only(
        left: alignment == Alignment.centerLeft ? 20 : 0,
        right: alignment == Alignment.centerRight ? 20 : 0,
      ),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  // MARK: - Actions and Navigation

  Future<void> _showAddRaceModal() async {
    await RaceBottomSheet.show(context);
    if (mounted) {
      await context.read<RaceProvider>().fetchRaces();
      _tabController?.animateTo(0);
    }
  }

  Future<bool> _confirmDismiss(Race race) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: const Text('Delete Race?'),
                content: Text(
                  'Are you sure you want to delete "${race.title}"?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Delete'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  void _deleteRace(Race race) {
    context.read<RaceProvider>().deleteRace(race.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${race.title}"'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToRaceDetail(String raceId) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => RaceDetailScreen(raceId: raceId)));
  }
}
