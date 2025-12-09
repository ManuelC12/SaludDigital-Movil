import '../services/api_service.dart';

class TherapistRepository {
  final ApiService _apiService;

  TherapistRepository([ApiService? apiService]) : _apiService = apiService ?? ApiService();

  Future<List<dynamic>> getTherapists() async {
    final list = await _apiService.getTherapists();
    return list;
  }
}
