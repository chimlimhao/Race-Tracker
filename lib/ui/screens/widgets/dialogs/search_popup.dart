import 'package:flutter/material.dart';

class SearchPopup extends StatelessWidget {
  const SearchPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text('Search', style: TextStyle(fontSize: 24)),
          Spacer(),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close, size: 24),
          ),
        ],
      ),
      content: TextField(decoration: InputDecoration(hintText: 'Enter BIB')),
      actions: [
        TextButton(
          onPressed: () {
            // TODO: Handle search
            Navigator.pop(context);
          },
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black,
              ),
              width: 200,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Search',
                style: TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
