import 'package:flutter/material.dart';
import 'package:race_tracker/data/repositories/firebase/firebase_service.dart';
import 'package:race_tracker/models/participant.dart';

/// Manages fetching and state for participants
class ParticipantProvider extends ChangeNotifier {
  final FirebaseService _service = FirebaseService();
  List<ParticipantItem> _participants = [];
  bool _loading = false;

  List<ParticipantItem> get participants => _participants;
  bool get loading => _loading;

  Future<void> fetchParticipants() async {
    _loading = true;
    notifyListeners();
    _participants = await _service.getAllParticipants();
    _loading = false;
    notifyListeners();
  }

  /// Checks if a BIB number is already in use
  bool isBibNumberTaken(String bib) {
    return _participants.any((p) => p.bib == bib);
  }

  Future<void> addParticipant(ParticipantItem p) async {
    // Check for uniqueness first
    if (isBibNumberTaken(p.bib)) {
      throw Exception('BIB number ${p.bib} is already in use');
    }

    _loading = true;
    notifyListeners();
    final id = await _service.createParticipantItem(p);
    p.id = id;
    _participants.add(p);
    _loading = false;
    notifyListeners();
  }

  Future<void> updateParticipant(ParticipantItem p) async {
    _loading = true;
    notifyListeners();
    await _service.updateParticipantItem(p);
    _loading = false;
    notifyListeners();
  }

  Future<void> deleteParticipant(String id) async {
    _loading = true;
    notifyListeners();
    await _service.deleteParticipant(id);
    _participants.removeWhere((x) => x.id == id);
    _loading = false;
    notifyListeners();
  }
}
