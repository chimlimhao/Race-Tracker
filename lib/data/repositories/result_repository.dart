import '../models/results.dart';
import '../services/firebase_service.dart';

class ResultRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<Result>> fetchResults(String raceId) async {
    final data = await _firebaseService.fetchCollection('results');
    return data
        .where((item) => item['raceId'] == raceId)
        .map((item) => Result.fromMap(item))
        .toList();
  }

  Future<void> createResult(Result result) async {
      await _firebaseService.addDocument('results', result);
    }