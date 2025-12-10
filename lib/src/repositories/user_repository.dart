import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserRepository {
  final ApiService _apiService;

  UserRepository([ApiService? apiService]) : _apiService = apiService ?? ApiService();

  Future<User> login(String email, String password) async {
    final jsonResponse = await _apiService.login(email, password);

    if (jsonResponse['status'] == 'ok' && jsonResponse['content'] != null) {
      String token = jsonResponse['content'];
      Map<String, dynamic> decoded = JwtDecoder.decode(token);

      final user = User(
        // CORRECCIÓN 1: Asignamos String directamente
        id: decoded['Id']?.toString() ?? decoded['nameid']?.toString() ?? '', 
        
        name: decoded['Name'] ?? decoded['unique_name'] ?? 'Usuario',
        email: decoded['email'] ?? email,
        phone: decoded['PhoneNumber'] ?? decoded['phone'] ?? '',
        age: int.tryParse(decoded['Age']?.toString() ?? '0') ?? 0,
        gender: decoded['Gender'] ?? 'O',
        role: decoded['Role'] ?? decoded['role'] ?? 'Paciente',
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userData', jsonEncode(user.toJson()));
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('token_jwt', token);

      return user;
    }

    throw Exception('Login failed: ${jsonResponse.toString()}');
  }

  Future<bool> register(Map<String, dynamic> userData) async {
    final success = await _apiService.register(userData);
    if (success) {
      final user = User(
        // CORRECCIÓN 2: Usamos cadena vacía en lugar de 0
        id: '', 
        
        name: userData['nombre'] ?? userData['name'] ?? 'Usuario',
        email: userData['email'] ?? 'no@email',
        phone: userData['celular'] ?? userData['phone'] ?? '',
        age: userData['edad'] ?? 0,
        gender: (userData['genre'] ?? 'O').toString(),
        role: 'Paciente', 
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userData', jsonEncode(user.toJson()));
      await prefs.setBool('isLoggedIn', true);

      return true;
    }

    return false;
  }
}