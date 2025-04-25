enum Gender { male, female }

// Simple model class for participant items
class ParticipantItem {
  bool isTracked;
  final String name;
  final Gender gender;
  final String status;
  final String bib;

  ParticipantItem({
    required this.isTracked,
    required this.name,
    required this.gender,
    required this.status,
    required this.bib,
  });
}
