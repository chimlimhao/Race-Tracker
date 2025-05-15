import 'package:flutter/material.dart';
import 'package:race_tracker/models/participant.dart';
import 'package:race_tracker/models/race.dart';
import 'package:race_tracker/models/segment.dart';
import 'package:race_tracker/data/repositories/firebase/firebase_service.dart';
import 'package:race_tracker/ui/screens/widgets/buttons/track_button.dart';
import 'package:race_tracker/ui/screens/widgets/modals/search_bottom_sheet.dart';

class RaceTrackingScreen extends StatefulWidget {
  final String raceId;
  final Segment segment;

  const RaceTrackingScreen({
    Key? key,
    required this.raceId,
    required this.segment,
  }) : super(key: key);

  @override
  State<RaceTrackingScreen> createState() => _RaceTrackingScreenState();
}

class _RaceTrackingScreenState extends State<RaceTrackingScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  final _service = FirebaseService();

  late Future<void> _initFuture;

  late int _raceStartMillis;
  List<ParticipantItem> _allParticipants = [];
  Set<String> _tracked = {};
  bool _isInitialized = false;

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
    await _loadRaceStartTime();
    await _loadParticipants();
    await _loadExistingSegmentTimes();
  }

  Future<void> _loadRaceStartTime() async {
    final race = await _service.getRace(widget.raceId);
    _raceStartMillis = race.startTime;
  }

  Future<void> _loadParticipants() async {
    _allParticipants = await _service.getAllParticipants();
  }

  Future<void> _loadExistingSegmentTimes() async {
    for (var p in _allParticipants) {
      final times = await _service.getSegmentTimes(
        raceId: widget.raceId,
        participantId: p.id,
      );
      if (times.any((t) => t.segment == widget.segment)) {
        _tracked.add(p.id);
      }
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _onParticipantTap(ParticipantItem p) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final elapsedSec = ((now - _raceStartMillis) / 1000).round();

    await _service.setSegmentTime(
      raceId: widget.raceId,
      participantId: p.id,
      segment: widget.segment,
      elapsedSeconds: elapsedSec,
    );

    setState(() {
      _tracked.add(p.id);
    });
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

        // Once loaded, build tabs
        final all = _allParticipants;
        final tracked = all.where((p) => _tracked.contains(p.id)).toList();

        return TabBarView(
          controller: _tabController,
          children: [
            _buildGrid(all, title: 'Participants (${all.length})'),
            _buildGrid(tracked, title: 'Tracked (${tracked.length})'),
          ],
        );
      },
    );
  }

  Widget _buildGrid(List<ParticipantItem> list, {required String title}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildGridHeader(title),
          const SizedBox(height: 12),
          Expanded(child: _buildGridView(list)),
        ],
      ),
    );
  }

  Widget _buildGridHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.search, size: 28),
          onPressed: () => SearchBottomSheet.show(context),
        ),
      ],
    );
  }

  Widget _buildGridView(List<ParticipantItem> list) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: list.length,
      itemBuilder: (_, i) => _buildGridItem(list[i]),
    );
  }

  Widget _buildGridItem(ParticipantItem participant) {
    final isTracked = _tracked.contains(participant.id);
    return TrackButton(
      isTracked: isTracked,
      bib: participant.bib,
      status: isTracked ? 'Done' : 'Tap to finish',
      onTap: isTracked ? null : () => _onParticipantTap(participant),
    );
  }
}
