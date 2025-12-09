import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // Para debugPrint

class RegisterService {
  // 1. Definición correcta (con guion bajo)
  // IMPORTANTE: Agregamos "/register" al final porque así está en tu C#
  final String _baseUrl = "http://127.0.0.1:5000/api/Users/register"; 

  Future<http.Response?> registerUser(Map<String, dynamic> userData) async {
    try {
      // 2. Uso correcto (con guion bajo)
      final response = await http.post(
        Uri.parse(_baseUrl), // <--- AQUÍ ESTABA EL ERROR (antes decía baseUrl)
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );
      
      return response;
    } catch (e) {
      debugPrint("Error en servicio de registro: $e");
      return null;
    }
  }
}