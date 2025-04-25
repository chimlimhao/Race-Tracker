import 'package:flutter/material.dart';
import 'package:race_tracker/models/participant.dart';
import 'package:race_tracker/ui/screens/widgets/buttons/track_button.dart';
import 'package:race_tracker/ui/screens/widgets/dialogs/search_popup.dart';

class RaceTrackingScreen extends StatefulWidget {
  const RaceTrackingScreen({super.key});

  @override
  State<RaceTrackingScreen> createState() => _RaceTrackingScreenState();
}

class _RaceTrackingScreenState extends State<RaceTrackingScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  // Sample data
  final List<ParticipantItem> _participants = List.generate(
    15, // Generate 15 sample items
    (index) => ParticipantItem(
      name: 'Participant $index',
      gender: Gender.male,
      isTracked: false,
      status: 'Finish',
      bib: '${1000 + index}',
    ),
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void onParticipantTap(ParticipantItem participant) {
    setState(() {
      participant.isTracked = !participant.isTracked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Race Tracking'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [Tab(text: 'Active'), Tab(text: 'Tracked')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Active tab - shows all participants
          _buildParticipantTab(
            title: 'Participant (${_participants.length}):',
            participants: _participants,
          ),

          // Tracked tab - shows only tracked participants
          _buildParticipantTab(
            title:
                'Participant Tracked (${_participants.where((p) => p.isTracked).length}):',
            participants: _participants.where((p) => p.isTracked).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantTab({
    required String title,
    required List<ParticipantItem> participants,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Spacer(),
              IconButton(
                onPressed:
                    () => showDialog(
                      context: context,
                      builder: (context) => SearchPopup(),
                      barrierDismissible: true,
                    ),
                icon: Icon(Icons.search, size: 32),
              ),
            ],
          ),
          SizedBox(height: 12),

          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: participants.length,
              itemBuilder: (context, index) {
                final item = participants[index];
                return TrackButton(
                  isTracked: item.isTracked,
                  onTap: () {
                    onParticipantTap(item);
                  },
                  status: item.status,
                  bib: item.bib,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
