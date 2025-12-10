import 'package:flutter/material.dart';
import '../models/appointment_model.dart';

class CitasViewModel extends ChangeNotifier {
  // Simulación de base de datos
  final List<Cita> _misCitas = [];

  List<Cita> get citas => _misCitas;

  // AGENDAR UNA CITA (Rol Paciente)
  Future<bool> agendarCita(String terapeutaNombre, DateTime fecha) async {
    try {
      // Aquí harías la llamada a tu ApiService real
      await Future.delayed(const Duration(seconds: 1)); // Simular red
      
      final nuevaCita = Cita(
        id: DateTime.now().toString(),
        terapeutaId: 't1',
        terapeutaNombre: terapeutaNombre,
        pacienteId: 'p1', // Obtener del User actual
        pacienteNombre: 'Yo',
        fecha: fecha,
        linkVideollamada: 'https://meet.google.com/abc-defg-hij',
      );
      
      _misCitas.add(nuevaCita);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // CANCELAR CITA
  void cancelarCita(String id) {
    _misCitas.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}