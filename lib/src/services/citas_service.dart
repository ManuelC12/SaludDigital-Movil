import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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
    } catch (e) {
      /* Error */
    }
    return [];
  }

  // Obtener citas PACIENTE (String id)
  Future<List<dynamic>> obtenerCitasPaciente(String pacienteId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/paciente/$pacienteId'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      /* Error */
    }
    return [];
  }

  // --- Funciones para manejar citas locales en el dispositivo ---

  Future<File> _localFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/citas_locales.json');
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString('[]', flush: true);
    }
    return file;
  }

  Future<List<dynamic>> leerCitasLocales() async {
    try {
      final file = await _localFile();
      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];
      return jsonDecode(content) as List<dynamic>;
    } catch (e) {
      return [];
    }
  }

  Future<bool> escribirCitasLista(List<dynamic> lista) async {
    try {
      final file = await _localFile();
      final encoded = const JsonEncoder.withIndent('  ').convert(lista);
      await file.writeAsString(encoded, flush: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> confirmarCitaPorIndice(int index) async {
    try {
      final lista = await leerCitasLocales();
      if (index < 0 || index >= lista.length) return false;
      final Map<String, dynamic> cita = Map<String, dynamic>.from(lista[index]);
      cita['estado'] = 'confirmada';
      lista[index] = cita;
      return await escribirCitasLista(lista);
    } catch (e) {
      return false;
    }
  }

  Future<bool> cancelarCitaPorIndice(int index) async {
    try {
      final lista = await leerCitasLocales();
      if (index < 0 || index >= lista.length) return false;
      final Map<String, dynamic> cita = Map<String, dynamic>.from(lista[index]);
      cita['estado'] = 'cancelada';
      lista[index] = cita;
      return await escribirCitasLista(lista);
    } catch (e) {
      return false;
    }
  }
}
