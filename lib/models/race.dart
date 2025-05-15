import 'package:race_tracker/models/segment.dart';

enum RaceStatus { notStarted, started, finished }

extension RaceStatusExtension on RaceStatus {
  String get value => toString().split('.').last;
  static RaceStatus fromString(String s) => RaceStatus.values.firstWhere(
    (e) => e.value == s,
    orElse: () => RaceStatus.notStarted,
  );
}

class Race {
  String id;
  String title;
  DateTime date;
  String location;
  List<SegmentModel> segments;

  RaceStatus raceStatus;
  int startTime;
  int endTime;

  Race({
    this.id = '',
    required this.title,
    required this.date,
    required this.location,
    required this.segments,
    this.raceStatus = RaceStatus.notStarted,
    this.startTime = 0,
    this.endTime = 0,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'date': date.toIso8601String(),
    'location': location,
    'segments': segments.map((s) => s.toJson()).toList(),
    'raceStatus': raceStatus.value,
    'startTime': startTime,
    'endTime': endTime,
  };

  bool get isValid =>
      title.trim().isNotEmpty &&
      location.trim().isNotEmpty &&
      segments.isNotEmpty &&
      segments.every((s) => s.isValid);

  void markStarted() {
    raceStatus = RaceStatus.started;
    startTime = DateTime.now().millisecondsSinceEpoch;
  }

  void markFinished() {
    raceStatus = RaceStatus.finished;
    endTime = DateTime.now().millisecondsSinceEpoch;
  }

  factory Race.fromJson(Map<String, dynamic> json, String id) {
    // 1) Parse date whether it’s stored as an int (ms since epoch) or a string
    final rawDate = json['date'];
    DateTime date;
    if (rawDate is int) {
      date = DateTime.fromMillisecondsSinceEpoch(rawDate);
    } else if (rawDate is String) {
      date = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      date = DateTime.now();
    }

    // 2) Build segments list as before
    final segList = <SegmentModel>[];
    if (json['segments'] is List) {
      for (var segJson in (json['segments'] as List)) {
        segList.add(
          SegmentModel.fromJson(
            segJson as Map<String, dynamic>,
            /* optional id */ '',
          ),
        );
      }
    }

    // 3) Parse status & timestamps as you already have
    final statusStr = json['raceStatus'] as String? ?? 'notStarted';
    final raceStatus = RaceStatusExtension.fromString(statusStr);
    final startTime = json['startTime'] as int? ?? 0;
    final endTime = json['endTime'] as int? ?? 0;

    return Race(
      id: id,
      title: json['title'] as String? ?? '',
      date: date,
      location: json['location'] as String? ?? '',
      segments: segList,
      raceStatus: raceStatus,
      startTime: startTime,
      endTime: endTime,
    );
  }
}
