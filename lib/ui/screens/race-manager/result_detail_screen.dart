import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker/data/repositories/firebase/race_repo_imp.dart';
import 'package:race_tracker/models/participant.dart';
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

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    setState(() => _loading = true);

    // fetch all participants
    final participants = context.read<ParticipantProvider>().participants;
    if (participants.isEmpty) {
      await context.read<ParticipantProvider>().fetchParticipants();
    }

    final List<ParticipantItem> parts =
        context.read<ParticipantProvider>().participants;
    final List<_ResultRow> rows = [];

    for (var p in parts) {
      // sum elapsed across segments
      final times = await _raceRepository.getSegmentTimes(
        raceId: widget.raceId,
        participantId: p.id,
      );
      final total = times.fold<int>(
        0,
        (sum, t) => sum + t.elapsedTimeInSeconds,
      );
      rows.add(_ResultRow(p, total));
    }
    // sort ascending (fastest first)
    rows.sort((a, b) => a.totalSeconds.compareTo(b.totalSeconds));

    setState(() {
      _rows = rows;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Race Results')),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Rankings',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      separatorBuilder: (_, __) => const Divider(),
                      itemCount: _rows.length,
                      itemBuilder: (ctx, i) {
                        final row = _rows[i];
                        final rankLabel = '${i + 1}${_suffix(i + 1)}';
                        final dur = Duration(seconds: row.totalSeconds);
                        final timestr = _format(dur);
                        return ListTile(
                          leading: CircleAvatar(child: Text(rankLabel)),
                          title: Text(row.participant.name),
                          subtitle: Text('BIB ${row.participant.bib}'),
                          trailing: Text(
                            timestr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
  _ResultRow(this.participant, this.totalSeconds);
}
