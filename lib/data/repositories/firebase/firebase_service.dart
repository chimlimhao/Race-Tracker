import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:race_tracker/models/participant.dart';  // ParticipantItem
import 'package:race_tracker/models/race.dart';
import 'package:race_tracker/models/segment.dart';      // Segment, SegmentTime

class FirebaseService {
  static const _baseUrl =
    'https://race-tracker-415b1-default-rtdb.asia-southeast1.firebasedatabase.app/';

  /// — PARTICIPANTS — (using ParticipantItem)
  Future<String> createParticipantItem(ParticipantItem p) async {
    final url = Uri.parse('$_baseUrl/participants.json');
    final resp = await http.post(url, body: jsonEncode(p.toJson()));
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return (jsonDecode(resp.body) as Map<String, dynamic>)['name'];
    }
    throw Exception('Failed to create participant');
  }

  Future<ParticipantItem> getParticipantItem(String id) async {
    final url = Uri.parse('$_baseUrl/participants/$id.json');
    final resp = await http.get(url);
    if (resp.statusCode == 200 && resp.body != 'null') {
      return ParticipantItem.fromJson(
        jsonDecode(resp.body) as Map<String, dynamic>,
        id,
      );
    }
    throw Exception('Participant not found');
  }

  Future<void> updateParticipantItem(ParticipantItem p) async {
    if (p.id.isEmpty) throw ArgumentError('Participant ID required');
    final url = Uri.parse('$_baseUrl/participants/${p.id}.json');
    final resp = await http.patch(url, body: jsonEncode(p.toJson()));
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Failed to update participant');
    }
  }

  /// — SEGMENT TIMES —

  /// Write a single segment’s elapsed time
  // Future<void> setSegmentTime({
  //   required String raceId,
  //   required String participantId,
  //   required Segment segment,
  //   required int elapsedSeconds,
  // }) async {
  //   final path = 'segmentTimes/$raceId/$participantId/${segment.name}.json';
  //   final url = Uri.parse('$_baseUrl/$path');
  //   final body = jsonEncode({'elapsedTimeInSeconds': elapsedSeconds});
  //   final resp = await http.put(url, body: body);
  //   if (resp.statusCode < 200 || resp.statusCode >= 300) {
  //     throw Exception(
  //       'Failed to set ${segment.name} time for $participantId in $raceId');
  //   }
  // }

   /// Fetch one race by ID
  Future<Race> getRace(String raceId) async {
    final url = Uri.parse('$_baseUrl/races/$raceId.json');
    final resp = await http.get(url);
    if (resp.statusCode == 200 && resp.body != 'null') {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return Race.fromJson(data, raceId);
    }
    throw Exception('Race not found');
  }

  /// Patch an existing race (e.g. to update status or timestamps)
  Future<void> updateRace(Race race) async {
    if (race.id.isEmpty) throw ArgumentError('Race ID required');
    final url = Uri.parse('$_baseUrl/races/${race.id}.json');
    final resp = await http.patch(url, body: jsonEncode(race.toJson()));
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Failed to update race: ${resp.body}');
    }
  }

  /// Fetch all races
Future<List<Race>> getAllRaces() async {
  final url  = Uri.parse('$_baseUrl/races.json');
  final resp = await http.get(url);
  if (resp.statusCode == 200 && resp.body != 'null') {
    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    return data.entries.map((e) {
      // e.key is the race ID, e.value is its JSON map
      return Race.fromJson(e.value as Map<String, dynamic>, e.key);
    }).toList();
  }
  return [];
}

/// — PARTICIPANTS —
/// Delete a participant by ID
Future<void> deleteParticipant(String id) async {
  if (id.isEmpty) throw ArgumentError('Participant ID required');
  final url = Uri.parse('$_baseUrl/participants/$id.json');
  final resp = await http.delete(url);
  if (resp.statusCode < 200 || resp.statusCode >= 300) {
    throw Exception('Failed to delete participant: ${resp.body}');
  }
}



  /// Read all segment times for one participant in one race
  Future<List<SegmentTime>> getSegmentTimes({
    required String raceId,
    required String participantId,
  }) async {
    final url = Uri.parse(
      '$_baseUrl/segmentTimes/$raceId/$participantId.json');
    final resp = await http.get(url);
    if (resp.statusCode == 200 && resp.body != 'null') {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;

      return data.entries.map((entry) {
        final segKey = entry.key; // e.g. 'swimming'
        final elapsed = (entry.value as Map<String, dynamic>)
                          ['elapsedTimeInSeconds'] as int;
        // Map the key back to your enum
        final segment = Segment.values.firstWhere(
          (e) => e.name == segKey,
          orElse: () => Segment.swimming,
        );
        return SegmentTime(
          segment: segment,
          participantId: participantId,
          elapsedTimeInSeconds: elapsed,
        );
      }).toList();
    }
    return [];
  }

  // 1) Create a new race
Future<String> createRace(Race race) async {
  if (!race.isValid) throw ArgumentError('Invalid race data');
  final url = Uri.parse('$_baseUrl/races.json');
  final body = jsonEncode(race.toJson());
  final resp = await http.post(url, body: body);
  if (resp.statusCode < 200 || resp.statusCode >= 300) {
    throw Exception('Failed to create race: ${resp.body}');
  }
  return (jsonDecode(resp.body) as Map<String, dynamic>)['name'] as String;
}

/// in firebase_service.dart, below your existing methods:

/// Fetch every participant
Future<List<ParticipantItem>> getAllParticipants() async {
  final url = Uri.parse('$_baseUrl/participants.json');
  final resp = await http.get(url);
  if (resp.statusCode == 200 && resp.body != 'null') {
    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    return data.entries.map((e) {
      return ParticipantItem.fromJson(e.value as Map<String, dynamic>, e.key);
    }).toList();
  }
  return [];
}


// 2) Track (set) a participant’s time for one segment
Future<void> setSegmentTime({
  required String raceId,
  required String participantId,
  required Segment segment,
  required int elapsedSeconds,
}) async {
  final path = 'segmentTimes/$raceId/$participantId/${segment.name}.json';
  final url  = Uri.parse('$_baseUrl/$path');
  final body = jsonEncode({'elapsedTimeInSeconds': elapsedSeconds});
  final resp = await http.put(url, body: body);
  if (resp.statusCode < 200 || resp.statusCode >= 300) {
    throw Exception(
      'Failed to record ${segment.name} time for $participantId in $raceId'
    );
  }
}

}
