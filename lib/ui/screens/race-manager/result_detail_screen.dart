import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker/data/repositories/firebase/race_repo_imp.dart';
import 'package:race_tracker/models/participant.dart';
import 'package:race_tracker/models/segment.dart';
import 'package:race_tracker/ui/providers/participant_provider.dart';

class ResultDetailScreen extends StatefulWidget {
  final String raceId;
  const ResultDetailScreen({super.key, required this.raceId});

  @override
  _ResultDetailScreenState createState() => _ResultDetailScreenState();
}

class _ResultDetailScreenState extends State<ResultDetailScreen> {
  final _raceRepository = FirebaseRaceRepository();
  bool _loading = true;
  List<_ResultRow> _rows = [];
  String _raceName = 'Race Results';

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    setState(() => _loading = true);

    try {
      // fetch all participants
      final participants = context.read<ParticipantProvider>().participants;
      if (participants.isEmpty) {
        await context.read<ParticipantProvider>().fetchParticipants();
      }

      final List<ParticipantItem> parts =
          context.read<ParticipantProvider>().participants;
      final List<_ResultRow> rows = [];

      // First, get the race to determine the segments order
      final race = await _raceRepository.getRace(widget.raceId);
      // Store race name for the title
      setState(() {
        _raceName = race.title;
      });

      final segmentOrder =
          race.segments.map((s) {
            return Segment.values.firstWhere(
              (seg) => seg.name.toLowerCase() == s.name.toLowerCase(),
              orElse: () => Segment.swimming,
            );
          }).toList();

      for (var p in parts) {
        // Get all segment times for this participant
        final times = await _raceRepository.getSegmentTimes(
          raceId: widget.raceId,
          participantId: p.id,
        );

        // If no times are recorded for this participant, skip
        if (times.isEmpty) continue;

        // Find the last recorded segment in order
        int lastCompletedSegmentIndex = -1;
        for (int i = segmentOrder.length - 1; i >= 0; i--) {
          final segmentTime = times.where((t) => t.segment == segmentOrder[i]);
          if (segmentTime.isNotEmpty) {
            lastCompletedSegmentIndex = i;
            break;
          }
        }

        // If no completed segments found, skip
        if (lastCompletedSegmentIndex == -1) continue;

        // Use the time from the last completed segment as total race time
        final lastSegmentTime = times.firstWhere(
          (t) => t.segment == segmentOrder[lastCompletedSegmentIndex],
        );
        final total = lastSegmentTime.elapsedTimeInSeconds;

        rows.add(
          _ResultRow(
            participant: p,
            totalSeconds: total,
            position: rows.length,
          ),
        );
      }

      // sort ascending (fastest first)
      rows.sort((a, b) => a.totalSeconds.compareTo(b.totalSeconds));

      // Update ranks after sorting
      for (int i = 0; i < rows.length; i++) {
        rows[i].rank = i + 1;
      }

      setState(() {
        _rows = rows;
        _loading = false;
      });
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading results: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_raceName)),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  _buildTableHeader(),
                  const Divider(height: 1, color: Color(0xffb3b3b3)),
                  Expanded(child: _buildResultsList()),
                ],
              ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: const [
          // Rank header
          SizedBox(
            width: 50,
            child: Text(
              'Rank',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          // Name header
          Expanded(
            flex: 5,
            child: Text(
              'Participant',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          // Time header
          Expanded(
            flex: 2,
            child: Text(
              'Time',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    if (_rows.isEmpty) {
      return const Center(
        child: Text(
          'No results available yet',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: _rows.length,
      separatorBuilder:
          (_, __) => const Divider(height: 1, color: Color(0xffe9e9e9)),
      itemBuilder: (context, i) {
        return _buildResultRow(_rows[i]);
      },
    );
  }

  Widget _buildResultRow(_ResultRow result) {
    final rankLabel = '${result.rank}${_suffix(result.rank)}';
    final timeStr = _format(Duration(seconds: result.totalSeconds));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Rank with position indicator
          SizedBox(
            width: 50,
            child: _buildRankIndicator(result.rank, rankLabel),
          ),

          // Participant name and BIB
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Text(
                  result.participant.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                _buildBibBadge(result.participant.bib),
              ],
            ),
          ),

          // Time
          Expanded(
            flex: 2,
            child: Text(
              timeStr,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankIndicator(int rank, String rankLabel) {
    final Color bgColor;
    final Color textColor = Colors.white;

    // Use light blue for top 3 positions, black for others
    if (rank <= 3) {
      bgColor = Colors.blue.shade200; // Light blue for top 3
    } else {
      bgColor = Colors.black; // Black for remaining positions
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
      child: Center(
        child: Text(
          rankLabel,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildBibBadge(String bib) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        bib,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _format(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String _suffix(int n) {
    if (n % 100 >= 11 && n % 100 <= 13) return 'th';
    switch (n % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}

class _ResultRow {
  final ParticipantItem participant;
  final int totalSeconds;
  int rank;

  _ResultRow({
    required this.participant,
    required this.totalSeconds,
    required int position,
  }) : rank = position + 1;
}
