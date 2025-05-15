import 'package:flutter/material.dart';
import 'package:race_tracker/models/segment.dart';


/// Dynamic segments list that navigates to tracking
class RaceSegments extends StatelessWidget {
  final List<SegmentModel> segments;
  final void Function(SegmentModel) onTap;

  const RaceSegments({
    Key? key,
    required this.segments,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text(
          //   'Segments',
          //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          // ),
          // const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: segments.map((seg) {
              return InkWell(
                onTap: () => onTap(seg),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    seg.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
