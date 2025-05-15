import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:race_tracker/data/repositories/participant_repository.dart';
import 'package:race_tracker/models/participant.dart';

class FirebaseParticipantRepository implements ParticipantRepository {
  static const _baseUrl =
      'https://race-tracker-415b1-default-rtdb.asia-southeast1.firebasedatabase.app/';

  @override
  Future<String> createParticipant(ParticipantItem participant) async {
    final url = Uri.parse('$_baseUrl/participants.json');
    final resp = await http.post(url, body: jsonEncode(participant.toJson()));
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return (jsonDecode(resp.body) as Map<String, dynamic>)['name'];
    }
    throw Exception('Failed to create participant');
  }

  @override
  Future<ParticipantItem> getParticipant(String id) async {
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

  @override
  Future<void> updateParticipant(ParticipantItem participant) async {
    if (participant.id.isEmpty) throw ArgumentError('Participant ID required');
    final url = Uri.parse('$_baseUrl/participants/${participant.id}.json');
    final resp = await http.patch(url, body: jsonEncode(participant.toJson()));
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Failed to update participant');
    }
  }

  @override
  Future<void> deleteParticipant(String id) async {
    if (id.isEmpty) throw ArgumentError('Participant ID required');
    final url = Uri.parse('$_baseUrl/participants/$id.json');
    final resp = await http.delete(url);
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Failed to delete participant: ${resp.body}');
    }
  }

  @override
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
}
