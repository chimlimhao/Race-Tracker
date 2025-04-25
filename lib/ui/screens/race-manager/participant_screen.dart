import 'package:flutter/material.dart';
import 'package:race_tracker/ui/screens/race-manager/participant_form_screen.dart';
import 'package:race_tracker/ui/screens/widgets/buttons/race_button.dart';
import 'package:race_tracker/ui/screens/widgets/dialogs/search_input.dart';

class ParticipantScreen extends StatelessWidget {
  const ParticipantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Participant')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: SearchInput(),
          ),
          Expanded(child: _participantList(context)),
        ],
      ),
    );
  }

  Widget _participantList(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Text(
                'Participants (x):',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Spacer(),
              RaceButton(
                type: ButtonType.add,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParticipantFormScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Gender',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Action',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 16,
          indent: 24,
          endIndent: 24,
          color: Color(0xffb3b3b3),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 24),
            itemCount: 6,
            separatorBuilder:
                (context, index) => Divider(color: Color(0xffe9e9e9)),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Text('Limhao', style: TextStyle(fontSize: 16)),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text('1001'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text('Male', style: TextStyle(fontSize: 16)),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
