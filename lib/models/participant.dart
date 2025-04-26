class Participant {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String team;

  Participant({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.team,
  });

  factory Participant.fromMap(Map<String, dynamic> data) {
    return Participant(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      gender: data['gender'] ?? '',
      team: data['team'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'team': team,
    };
  }
}