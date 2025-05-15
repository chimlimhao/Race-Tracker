import 'package:flutter/material.dart';
import 'package:race_tracker/models/participant.dart';
import 'package:race_tracker/models/segment.dart';
import 'package:race_tracker/data/repositories/firebase/race_repo_imp.dart';
import 'package:race_tracker/data/repositories/firebase/participant_repo_imp.dart';
import 'package:race_tracker/ui/screens/widgets/buttons/track_button.dart';
import 'package:race_tracker/ui/screens/widgets/modals/search_bottom_sheet.dart';

class RaceTrackingScreen extends StatefulWidget {
  final String raceId;
  final Segment segment;

  const RaceTrackingScreen({
    super.key,
    required this.raceId,
    required this.segment,
  });

  @override
  State<RaceTrackingScreen> createState() => _RaceTrackingScreenState();
}

class _RaceTrackingScreenState extends State<RaceTrackingScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  final _raceRepository = FirebaseRaceRepository();
  final _participantRepository = FirebaseParticipantRepository();

  late Future<void> _initFuture;
  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';

  late int _raceStartMillis;
  final List<ParticipantItem> _allParticipants = [];
  final Set<String> _tracked = {};

  @override
  void initState() {
    super.initState();
    _initFuture = _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _tabController = TabController(length: 2, vsync: this);
      _isInitialized = true;
    }
  }

  Future<void> _loadData() async {
    try {
      await Future.wait([_loadRaceStartTime(), _loadParticipants()]);

      // Load segment times after participants are loaded
      await _loadExistingSegmentTimes();

      setState(() {
        _hasError = false;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _loadRaceStartTime() async {
    try {
      final race = await _raceRepository.getRace(widget.raceId);
      _raceStartMillis = race.startTime;
    } catch (e) {
      throw Exception('Failed to load race: $e');
    }
  }

  Future<void> _loadParticipants() async {
    try {
      _allParticipants.addAll(
        await _participantRepository.getAllParticipants(),
      );
    } catch (e) {
      throw Exception('Failed to load participants: $e');
    }
  }

  Future<void> _loadExistingSegmentTimes() async {
    for (var p in _allParticipants) {
      try {
        final times = await _raceRepository.getSegmentTimes(
          raceId: widget.raceId,
          participantId: p.id,
        );
        if (times.any((t) => t.segment == widget.segment)) {
          _tracked.add(p.id);
        }
      } catch (e) {
        // Continue loading others even if one fails
        debugPrint('Error loading times for participant ${p.id}: $e');
      }
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _onParticipantTap(ParticipantItem p) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      final elapsedSec = ((now - _raceStartMillis) / 1000).round();

      await _raceRepository.setSegmentTime(
        raceId: widget.raceId,
        participantId: p.id,
        segment: widget.segment,
        elapsedSeconds: elapsedSec,
      );

      setState(() {
        _tracked.add(p.id);
      });
    } catch (e) {
      _showErrorSnackBar('Failed to track participant: $e');
    }
  }

  Future<void> _onUntrackParticipant(ParticipantItem p) async {
    try {
      await _raceRepository.removeSegmentTime(
        raceId: widget.raceId,
        participantId: p.id,
        segment: widget.segment,
      );

      setState(() {
        _tracked.remove(p.id);
      });
    } catch (e) {
      _showErrorSnackBar('Failed to untrack participant: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSearchBottomSheet(bool isTrackedTab) {
    final participants =
        isTrackedTab
            ? _allParticipants.where((p) => _tracked.contains(p.id)).toList()
            : _allParticipants;

    SearchBottomSheet.show(
      context,
      participants: participants,
      onParticipantSelected: (participant) {
        if (isTrackedTab) {
          // In tracked tab, handle untracking
          if (_tracked.contains(participant.id)) {
            _onUntrackParticipant(participant);
          }
        } else {
          // In all tab, handle tracking if not already tracked
          if (!_tracked.contains(participant.id)) {
            _onParticipantTap(participant);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_tabController == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Track ${widget.segment.name}'),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh data',
          onPressed: () {
            setState(() {
              _initFuture = _loadData();
            });
          },
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        tabs: const [Tab(text: 'All'), Tab(text: 'Tracked')],
      ),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_hasError) {
          return _buildErrorWidget();
        }

        // Once loaded, build tabs
        final all = _allParticipants;
        final tracked = all.where((p) => _tracked.contains(p.id)).toList();

        return TabBarView(
          controller: _tabController,
          children: [
            _buildGrid(
              all,
              title: 'Participants (${all.length})',
              isTrackedTab: false,
            ),
            _buildGrid(
              tracked,
              title: 'Tracked (${tracked.length})',
              isTrackedTab: true,
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              'Failed to load data',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _initFuture = _loadData();
                });
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(
    List<ParticipantItem> list, {
    required String title,
    required bool isTrackedTab,
  }) {
    if (list.isEmpty) {
      return _buildEmptyState(isTrackedTab);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildGridHeader(title, isTrackedTab),
          const SizedBox(height: 12),
          Expanded(child: _buildGridView(list, isTrackedTab: isTrackedTab)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isTrackedTab) {
    final message =
        isTrackedTab
            ? 'No tracked participants yet'
            : 'No participants available';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isTrackedTab ? Icons.flag_outlined : Icons.person_outline,
            size: 60,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          if (!isTrackedTab)
            ElevatedButton(
              onPressed: () {
                // Navigate to participant creation screen
                // or show modal to add participants
              },
              child: const Text('Add Participants'),
            ),
        ],
      ),
    );
  }

  Widget _buildGridHeader(String title, bool isTrackedTab) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.search, size: 28),
          onPressed: () => _showSearchBottomSheet(isTrackedTab),
        ),
      ],
    );
  }

  Widget _buildGridView(
    List<ParticipantItem> list, {
    required bool isTrackedTab,
  }) {
    // Calculate grid size based on screen width
    final screenSize = MediaQuery.of(context).size;
    final crossAxisCount = _calculateCrossAxisCount(screenSize.width);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.0,
        crossAxisSpacing: 8,
        mainAxisSpacing: 12,
      ),
      itemCount: list.length,
      itemBuilder:
          (_, i) => _buildGridItem(list[i], isTrackedTab: isTrackedTab),
    );
  }

  // Calculate how many items can fit per row based on screen width
  int _calculateCrossAxisCount(double screenWidth) {
    // For larger screens, show more items in a row
    if (screenWidth > 600) {
      return 6; // Tablet
    } else if (screenWidth > 400) {
      return 4; // Medium phones
    } else {
      return 3; // Small phones
    }
  }

  Widget _buildGridItem(
    ParticipantItem participant, {
    required bool isTrackedTab,
  }) {
    final isTracked = _tracked.contains(participant.id);

    // Handle tap based on which tab we're in
    VoidCallback? onTap;

    if (isTrackedTab) {
      // In tracked tab, tapping should untrack
      onTap = isTracked ? () => _onUntrackParticipant(participant) : null;
    } else {
      // In all tab, tapping should track (if not already)
      onTap = isTracked ? null : () => _onParticipantTap(participant);
    }

    // Determine the status text based on context
    String statusText;
    if (isTracked) {
      statusText = isTrackedTab ? 'Tap to remove' : 'Finish';
    } else {
      statusText = 'Tap to finish';
    }

    // Wrap in a SizedBox to ensure consistent minimum size
    return SizedBox(
      width: 70,
      height: 70,
      child: TrackButton(
        isTracked: isTracked,
        bib: participant.bib,
        status: statusText,
        onTap: onTap,
      ),
    );
  }
}
