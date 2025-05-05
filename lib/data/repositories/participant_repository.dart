import '../models/participant.dart';
import '../services/firebase_service.dart';

class ParticipantRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<Participant>> fetchParticipants() async {
    final data = await _firebaseService.fetchCollection('participants');
    return data.map((item) => Participant.fromMap(item)).toList();
  }

  Future<void> createParticipant(Participant participant) async {
    await _firebaseService.addDocument('participants', participant.toMap());
  }

  Future<void> updateParticipant(String participantId, Participant participant) async {
    await _firebaseService.updateDocument('participants', participantId, participant.toMap());
  }

  Future<void> deleteParticipant(String participantId) async {
    await _firebaseService.deleteDocument('participants', participantId);
  }
}