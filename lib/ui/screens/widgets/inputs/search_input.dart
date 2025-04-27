import 'package:flutter/material.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({super.key});

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(fontSize: 15, color: Colors.black),
          cursorColor: Colors.black,
          decoration: InputDecoration(
            hintText: 'Search races...',
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.6),
              fontSize: 15,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black.withOpacity(0.7),
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 4,
            ),
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
