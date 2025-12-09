import 'package:flutter/material.dart';
import '../repositories/user_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  final UserRepository _repository;

  bool _isLoading = false;
  String? _error;

  RegisterViewModel([UserRepository? repository])
    : _repository = repository ?? UserRepository();

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> register(Map<String, dynamic> userData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _repository.register(userData);
      return success;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
