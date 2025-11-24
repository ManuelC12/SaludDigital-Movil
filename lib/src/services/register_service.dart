import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterService {
  final String baseUrl = "https://10.0.2.2:7136/api/Users";

  Future<String> register(Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl/register");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        throw Exception(
            "Error al registrar usuario: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("No se pudo conectar con la API: $e");
    }
  }
}
