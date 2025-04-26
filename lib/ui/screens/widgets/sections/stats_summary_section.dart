import 'package:flutter/material.dart';
import 'package:race_tracker/ui/screens/widgets/cards/stat_card.dart';

class StatsSummarySection extends StatelessWidget {
  final String participantsCount;
  final String inProgressCount;
  final String finishedCount;

  const StatsSummarySection({
    super.key,
    required this.participantsCount,
    required this.inProgressCount,
    required this.finishedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            value: participantsCount,
            label: 'Participants',
            icon: Icons.people_alt_outlined,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            value: inProgressCount,
            label: 'In Progress',
            icon: Icons.directions_run_outlined,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            value: finishedCount,
            label: 'Finished',
            icon: Icons.flag_outlined,
          ),
        ),
      ],
    );
  }
}
