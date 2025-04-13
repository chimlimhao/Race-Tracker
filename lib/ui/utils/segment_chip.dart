import 'package:flutter/material.dart';

class SegmentChip extends StatefulWidget {
  const SegmentChip({super.key});

  @override
  State<SegmentChip> createState() => _SegmentChipState();
}

class _SegmentChipState extends State<SegmentChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(4),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(50),
            ),
            width: 10,
            height: 10,
          ),
          SizedBox(width: 4),
          Text('Swimming', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
