import '../../../models/race.dart';
import '../services/firebase_service.dart';

class RaceRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<Race>> fetchRaces() async {
    final data = await _firebaseService.fetchCollection('races');
    return data.map((item) => Race.fromMap(item)).toList();
  }

  Future<void> createRace(Race race) async {
    await _firebaseService.addDocument('races', race.toMap());
  }

  Future<void> updateRace(String raceId, Race race) async {
    await _firebaseService.updateDocument('races', raceId, race.toMap());
  }

  Future<void> deleteRace(String raceId) async {
    await _firebaseService.deleteDocument('races', raceId);
  }
}