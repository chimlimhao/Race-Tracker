class Result {
  final String id;
  final String raceId;
  final String participantId;
  final int position;
  final Duration time;

  Result({
    required this.id,
    required this.raceId,
    required this.participantId,
    required this.position,
    required this.time,
  });

  factory Result.fromMap(Map<String, dynamic> data) {
    return Result(
      id: data['id'] ?? '',
      raceId: data['raceId'] ?? '',
      participantId: data['participantId'] ?? '',
      position: data['position'] ?? 0,
      time: Duration(milliseconds: data['time']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'raceId': raceId,
      'participantId': participantId,
      'position': position,
      'time': time.inMilliseconds,
    };
  }
}