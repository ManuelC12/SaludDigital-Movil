import 'package:flutter/material.dart';
import '../repositories/therapist_repository.dart';

class TherapistViewModel extends ChangeNotifier {
  final TherapistRepository _repository;

  bool _isLoading = false;
  String? _error;
  List<dynamic> _therapists = [];

  TherapistViewModel([TherapistRepository? repository]) : _repository = repository ?? TherapistRepository();

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<dynamic> get therapists => _therapists;

  Future<void> loadTherapists() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final list = await _repository.getTherapists();
      _therapists = list;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
