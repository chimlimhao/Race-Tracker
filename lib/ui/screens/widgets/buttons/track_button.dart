import 'package:flutter/material.dart';

class TrackButton extends StatefulWidget {
  final VoidCallback? onTap;

  final bool isTracked;
  final String status;
  final String bib;
  const TrackButton({
    super.key,
    required this.isTracked,
    required this.onTap,
    required this.status,
    required this.bib,
  });

  @override
  State<TrackButton> createState() => _TrackButtonState();
}

class _TrackButtonState extends State<TrackButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.isTracked ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              widget.bib,
              style: TextStyle(
                color: widget.isTracked ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              widget.status,
              style: TextStyle(
                color: widget.isTracked ? Color(0xff3CFF00) : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
