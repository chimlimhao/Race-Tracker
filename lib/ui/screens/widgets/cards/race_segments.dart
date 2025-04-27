import 'package:flutter/material.dart';

class RaceSegments extends StatefulWidget {
  final Function() onTap;
  const RaceSegments({super.key, required this.onTap});

  @override
  State<RaceSegments> createState() => _RaceSegmentsState();
}

class _RaceSegmentsState extends State<RaceSegments> {
  final List<String> segments = ['Swimming', 'Cycling', 'Running'];
  final List<String> icons = [
    'assets/icons/swimming.png',
    'assets/icons/cycling.png',
    'assets/icons/running.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Segments',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: widget.onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 125,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        icons[0],
                        height: 25,
                        width: 25,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      Text(segments[0], style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: widget.onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 125,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        icons[1],
                        height: 25,
                        width: 25,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      Text(segments[1], style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: widget.onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 125,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        icons[2],
                        height: 25,
                        width: 25,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      Text(segments[2], style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
