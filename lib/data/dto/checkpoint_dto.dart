class CheckpointDTO {
  final String bib;              
  final int checkpointNumber;    
  final DateTime timestamp;      

  CheckpointDTO({
    required this.bib,
    required this.checkpointNumber,
    required this.timestamp,
  });

  factory CheckpointDTO.fromJson(Map<String, dynamic> json) {
    return CheckpointDTO(
      bib: json['BIB'],
      checkpointNumber: json['CheckpointNumber'],
      timestamp: DateTime.parse(json['Timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BIB': bib,
      'CheckpointNumber': checkpointNumber,
      'Timestamp': timestamp.toIso8601String(),
    };
  }
}