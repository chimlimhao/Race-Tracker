import 'package:flutter/material.dart';

class SearchInput extends StatefulWidget {
  final String hintText;
  final Function(String) onChanged;

  const SearchInput({
    super.key,
    this.hintText = 'Search...',
    required this.onChanged,
  });

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
    return Container(
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
          hintText: widget.hintText,
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
          widget.onChanged(value);
        },
      ),
    );
  }
}
