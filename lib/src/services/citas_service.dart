import 'dart:convert';
import 'package:http/http.dart' as http;

class CitasService {
  final String _baseUrl = "https://saluddigital-back-1.onrender.com/api/Citas"; 

  // Crear cita
  Future<bool> crearCita(Map<String, dynamic> citaData) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(citaData),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // Obtener citas DOCTOR (String id)
  Future<List<dynamic>> obtenerCitasDoctor(String doctorId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/doctor/$doctorId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) { /* Error */ }
    return [];
  }

  // Obtener citas PACIENTE (String id)
  Future<List<dynamic>> obtenerCitasPaciente(String pacienteId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/paciente/$pacienteId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) { /* Error */ }
    return [];
  }
}