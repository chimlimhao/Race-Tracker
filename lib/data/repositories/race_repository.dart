import 'package:race_tracker/models/race.dart';
import 'package:race_tracker/models/segment.dart';

abstract class RaceRepository {
  /// Create a new race
  Future<String> createRace(Race race);

  /// Update an existing race
  Future<void> updateRace(Race race);

  /// Fetch a race by ID
  Future<Race> getRace(String raceId);

  /// Fetch all races
  Future<List<Race>> getAllRaces();

  /// Delete a race by ID
  Future<void> deleteRace(String id);

  /// Set segment time for a participant in a race
  Future<void> setSegmentTime({
    required String raceId,
    required String participantId,
    required Segment segment,
    required int elapsedSeconds,
  });

  /// Remove segment time for a participant in a race
  Future<void> removeSegmentTime({
    required String raceId,
    required String participantId,
    required Segment segment,
  });

  /// Get all segment times for a participant in a race
  Future<List<SegmentTime>> getSegmentTimes({
    required String raceId,
    required String participantId,
  });
}
