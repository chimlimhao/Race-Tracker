import 'package:flutter/material.dart';

enum Status { pending, active, completed }

class StatusChip extends StatefulWidget {
  final Status status;

  const StatusChip({super.key, this.status = Status.pending});

  @override
  State<StatusChip> createState() => _StatusChipState();
}

class _StatusChipState extends State<StatusChip> {
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
        return Colors.orange;
      case Status.active:
        return Colors.green;
      case Status.completed:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: getStatusColor(widget.status)),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        getStatusText(widget.status),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: getStatusColor(widget.status),
        ),
      ),
    );
  }
}
