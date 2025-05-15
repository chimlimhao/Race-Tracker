// participant_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker/models/participant.dart';
import 'package:race_tracker/ui/providers/participant_provider.dart';


class ParticipantBottomSheet extends StatefulWidget {
  const ParticipantBottomSheet({Key? key}) : super(key: key);

  /// Shows the bottom sheet with all activities
 // participant_bottom_sheet.dart
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
  State<ParticipantBottomSheet> createState() => _ParticipantBottomSheetState();
}

class _ParticipantBottomSheetState extends State<ParticipantBottomSheet> {
  final _bibController = TextEditingController();
  final _nameController = TextEditingController();
  Gender? _selectedGender;
  bool _isGenderExpanded = false;
  final List<Gender> _genders = Gender.values; 
  bool _submitting = false;

  @override
  void dispose() {
    _bibController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
Widget _buildGenderSelector() {
  final label = _selectedGender != null
      ? _selectedGender!.name[0].toUpperCase() + _selectedGender!.name.substring(1)
      : 'Select a gender';

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Gender', style: TextStyle(fontSize:14, fontWeight: FontWeight.bold)),
      const SizedBox(height:12),
      GestureDetector(
        onTap: () => setState(() => _isGenderExpanded = !_isGenderExpanded),
        child: Column(
          children: [
            Container(
              height:56, padding: const EdgeInsets.symmetric(horizontal:16),
              decoration: BoxDecoration(
                border: Border.all(color:Colors.grey.shade400),
                borderRadius: _isGenderExpanded
                    ? const BorderRadius.vertical(top: Radius.circular(8))
                    : BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label,
                    style: TextStyle(
                      color: _selectedGender==null 
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
        left:   BorderSide(color:Colors.grey.shade400),
        right:  BorderSide(color:Colors.grey.shade400),
        bottom: BorderSide(color:Colors.grey.shade400),
      ),
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
    ),
    child: Column(
      children: _genders.map((g) {
        final label = g.name[0].toUpperCase() + g.name.substring(1);
        final isSelected = g == _selectedGender;
        return InkWell(
          onTap: () => setState(() {
            _selectedGender = g;
            _isGenderExpanded = false;
          }),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal:16, vertical:16),
            color: isSelected ? Colors.grey.shade200 : Colors.white,
            child: Text(label, style: const TextStyle(fontSize:16)),
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
        onPressed: _submitting ? null : _validateAndSubmitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _submitting
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Add Participant', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Future<void> _validateAndSubmitForm() async {
    if (_bibController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _submitting = true);

    final newParticipant = ParticipantItem(
      id: '',
      bib: _bibController.text.trim(),
      name: _nameController.text.trim(),
      gender: _selectedGender!,
      isTracked: false,
    );

    // Use provider to add
    await context.read<ParticipantProvider>().addParticipant(newParticipant);

    setState(() => _submitting = false);
    Navigator.pop(context);
  }
}
