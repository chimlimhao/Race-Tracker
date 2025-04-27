import 'package:flutter/material.dart';

class ParticipantBottomSheet extends StatefulWidget {
  const ParticipantBottomSheet({super.key});

  /// Shows the bottom sheet with all activities
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const ParticipantBottomSheet(),
    );
  }

  @override
  State<ParticipantBottomSheet> createState() => _ParticipantBottomSheetState();
}

class _ParticipantBottomSheetState extends State<ParticipantBottomSheet> {
  final _bibController = TextEditingController();
  final _nameController = TextEditingController();
  String? _selectedGender;

  // A flag to control if the gender selection is expanded
  bool _isGenderExpanded = false;
  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _bibController.dispose();
    _nameController.dispose();
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
                label: 'BIB Number',
                controller: _bibController,
                hintText: 'Enter a BIB number',
                keyboardType: TextInputType.number,
              ),
              _buildInputField(
                label: 'Name',
                controller: _nameController,
                hintText: 'Enter a name',
              ),
              _buildGenderSelector(),
              const SizedBox(height: 32),
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
          'Participant Detail',
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

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            setState(() {
              _isGenderExpanded = !_isGenderExpanded;
            });
          },
          child: Column(
            children: [
              // The input field (shows selected gender or placeholder)
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius:
                      _isGenderExpanded
                          ? const BorderRadius.vertical(top: Radius.circular(8))
                          : BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedGender ?? 'Select a gender',
                      style: TextStyle(
                        color:
                            _selectedGender == null
                                ? Colors.grey.shade600
                                : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      _isGenderExpanded
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),

              // Dropdown options (only visible when expanded)
              if (_isGenderExpanded) _buildGenderOptions(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenderOptions() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.grey.shade400),
          right: BorderSide(color: Colors.grey.shade400),
          bottom: BorderSide(color: Colors.grey.shade400),
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
      ),
      child: Column(
        children:
            _genders.map((gender) {
              bool isSelected = gender == _selectedGender;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedGender = gender;
                    _isGenderExpanded = false;
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  color: isSelected ? Colors.grey.shade200 : Colors.white,
                  child: Text(gender, style: const TextStyle(fontSize: 16)),
                ),
              );
            }).toList(),
      ),
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
        child: const Text('Add Participant', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  void _validateAndSubmitForm() {
    // Validate form
    if (_bibController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // TODO: Add participant to database
    Navigator.pop(context);
  }
}
