import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:race_tracker/data/repositories/race_repository.dart';
import 'package:race_tracker/models/race.dart';
import 'package:race_tracker/models/segment.dart';

class FirebaseRaceRepository implements RaceRepository {
  static const _baseUrl =
      'https://race-tracker-415b1-default-rtdb.asia-southeast1.firebasedatabase.app/';

  @override
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

  @override
  Future<void> updateRace(Race race) async {
    if (race.id.isEmpty) throw ArgumentError('Race ID required');
    final url = Uri.parse('$_baseUrl/races/${race.id}.json');
    final resp = await http.patch(url, body: jsonEncode(race.toJson()));
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Failed to update race: ${resp.body}');
    }
  }

  @override
  Future<Race> getRace(String raceId) async {
    final url = Uri.parse('$_baseUrl/races/$raceId.json');
    final resp = await http.get(url);
    if (resp.statusCode == 200 && resp.body != 'null') {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return Race.fromJson(data, raceId);
    }
    throw Exception('Race not found');
  }

  @override
  Future<List<Race>> getAllRaces() async {
    final url = Uri.parse('$_baseUrl/races.json');
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

  @override
  Future<void> deleteRace(String id) async {
    final url = Uri.parse('$_baseUrl/races/$id.json');
    final resp = await http.delete(url);
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Failed to delete race');
    }
  }

  @override
  Future<void> setSegmentTime({
    required String raceId,
    required String participantId,
    required Segment segment,
    required int elapsedSeconds,
  }) async {
    final path = 'segmentTimes/$raceId/$participantId/${segment.name}.json';
    final url = Uri.parse('$_baseUrl/$path');
    final body = jsonEncode({'elapsedTimeInSeconds': elapsedSeconds});
    final resp = await http.put(url, body: body);
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception(
        'Failed to record ${segment.name} time for $participantId in $raceId',
      );
    }
  }

  @override
  Future<void> removeSegmentTime({
    required String raceId,
    required String participantId,
    required Segment segment,
  }) async {
    final path = 'segmentTimes/$raceId/$participantId/${segment.name}.json';
    final url = Uri.parse('$_baseUrl/$path');
    final resp = await http.delete(url);
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception(
        'Failed to remove ${segment.name} time for $participantId in $raceId',
      );
    }
  }

  @override
  Future<List<SegmentTime>> getSegmentTimes({
    required String raceId,
    required String participantId,
  }) async {
    final url = Uri.parse('$_baseUrl/segmentTimes/$raceId/$participantId.json');
    final resp = await http.get(url);
    if (resp.statusCode == 200 && resp.body != 'null') {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;

      return data.entries.map((entry) {
        final segKey = entry.key; // e.g. 'swimming'
        final elapsed =
            (entry.value as Map<String, dynamic>)['elapsedTimeInSeconds']
                as int;
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
}
