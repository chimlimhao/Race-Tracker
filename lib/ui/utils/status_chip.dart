import 'package:flutter/material.dart';

enum Status { pending, active, completed }

class StatusChip extends StatelessWidget {
  final Status status;

  const StatusChip({super.key, this.status = Status.pending});

  String getStatusText(Status status) {
    switch (status) {
      case Status.pending:
        return 'Pending';
      case Status.active:
        return 'Active';
      case Status.completed:
        return 'Completed';
    }
  }

  Color getStatusColor(Status status) {
    switch (status) {
      case Status.pending:
        return const Color(0xFFFF9800); // Orange
      case Status.active:
        return const Color(0xFF2196F3); // Blue
      case Status.completed:
        return const Color(0xFF4CAF50); // Green
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getStatusColor(status);

    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        getStatusText(status),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
