import 'package:flutter/material.dart';
import 'package:race_tracker/models/participant.dart';

class QuickSearchWidget extends StatefulWidget {
  final Function(String) onSearch;
  final bool autoFocus;
  final String? initialQuery;
  final String hintText;

  const QuickSearchWidget({
    super.key,
    required this.onSearch,
    this.autoFocus = true,
    this.initialQuery,
    this.hintText = 'Enter BIB#',
  });

  @override
  State<QuickSearchWidget> createState() => _QuickSearchWidgetState();
}

class _QuickSearchWidgetState extends State<QuickSearchWidget> {
  late final TextEditingController _searchController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);

    // Trigger search on initial value if provided
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSearch(_searchController.text);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSearch() {
    if (_searchController.text.isNotEmpty) {
      widget.onSearch(_searchController.text);
      FocusScope.of(context).unfocus();
    }
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
              focusNode: _focusNode,
              autofocus: widget.autoFocus,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                // Trigger search as user types
                widget.onSearch(value);
              },
              onSubmitted: (_) => _handleSearch(),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.grey.shade200,
                hintText: widget.hintText,
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            widget.onSearch('');
                            _focusNode.requestFocus();
                          },
                        )
                        : null,
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
          IconButton(icon: const Icon(Icons.search), onPressed: _handleSearch),
        ],
      ),
    );
  }
}

class SearchBottomSheet extends StatefulWidget {
  final List<ParticipantItem> participants;
  final Function(ParticipantItem) onParticipantSelected;
  final String? initialQuery;

  const SearchBottomSheet({
    super.key,
    required this.participants,
    required this.onParticipantSelected,
    this.initialQuery,
  });

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();

  // Show the search modal and handle the selection
  static Future<void> show(
    BuildContext context, {
    required List<ParticipantItem> participants,
    required Function(ParticipantItem) onParticipantSelected,
    String? initialQuery,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 300),
            child: SearchBottomSheet(
              participants: participants,
              onParticipantSelected: onParticipantSelected,
              initialQuery: initialQuery,
            ),
          ),
    );
  }
}

class _SearchBottomSheetState extends State<SearchBottomSheet>
    with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  List<ParticipantItem> _filteredParticipants = [];
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _filteredParticipants = widget.participants;

    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuart,
    );

    _animationController.forward();

    // Set initial query if provided
    if (widget.initialQuery != null) {
      _searchQuery = widget.initialQuery!;
      _updateFilteredList();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    setState(() {
      _isLoading = true;
    });

    // Use a small delay to debounce rapid typing
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _searchQuery = query.trim().toLowerCase();
          _updateFilteredList();
          _isLoading = false;
        });
      }
    });
  }

  void _updateFilteredList() {
    if (_searchQuery.isEmpty) {
      _filteredParticipants = widget.participants;
    } else {
      _filteredParticipants =
          widget.participants
              .where(
                (p) =>
                    p.bib.toLowerCase().contains(_searchQuery) ||
                    p.name.toLowerCase().contains(_searchQuery),
              )
              .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      axisAlignment: -1.0,
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 5),
          ],
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              QuickSearchWidget(
                onSearch: _handleSearch,
                autoFocus: true,
                initialQuery: widget.initialQuery,
                hintText: 'Search by BIB or name',
              ),
              _buildResultsHeader(),
              Expanded(
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildResultsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 24, right: 12, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Quick Search',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _animationController.reverse().then((_) {
                Navigator.pop(context);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Results: ${_filteredParticipants.length}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          if (_filteredParticipants.isNotEmpty)
            TextButton.icon(
              icon: const Icon(Icons.sort, size: 16),
              label: const Text('Sort by BIB'),
              onPressed: _sortParticipants,
              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
            ),
        ],
      ),
    );
  }

  void _sortParticipants() {
    setState(() {
      _filteredParticipants.sort(
        (a, b) =>
            int.tryParse(a.bib) != null && int.tryParse(b.bib) != null
                ? int.parse(a.bib).compareTo(int.parse(b.bib))
                : a.bib.compareTo(b.bib),
      );
    });
  }

  Widget _buildResultsList() {
    if (_filteredParticipants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty
                  ? 'No participants available'
                  : 'No results found for "$_searchQuery"',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredParticipants.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final participant = _filteredParticipants[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.black,
            child: Text(
              participant.bib,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(
            participant.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(participant.gender.name),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            _animationController.reverse().then((_) {
              Navigator.pop(context);
              widget.onParticipantSelected(participant);
            });
          },
        );
      },
    );
  }
}
