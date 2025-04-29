class Race {
  final String id;
  final String name;
  final DateTime date;
  final String location;
  final String status;

  Race({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.status,
  });

  factory Race.fromMap(Map<String, dynamic> data) {
    return Race(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      date: DateTime.parse(data['date']),
      location: data['location'] ?? '',
      status: data['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'location': location,
      'status': status,
    };
  }
}