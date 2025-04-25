import 'package:flutter/material.dart';
import 'package:race_tracker/ui/screens/widgets/buttons/race_button.dart';

class RaceForm extends StatefulWidget {
  const RaceForm({super.key});

  @override
  State<RaceForm> createState() => _RaceFormState();
}

class _RaceFormState extends State<RaceForm> {
  // List to store segments
  List<Map<String, String>> segments = [
    {'name': 'Swimming', 'distance': '1.5 km'},
    {'name': 'Cycling', 'distance': '40 km'},
    {'name': 'Running', 'distance': '10 km'},
  ];

  // Add a new empty segment
  void addSegment() {
    setState(() {
      segments.add({'name': '', 'distance': ''});
    });
  }

  // Remove segment at index
  void removeSegment(int index) {
    setState(() {
      segments.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Race Detail',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            Text(
              'Race Title',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.purple),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.purple, width: 2),
                ),
                hintText: 'Enter a race title',
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Race Date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Pick a date',
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Race Location',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Enter a race location',
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Race Segments',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                RaceButton(onPressed: addSegment, type: ButtonType.add),
              ],
            ),
            SizedBox(height: 12),
            // List of segments
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: segments.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      // Segment name field
                      Expanded(
                        flex: 4,
                        child: TextField(
                          controller: TextEditingController(
                            text: segments[index]['name'],
                          ),
                          onChanged: (value) {
                            segments[index]['name'] = value;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: 'Segment name',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      // Distance field
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: TextEditingController(
                            text: segments[index]['distance'],
                          ),
                          onChanged: (value) {
                            segments[index]['distance'] = value;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            hintText: 'Distance',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => removeSegment(index),
                        icon: Icon(Icons.delete_outline, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Create Race button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Process form data
                  print('Creating race with ${segments.length} segments');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Create Race', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
