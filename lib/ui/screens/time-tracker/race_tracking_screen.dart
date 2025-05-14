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
  late final TabController _tabController;
  final _service = FirebaseService();

  late Future<void> _initFuture;

  late int _raceStartMillis;
  List<ParticipantItem> _allParticipants = [];
  Set<String> _tracked = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initFuture = _loadData();
  }

  Future<void> _loadData() async {
    // 1) fetch race to get startTime
    final race = await _service.getRace(widget.raceId);
    _raceStartMillis = race.startTime;

    // 2) load participants
    _allParticipants = await _service.getAllParticipants();

    // 3) load existing segmentTimes for each participant
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
    _tabController.dispose();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Track ${widget.segment.name}'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'All'), Tab(text: 'Tracked')],
        ),
      ),
      body: FutureBuilder<void>(
        future: _initFuture,
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
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
      ),
    );
  }

  Widget _buildGrid(List<ParticipantItem> list, {required String title}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Text(title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              Spacer(),
              IconButton(
                icon: Icon(Icons.search, size: 28),
                onPressed: () => SearchBottomSheet.show(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final p = list[i];
                final isTracked = _tracked.contains(p.id);
                return TrackButton(
                  isTracked: isTracked,
                  bib: p.bib,
                  status: isTracked ? 'Done' : 'Tap to finish',
                  onTap: isTracked ? null : () => _onParticipantTap(p),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
