import 'package:flutter/material.dart';

class RaceDetailCard extends StatefulWidget {
  const RaceDetailCard({super.key});

  @override
  State<RaceDetailCard> createState() => _RaceDetailCardState();
}

class _RaceDetailCardState extends State<RaceDetailCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(24),
      padding: EdgeInsets.all(16),
      width: double.infinity,
      height: 125,
      decoration: BoxDecoration(
        color: Color(0xFFD9D9D9),
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.access_time_outlined, size: 38),
            SizedBox(width: 12),
            Text(
              '00:00:00',
              style: TextStyle(fontSize: 38, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
