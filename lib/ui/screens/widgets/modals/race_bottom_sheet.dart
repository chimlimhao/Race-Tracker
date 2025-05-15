import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:race_tracker/data/repositories/race_repository.dart';
import 'package:race_tracker/data/repositories/firebase/race_repo_imp.dart';
import 'package:race_tracker/models/race.dart';
import 'package:race_tracker/models/segment.dart';
// import 'package:race_tracker/data/repositories/firebase/firebase_service.dart';

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
  // MARK: - Properties

  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;

  /// One pair of controllers per segment: [nameController, distController]
  final List<List<TextEditingController>> _segmentControllers = [
    [
      TextEditingController(text: 'Swimming'),
      TextEditingController(text: '1.5 km'),
    ],
    [
      TextEditingController(text: 'Cycling'),
      TextEditingController(text: '20 km'),
    ],
    [
      TextEditingController(text: 'Running'),
      TextEditingController(text: '5 km'),
    ],
  ];

  // Use the race repository
  final RaceRepository _raceRepository = FirebaseRaceRepository();

  // MARK: - Lifecycle Methods

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

  // MARK: - Actions

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

  Future<void> _validateAndSubmitForm() async {
    // Build Segment models
    final segments =
        _segmentControllers.map((pair) {
          return SegmentModel(
            name: pair[0].text.trim(),
            distance: pair[1].text.trim(),
          );
        }).toList();

    // Validation
    if (_nameController.text.trim().isEmpty ||
        _selectedDate == null ||
        _locationController.text.trim().isEmpty ||
        segments.isEmpty ||
        segments.any((s) => !s.isValid)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all fields & segments'),
          behavior: SnackBarBehavior.floating,
        ),
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
      // Create the race using the repository
      await _raceRepository.createRace(race);

      // Show a user-friendly success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Race "${race.title}" created successfully!',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.of(context).pop(); // close bottom sheet
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // MARK: - UI Building

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
          _buildHeader(),
          const SizedBox(height: 16),
          _buildFormFields(),
          _buildSegmentsSection(),
          const SizedBox(height: 16),
          _buildSubmitButton(),
        ],
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

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildField('Race Name', _nameController, hint: 'Enter a race name'),
        _buildField(
          'Date',
          _dateController,
          hint: 'Tap to pick date',
          readOnly: true,
          onTap: _pickDate,
          suffix: const Icon(Icons.calendar_today),
        ),
        _buildField('Location', _locationController, hint: 'Enter a location'),
      ],
    );
  }

  Widget _buildSegmentsSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Race Segments',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.black),
                onPressed: _addSegment,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _segmentControllers.length,
              itemBuilder: (_, i) => _buildSegmentRow(i),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentRow(int index) {
    final nameCtrl = _segmentControllers[index][0];
    final distCtrl = _segmentControllers[index][1];

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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextField(
              controller: distCtrl,
              decoration: InputDecoration(
                hintText: 'Distance',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _removeSegment(index),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _validateAndSubmitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child:
            _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                  'Add Race',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
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
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
