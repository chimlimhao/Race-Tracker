/// Keep your existing enums (e.g. RaceStatus, SegmentStatus) above...

/// — Gender enum —
enum Gender { male, female }

extension GenderExtension on Gender {
  String get value => toString().split('.').last;

  /// Create from stored string (e.g. 'male' or 'female')
  static Gender fromString(String s) {
    return Gender.values.firstWhere(
      (e) => e.value == s,
      orElse: () => Gender.male,
    );
  }
}

/// — ParticipantItem model —
class ParticipantItem {
  String id;
  bool isTracked;
  String name;
  Gender gender;
  // String status;
  String bib;

  ParticipantItem({
    this.id = '',
    required this.isTracked,
    required this.name,
    required this.gender,
    // required this.status,
    required this.bib,
  });

  /// Deserialize from Firebase JSON
  factory ParticipantItem.fromJson(Map<String, dynamic> json, String id) {
    return ParticipantItem(
      id: id,
      isTracked: json['isTracked'] as bool? ?? false,
      name:      json['name']      as String? ?? '',
      gender:    GenderExtension.fromString(json['gender'] as String? ?? ''),
      // status:    json['status']    as String? ?? '',
      bib:       json['bib']       as String? ?? '',
    );
  }

  /// Serialize to JSON for Firebase
  Map<String, dynamic> toJson() => {
        'isTracked': isTracked,
        'name':      name,
        'gender':    gender.value,
        // 'status':    status,
        'bib':       bib,
      };
}
