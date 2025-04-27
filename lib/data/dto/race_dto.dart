class RaceDTO {
  final String raceId;  
  final String title;   
  final DateTime date;  

  RaceDTO({
    required this.raceId,
    required this.title,
    required this.date,
  });

  factory RaceDTO.fromJson(Map<String, dynamic> json) {
    return RaceDTO(
      raceId: json['RaceID'],
      title: json['Title'],
      date: DateTime.parse(json['Date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RaceID': raceId,
      'Title': title,
      'Date': date.toIso8601String(),
    };
  }
}