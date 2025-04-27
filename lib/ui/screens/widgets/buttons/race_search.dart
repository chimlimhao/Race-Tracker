import 'package:flutter/material.dart';

class RaceSearch extends StatefulWidget {
  const RaceSearch({super.key});

  @override
  State<RaceSearch> createState() => _RaceSearchState();
}

class _RaceSearchState extends State<RaceSearch> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search races...',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 15),
          ),
          onChanged: (value) {
            // You can implement search logic here
            print('Searching for: $value');
          },
        ),
      ),
    );
  }
}
