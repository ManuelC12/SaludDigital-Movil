import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//import '../models/user_model.dart'; // Asegúrate de tener este modelo
// Si tienes el modelo de Therapist en otro lado, impórtalo, o defínelo aquí.

class ApiService {
  // TU URL DE RENDER (Sin el /swagger/index.html)
  static const String _baseUrl = "https://saluddigital-back-1.onrender.com/api";

  // --- 1. LOGIN ---
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/Users/login');
    
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Devuelve el JSON con el token
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // --- 2. REGISTRO ---
  Future<bool> register(Map<String, dynamic> userData) async {
    final url = Uri.parse('$_baseUrl/Users/register');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );

      return (response.statusCode == 200 || response.statusCode == 201);
    } catch (e) {
      throw Exception('Error al registrar: $e');
    }
  }

  // --- 3. OBTENER TERAPEUTAS (Privado - Requiere Token) ---
  Future<List<dynamic>> getTherapists() async {
    final url = Uri.parse('$_baseUrl/Therapists');
    
    // Obtenemos el token guardado para tener permiso
    final headers = await _getAuthHeaders(); 

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // La API devuelve una lista de objetos JSON
        return jsonDecode(response.body);
      } else {
        throw Exception('Error cargando terapeutas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // --- AYUDA: OBTENER HEADERS CON TOKEN ---
  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    // Recuperamos el objeto usuario guardado para sacar el token si lo guardaste ahí
    // OJO: Depende de cómo guardaste el token. 
    // Si guardaste todo el JSON del login en 'userData', hay que extraerlo.
    
    // Opción A: Si guardaste solo el token en una variable 'token'
    // String? token = prefs.getString('token'); 

    // Opción B (La que usamos antes): El token venía en el login response.
    // Lo ideal es guardar el token suelto al hacer login:
    // await prefs.setString('jwt_token', token);
    
    // Supongamos que ya guardaste el token como 'jwt_token' en el Login
    String? token = prefs.getString('token_jwt'); // Asegúrate de guardar esto en el login

    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }
}