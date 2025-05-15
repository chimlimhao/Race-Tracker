// participant_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker/models/participant.dart';
import 'package:race_tracker/ui/providers/participant_provider.dart';

class ParticipantBottomSheet extends StatefulWidget {
  const ParticipantBottomSheet({Key? key}) : super(key: key);

  /// Shows the bottom sheet with all activities
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
  // Controllers and state variables
  final _bibController = TextEditingController();
  final _nameController = TextEditingController();
  Gender? _selectedGender;
  bool _isGenderExpanded = false;
  final List<Gender> _genders = Gender.values;
  bool _submitting = false;

  // Field error states
  String? _bibError;
  String? _nameError;
  String? _genderError;

  @override
  void initState() {
    super.initState();
    _fetchLatestParticipants();
  }

  void _fetchLatestParticipants() {
    // Make sure we have the latest participants data
    Future.microtask(() {
      context.read<ParticipantProvider>().fetchParticipants();
    });
  }

  @override
  void dispose() {
    _bibController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBottomSheetContainer(
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
              _buildForm(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheetContainer({required Widget child}) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: child,
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField(
          label: 'BIB Number',
          controller: _bibController,
          hintText: 'Enter a BIB number',
          keyboardType: TextInputType.number,
          errorText: _bibError,
        ),
        _buildInputField(
          label: 'Name',
          controller: _nameController,
          hintText: 'Enter a name',
          errorText: _nameError,
        ),
        _buildGenderSelector(),
        const SizedBox(height: 32),
        _buildSubmitButton(),
      ],
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
    String? errorText,
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
          decoration: _getInputDecoration(hintText, errorText),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  InputDecoration _getInputDecoration(String hintText, String? errorText) {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      hintText: hintText,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      errorText: errorText,
      // Add red border if there's an error
      enabledBorder:
          errorText != null
              ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              )
              : null,
    );
  }

  Widget _buildGenderSelector() {
    final label =
        _selectedGender != null
            ? _capitalizeFirst(_selectedGender!.name)
            : 'Select a gender';

    final borderColor =
        _genderError != null ? Colors.red : Colors.grey.shade400;
    final borderWidth = _genderError != null ? 1.5 : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _toggleGenderDropdown,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGenderSelectorField(label, borderColor, borderWidth),
              if (_isGenderExpanded) _buildGenderOptions(borderColor),
              _buildGenderError(),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  void _toggleGenderDropdown() {
    setState(() => _isGenderExpanded = !_isGenderExpanded);
  }

  Widget _buildGenderSelectorField(
    String label,
    Color borderColor,
    double borderWidth,
  ) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius:
            _isGenderExpanded
                ? const BorderRadius.vertical(top: Radius.circular(8))
                : BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color:
                  _selectedGender == null ? Colors.grey.shade600 : Colors.black,
              fontSize: 16,
            ),
          ),
          Icon(
            _isGenderExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            color: Colors.grey.shade600,
          ),
        ],
      ),
    );
  }

  Widget _buildGenderError() {
    if (_genderError == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 12),
      child: Text(
        _genderError!,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }

  Widget _buildGenderOptions(Color borderColor) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: borderColor),
          right: BorderSide(color: borderColor),
          bottom: BorderSide(color: borderColor),
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
      ),
      child: Column(
        children: _genders.map((gender) => _buildGenderOption(gender)).toList(),
      ),
    );
  }

  Widget _buildGenderOption(Gender gender) {
    final label = _capitalizeFirst(gender.name);
    final isSelected = gender == _selectedGender;

    return InkWell(
      onTap: () => _selectGender(gender),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        color: isSelected ? Colors.grey.shade200 : Colors.white,
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  void _selectGender(Gender gender) {
    setState(() {
      _selectedGender = gender;
      _isGenderExpanded = false;
      _genderError = null; // Clear error when a selection is made
    });
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
        child:
            _submitting
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Add Participant', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Future<void> _validateAndSubmitForm() async {
    _resetErrors();

    if (!_validateFields()) return;

    final bibNumber = _bibController.text.trim();
    final participantProvider = context.read<ParticipantProvider>();

    if (_isBibTaken(bibNumber, participantProvider)) return;

    await _submitForm(bibNumber, participantProvider);
  }

  void _resetErrors() {
    setState(() {
      _bibError = null;
      _nameError = null;
      _genderError = null;
    });
  }

  bool _validateFields() {
    bool hasError = false;

    if (_bibController.text.isEmpty) {
      setState(() {
        _bibError = 'BIB number is required';
        hasError = true;
      });
    }

    if (_nameController.text.isEmpty) {
      setState(() {
        _nameError = 'Name is required';
        hasError = true;
      });
    }

    if (_selectedGender == null) {
      setState(() {
        _genderError = 'Please select a gender';
        hasError = true;
      });
    }

    return !hasError;
  }

  bool _isBibTaken(String bibNumber, ParticipantProvider provider) {
    if (provider.isBibNumberTaken(bibNumber)) {
      setState(() {
        _bibError = 'BIB number $bibNumber is already in use';
      });
      return true;
    }
    return false;
  }

  Future<void> _submitForm(
    String bibNumber,
    ParticipantProvider provider,
  ) async {
    setState(() => _submitting = true);

    final newParticipant = ParticipantItem(
      id: '',
      bib: bibNumber,
      name: _nameController.text.trim(),
      gender: _selectedGender!,
      isTracked: false,
    );

    try {
      await provider.addParticipant(newParticipant);
      Navigator.pop(context);
    } catch (e) {
      _handleSubmitError(e);
    } finally {
      setState(() => _submitting = false);
    }
  }

  void _handleSubmitError(dynamic error) {
    if (error.toString().contains('BIB number')) {
      setState(() {
        _bibError = error.toString().replaceAll('Exception: ', '');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString()), backgroundColor: Colors.red),
      );
    }
  }

  String _capitalizeFirst(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }
}
