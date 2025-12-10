class Cita {
  final String id;
  final String terapeutaId;
  final String terapeutaNombre;
  final String pacienteId;
  final String pacienteNombre;
  final DateTime fecha;
  final String estado; // 'pendiente', 'confirmada', 'finalizada'
  final String linkVideollamada; // Para la telemedicina

  Cita({
    required this.id,
    required this.terapeutaId,
    required this.terapeutaNombre,
    required this.pacienteId,
    required this.pacienteNombre,
    required this.fecha,
    this.estado = 'pendiente',
    this.linkVideollamada = '',
  });
}