import '../models/race.dart';
import 'services/firebase_service.dart';

class RaceRepository {
  final FirebaseService _firebaseService = FirebaseService();

  // Fetch all races from the database
  Future<List<Race>> fetchRaces() async {
    final data = await _firebaseService.fetchCollection('races');
    return data.map((item) => Race.fromMap(item)).toList();
  }

  // Create a new race in the database
  Future<void> createRace(Race race) async {
    await _firebaseService.addDocument('races', race.toMap());
  }

  // Update an existing race in the database
  Future<void> updateRace(String raceId, Race race) async {
    await _firebaseService.updateDocument('races', raceId, race.toMap());
  }

  // Delete a race from the database
  Future<void> deleteRace(String raceId) async {
    await _firebaseService.deleteDocument('races', raceId);
  }
}