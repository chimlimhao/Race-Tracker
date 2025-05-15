import 'package:race_tracker/models/participant.dart';

abstract class ParticipantRepository {
  /// Create a new participant
  Future<String> createParticipant(ParticipantItem participant);

  /// Get a participant by ID
  Future<ParticipantItem> getParticipant(String id);

  /// Update an existing participant
  Future<void> updateParticipant(ParticipantItem participant);

  /// Delete a participant by ID
  Future<void> deleteParticipant(String id);

  /// Get all participants
  Future<List<ParticipantItem>> getAllParticipants();
}
