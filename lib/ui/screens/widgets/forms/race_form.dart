import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:race_tracker/models/race.dart';
import 'package:race_tracker/models/segment.dart';
// import 'package:race_tracker/data/repositories/firebase/firebase_service.dart';
import 'package:race_tracker/ui/screens/widgets/buttons/race_button.dart';

class RaceForm extends StatefulWidget {
  const RaceForm({Key? key}) : super(key: key);

  @override
  State<RaceForm> createState() => _RaceFormState();
}

class _RaceFormState extends State<RaceForm> {
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;

  /// Each pair: [nameController, distanceController]
  final List<List<TextEditingController>> _segmentControllers = [
    [
      TextEditingController(text: 'Swimming'),
      TextEditingController(text: '1.5 km'),
    ],
    [
      TextEditingController(text: 'Cycling'),
      TextEditingController(text: '40 km'),
    ],
    [
      TextEditingController(text: 'Running'),
      TextEditingController(text: '10 km'),
    ],
  ];

  // final _service = FirebaseService();

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    for (var pair in _segmentControllers) {
      pair[0].dispose();
      pair[1].dispose();
    }
    super.dispose();
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _addSegment() {
    setState(() {
      _segmentControllers.add([
        TextEditingController(),
        TextEditingController(),
      ]);
    });
  }

  void _removeSegment(int idx) {
    setState(() {
      _segmentControllers[idx][0].dispose();
      _segmentControllers[idx][1].dispose();
      _segmentControllers.removeAt(idx);
    });
  }

  Future<void> _submit() async {
    // Build segment models
    final segments =
        _segmentControllers.map((pair) {
          return SegmentModel(
            name: pair[0].text.trim(),
            distance: pair[1].text.trim(),
          );
        }).toList();

    // Validation
    if (_titleController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty ||
        _selectedDate == null ||
        segments.isEmpty ||
        segments.any((s) => !s.isValid)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields & segments')),
      );
      return;
    }

    // final race = Race(
    //   title: _titleController.text.trim(),
    //   date: _selectedDate!,
    //   location: _locationController.text.trim(),
    //   segments: segments,
    // );

    setState(() => _isLoading = true);
    try {
      // final newId = await _service.createRace(race);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Race created: \$newId')));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: \$e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _isLoading,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Race Detail',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Title
            const Text(
              'Race Title',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(controller: _titleController),
            const SizedBox(height: 24),

            // Date
            const Text(
              'Race Date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: _pickDate,
              decoration: const InputDecoration(
                hintText: 'Tap to pick date',
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Location
            const Text(
              'Race Location',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(controller: _locationController),
            const SizedBox(height: 24),

            // Segments header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Race Segments',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                RaceButton(onPressed: _addSegment, type: ButtonType.add),
              ],
            ),
            const SizedBox(height: 12),

            // Dynamic segment fields
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _segmentControllers.length,
              itemBuilder: (_, i) {
                final nameCtrl = _segmentControllers[i][0];
                final distCtrl = _segmentControllers[i][1];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: TextField(
                          controller: nameCtrl,
                          decoration: const InputDecoration(
                            hintText: 'Segment name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: distCtrl,
                          decoration: const InputDecoration(
                            hintText: 'Distance',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _removeSegment(i),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Create Race',
                          style: TextStyle(fontSize: 16),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
