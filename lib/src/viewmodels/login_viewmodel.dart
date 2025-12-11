import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final UserRepository _repository;

  bool _isLoading = false;
  String? _error;
  User? _user;

  LoginViewModel([UserRepository? repository])
    : _repository = repository ?? UserRepository();

  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get user => _user;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final u = await _repository.login(email, password);
      _user = u;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cierra la sesión del usuario localmente
  void logout() {
    _user = null;
    notifyListeners();
  }
}
