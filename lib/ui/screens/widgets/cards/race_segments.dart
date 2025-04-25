import 'package:flutter/material.dart';

class RaceSegments extends StatefulWidget {
  final Function() onTap;
  const RaceSegments({super.key, required this.onTap});

  @override
  State<RaceSegments> createState() => _RaceSegmentsState();
}

class _RaceSegmentsState extends State<RaceSegments> {
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
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 125,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/swimming.png',
                        height: 25,
                        width: 25,
                      ),
                      SizedBox(width: 5),
                      Text('Swimming'),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: widget.onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 125,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/cycling.png',
                        height: 25,
                        width: 25,
                      ),
                      SizedBox(width: 5),
                      Text('Cycling'),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: widget.onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 125,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/running.png',
                        height: 25,
                        width: 25,
                      ),
                      SizedBox(width: 5),
                      Text('Running'),
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
