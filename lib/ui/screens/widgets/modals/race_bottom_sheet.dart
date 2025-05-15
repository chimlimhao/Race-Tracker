import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:race_tracker/models/race.dart';
import 'package:race_tracker/models/segment.dart';
import 'package:race_tracker/data/repositories/firebase/firebase_service.dart';

class RaceBottomSheet extends StatefulWidget {
  const RaceBottomSheet({super.key});

  /// Call this to show the sheet
// after
static Future<void> show(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const RaceBottomSheet(),
  );
}


  @override
  State<RaceBottomSheet> createState() => _RaceBottomSheetState();
}

class _RaceBottomSheetState extends State<RaceBottomSheet> {
  final _nameController     = TextEditingController();
  final _dateController     = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;

  /// One pair of controllers per segment: [nameController, distController]
  final List<List<TextEditingController>> _segmentControllers = [
    [TextEditingController(text: 'Swimming'), TextEditingController(text: '1.5 km')],
    [TextEditingController(text: 'Cycling'),  TextEditingController(text: '20 km')],
    [TextEditingController(text: 'Running'),  TextEditingController(text: '5 km')],
  ];

  final FirebaseService _service = FirebaseService();

  @override
  void dispose() {
    _nameController.dispose();
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
      firstDate: now.subtract(Duration(days: 365)),
      lastDate: now.add(Duration(days: 365)),
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

  Future<void> _validateAndSubmitForm() async {
    // Build Segment models
    final segments = _segmentControllers.map((pair) {
      return SegmentModel(name: pair[0].text.trim(), distance: pair[1].text.trim());
    }).toList();

    // Validation
    if (_nameController.text.trim().isEmpty ||
        _selectedDate == null ||
        _locationController.text.trim().isEmpty ||
        segments.isEmpty ||
        segments.any((s) => !s.isValid)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete all fields & segments')),
      );
      return;
    }

    final race = Race(
      title: _nameController.text.trim(),
      date: _selectedDate!,
      location: _locationController.text.trim(),
      segments: segments,
    );

    setState(() => _isLoading = true);
    try {
      final id = await _service.createRace(race);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Race created: $id')),
      );
      Navigator.of(context).pop(); // close bottom sheet
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 16,
        left: 24,
        right: 24,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Race Detail',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Name
          _buildField('Race Name', _nameController, hint: 'Enter a race name'),

          // Date
          _buildField('Date', _dateController,
              hint: 'Tap to pick date', readOnly: true, onTap: _pickDate,
              suffix: Icon(Icons.calendar_today)),

          // Location
          _buildField('Location', _locationController,
              hint: 'Enter a location'),

          // Segments list
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Race Segments',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.add, color: Colors.black),
                onPressed: _addSegment,
              ),
            ],
          ),
          SizedBox(height: 8),
          // dynamic segment inputs
          Expanded(
            child: ListView.builder(
              itemCount: _segmentControllers.length,
              itemBuilder: (_, i) {
                final nameCtrl = _segmentControllers[i][0];
                final distCtrl = _segmentControllers[i][1];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: TextField(
                          controller: nameCtrl,
                          decoration: InputDecoration(
                            hintText: 'Segment name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: distCtrl,
                          decoration: InputDecoration(
                            hintText: 'Distance',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _removeSegment(i),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Submit
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _validateAndSubmitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Add Race', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    String hint = '',
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
