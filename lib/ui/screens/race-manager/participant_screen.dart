// participant_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker/models/participant.dart';
import 'package:race_tracker/ui/providers/participant_provider.dart';
import 'package:race_tracker/ui/screens/widgets/inputs/search_input.dart';
import 'package:race_tracker/ui/screens/widgets/modals/participant_bottom_sheet.dart';

class ParticipantScreen extends StatefulWidget {
  const ParticipantScreen({Key? key}) : super(key: key);

  @override
  _ParticipantScreenState createState() => _ParticipantScreenState();
}

class _ParticipantScreenState extends State<ParticipantScreen> {
  @override
  void initState() {
    super.initState();
    // Load participants after first frame
    Future.microtask(
      () => context.read<ParticipantProvider>().fetchParticipants(),
    );
  }

  // in participant_bottom_sheet.dart
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const ParticipantBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ParticipantProvider>();
    final participants = provider.participants;
    final loading = provider.loading;

    return Scaffold(
      appBar: AppBar(
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
      ),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: SearchInput(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Participants (${participants.length}):',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xffb3b3b3)),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      itemCount: participants.length,
                      separatorBuilder:
                          (_, __) => const Divider(color: Color(0xffe9e9e9)),
                      itemBuilder: (context, i) {
                        final p = participants[i];
                        return Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  Text(
                                    p.name,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      p.bib,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                p.gender
                                    .toString()
                                    .split('.')
                                    .last,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    await context
                                        .read<ParticipantProvider>()
                                        .deleteParticipant(p.id);
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
