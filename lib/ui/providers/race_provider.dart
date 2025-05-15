// providers.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracker/data/repositories/firebase/firebase_service.dart';
import 'package:race_tracker/models/race.dart';
import 'package:race_tracker/models/participant.dart';

/// Manages fetching and state for races
class RaceProvider extends ChangeNotifier {
  final FirebaseService _service = FirebaseService();
  List<Race> _races = [];
  Race? _currentRace;
  bool _loading = false;

  List<Race> get races => _races;
  Race? get currentRace => _currentRace;
  bool get loading => _loading;

  /// Fetch all races from backend
  Future<void> fetchRaces() async {
    _loading = true;
    notifyListeners();

    _races = await _service.getAllRaces();

    // Sort races by their status and related timestamps
    _sortRaces();

    _loading = false;
    notifyListeners();
  }

  /// Sort races by their status and respective timestamps
  void _sortRaces() {
    // Separate races by status
    final pending =
        _races.where((r) => r.raceStatus == RaceStatus.notStarted).toList();
    final active =
        _races.where((r) => r.raceStatus == RaceStatus.started).toList();
    final completed =
        _races.where((r) => r.raceStatus == RaceStatus.finished).toList();

    // Sort each category
    pending.sort((a, b) => b.date.compareTo(a.date)); // Newest date first
    active.sort(
      (a, b) => b.startTime.compareTo(a.startTime),
    ); // Most recently started first
    completed.sort(
      (a, b) => b.endTime.compareTo(a.endTime),
    ); // Most recently completed first

    // Recombine with active races first, then pending, then completed
    _races = [...active, ...pending, ...completed];
  }

  /// Fetch a single race (e.g. detail view)
  Future<void> fetchRace(String id) async {
    _loading = true;
    notifyListeners();
    _currentRace = await _service.getRace(id);
    // sync in list if present
    final idx = _races.indexWhere((r) => r.id == id);
    if (idx >= 0) _races[idx] = _currentRace!;
    _loading = false;
    notifyListeners();
  }

  /// Start the current race
  Future<void> startRace() async {
    if (_currentRace == null) return;
    _loading = true;
    notifyListeners();
    _currentRace!.markStarted();
    await _service.updateRace(_currentRace!);
    // update in list
    final idx = _races.indexWhere((r) => r.id == _currentRace!.id);
    if (idx >= 0) _races[idx] = _currentRace!;

    // Re-sort races after updating status
    _sortRaces();

    _loading = false;
    notifyListeners();
  }

  /// Finish the current race
  Future<void> finishRace() async {
    if (_currentRace == null) return;
    _loading = true;
    notifyListeners();
    _currentRace!.markFinished();
    await _service.updateRace(_currentRace!);
    // update in list
    final idx = _races.indexWhere((r) => r.id == _currentRace!.id);
    if (idx >= 0) _races[idx] = _currentRace!;

    // Re-sort races after updating status
    _sortRaces();

    _loading = false;
    notifyListeners();
  }

  Future<void> deleteRace(String id) async {
    _loading = true;
    notifyListeners();
    await _service.deleteRace(id); // implement in FirebaseService
    _races.removeWhere((r) => r.id == id);
    _loading = false;
    notifyListeners();
  }

  /// If all segment times are set, auto-complete the race
  // Future<void> autoCompleteIfNeeded() async {
  //   if (_currentRace == null) return;
  //   final allDone = _currentRace!.segments.every((seg) =>
  //     seg.participantTimes.every((pt) => pt.elapsedTimeInSeconds != null)
  //   );
  //   if (allDone) await finishRace();
  // }
}
