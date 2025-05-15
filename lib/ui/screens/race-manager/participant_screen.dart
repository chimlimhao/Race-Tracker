import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker/models/participant.dart';
import 'package:race_tracker/ui/providers/participant_provider.dart';
import 'package:race_tracker/ui/screens/widgets/inputs/search_input.dart';
import 'package:race_tracker/ui/screens/widgets/modals/participant_bottom_sheet.dart';
import 'package:race_tracker/ui/screens/widgets/modals/search_bottom_sheet.dart';

class ParticipantScreen extends StatefulWidget {
  const ParticipantScreen({Key? key}) : super(key: key);

  @override
  State<ParticipantScreen> createState() => _ParticipantScreenState();
}

class _ParticipantScreenState extends State<ParticipantScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load participants after first frame
    Future.microtask(
      () => context.read<ParticipantProvider>().fetchParticipants(),
    );
  }

  void _quickSearch(String bib) {
    setState(() {
      _searchQuery = bib;
    });
  }

  String _capitalizeFirst(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParticipantProvider>();
    final participants = provider.participants;

    // Filter participants based on search query
    final filteredParticipants =
        _searchQuery.isEmpty
            ? participants
            : participants
                .where(
                  (p) =>
                      p.name.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      ) ||
                      p.bib.toLowerCase().contains(_searchQuery.toLowerCase()),
                )
                .toList();

    final loading = provider.loading;

    return Scaffold(
      appBar: _buildAppBar(),
      // floatingActionButton: _buildFloatingSearchButton(),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  _buildSearchBar(),
                  _buildTableHeader(),
                  const Divider(height: 1, color: Color(0xffb3b3b3)),
                  Expanded(child: _buildParticipantsList(filteredParticipants)),
                ],
              ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Participants'),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            await ParticipantBottomSheet.show(context);
            await context.read<ParticipantProvider>().fetchParticipants();
          },
        ),
      ],
    );
  }

  // Widget _buildFloatingSearchButton() {
  //   return FloatingActionButton(
  //     backgroundColor: Colors.black,
  //     child: const Icon(Icons.search, color: Colors.white),
  //     onPressed: () async {
  //       final result = await SearchBottomSheet.show(context);
  //       if (result != null && result is String) {
  //         _quickSearch(result);
  //       }
  //     },
  //   );
  // }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SearchInput(
        hintText: 'Search participants...',
        onChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
      ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Name header
          const Expanded(
            flex: 5,
            child: Text(
              'Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          // Gender header
          const Expanded(
            flex: 2,
            child: Text(
              'Gender',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),

          // Action header
          const SizedBox(
            width: 60,
            child: Text(
              'Action',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsList(List<ParticipantItem> participants) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: participants.length,
      separatorBuilder:
          (_, __) => const Divider(height: 1, color: Color(0xffe9e9e9)),
      itemBuilder: (context, i) {
        final participant = participants[i];
        return _buildParticipantRow(participant);
      },
    );
  }

  Widget _buildParticipantRow(ParticipantItem participant) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Name and BIB
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Text(
                  participant.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                _buildBibBadge(participant.bib),
              ],
            ),
          ),

          // Gender
          Expanded(
            flex: 2,
            child: Text(
              _capitalizeFirst(participant.gender.value),
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),

          // Delete button
          _buildDeleteButton(participant.id),
        ],
      ),
    );
  }

  Widget _buildBibBadge(String bib) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        bib,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDeleteButton(String participantId) {
    return SizedBox(
      width: 60,
      child: Center(
        child: IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
          onPressed: () async {
            await context.read<ParticipantProvider>().deleteParticipant(
              participantId,
            );
          },
        ),
      ),
    );
  }
}
