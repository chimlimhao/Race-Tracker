import 'package:flutter/material.dart';

class RaceBottomSheet extends StatefulWidget {
  const RaceBottomSheet({super.key});

  /// Shows the bottom sheet with all activities
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const RaceBottomSheet(),
    );
  }

  @override
  State<RaceBottomSheet> createState() => _RaceBottomSheetState();
}

class _RaceBottomSheetState extends State<RaceBottomSheet> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  final _segmentsController = TextEditingController();
  List<Map<String, String>> segments = [
    {'name': 'Swimming', 'distance': '1.5 km'},
    {'name': 'Cycling', 'distance': '20 km'},
    {'name': 'Running', 'distance': '5 km'},
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
  void dispose() {
    _nameController.dispose();
    _segmentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This ensures the bottom sheet takes up the correct amount of space
    // and adjusts when the keyboard appears
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      // Allow the bottom sheet to expand up to 90% of the screen height
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildHeader(),
              const SizedBox(height: 24),
              _buildInputField(
                label: 'Race Name',
                controller: _nameController,
                hintText: 'Enter a race name',
              ),
              _buildInputField(
                label: 'Date',
                controller: _dateController,
                hintText: 'Enter a date',
              ),
              _buildInputField(
                label: 'Location',
                controller: _locationController,
                hintText: 'Enter a location',
              ),
              _buildSegmentInputField(
                controller: _segmentsController,
                label: 'Segments',
                hintText: 'Enter a segment',
              ),
              _buildSubmitButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Race Detail',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSegmentInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Race Segments',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: addSegment,
              icon: Icon(Icons.add, color: Colors.black),
            ),
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
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _validateAndSubmitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Add Race', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  void _validateAndSubmitForm() {
    // Validate form
    if (_nameController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _locationController.text.isEmpty ||
        segments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // TODO: Add participant to database
    Navigator.pop(context);
  }
}
