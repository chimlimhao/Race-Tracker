import 'package:flutter/material.dart';

class QuickSearchWidget extends StatefulWidget {
  final Function(String) onSearch;
  final bool autoFocus;

  const QuickSearchWidget({
    super.key,
    required this.onSearch,
    this.autoFocus = true,
  });

  @override
  State<QuickSearchWidget> createState() => _QuickSearchWidgetState();
}

class _QuickSearchWidgetState extends State<QuickSearchWidget> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: widget.autoFocus,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  widget.onSearch(value);
                }
              },
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.grey.shade200,
                hintText: 'Enter BIB#',
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_searchController.text.isNotEmpty) {
                widget.onSearch(_searchController.text);
                _searchController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}

// The original bottom sheet is now simplified and primarily for display purposes
class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({super.key});

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();

  // Return the search result to caller
  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const SearchBottomSheet(),
    );
  }
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String bibNumber) {
    // Return the search value to the caller
    Navigator.pop(context, bibNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 24),
                child: Text(
                  'Quick Search',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          QuickSearchWidget(onSearch: _handleSearch, autoFocus: true),
        ],
      ),
    );
  }
}
