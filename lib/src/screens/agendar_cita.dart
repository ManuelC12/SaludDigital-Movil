import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../services/citas_service.dart';
import '../viewmodels/login_viewmodel.dart';

class AgendarCitaScreen extends StatefulWidget {
  final int doctorId;
  final String doctorNombre;

  const AgendarCitaScreen({
    super.key,
    required this.doctorId,
    required this.doctorNombre,
  });

  @override
  State<AgendarCitaScreen> createState() => _AgendarCitaScreenState();
}

class _AgendarCitaScreenState extends State<AgendarCitaScreen> {
  bool doctorChoosed = false;
  String? _selectedDoctorName;
  int? _selectedDoctorId;
  String title = '';
  List<String> doctors = [
    'Dr. Alejandro Ruiz, 12 años, Psicología Clínica',
    'Dra. Sofía Mendoza, 8 años, Psicoterapia Cognitivo-Conductual',
    'Dr. Carlos Vázquez, 25 años, Psiquiatría General',
    'Dra. Laura Fernández, 5 años, Psicología Infantil y Adolescente',
    'Dr. Miguel Soto, 18 años, Neuropsicología',
    'Dra. Valeria Castro, 10 años, Terapia Familiar y de Pareja',
    'Dr. Javier Flores, 30 años, Psiquiatría de Adultos Mayores',
    'Dra. Ana Torres, 7 años, Psicología de la Salud',
    'Dr. Ricardo Gómez, 15 años, Terapia de Trauma y EMDR',
    'Dra. Elena Pérez, 9 años, Psicoterapia Humanista',
    'Dr. José Luis Ramos, 22 años, Psiquiatría Forense',
    'Dra. María Isabel López, 14 años, Terapia Dialéctico Conductual (DBT)',
    'Dr. David Herrera, 6 años, Psicología Deportiva',
    'Dra. Gabriela Santos, 19 años, Psiquiatría de Adicciones',
    'Dr. Fernando Aguilar, 4 años, Terapia Ocupacional en Salud Mental',
    'Dra. Patricia Núñez, 11 años, Psicología Organizacional y del Trabajo',
    'Dr. Jorge Morales, 28 años, Psicoanálisis',
    'Dra. Andrea Rojas, 16 años, Psicoterapia Breve Estratégica',
    'Dr. Iván Salazar, 3 años, Terapia Asistida con Animales',
    'Dra. Carmen Vidal, 21 años, Psiquiatría de Enlace (Medicina y Psiquiatría)',
  ];

  DateTime _fechaSeleccionada = DateTime.now();
  TimeOfDay _horaSeleccionada =
      TimeOfDay.now(); // Ahora sí cambiaremos su valor

  final CitasService _service = CitasService();

  // Función para mostrar el reloj y actualizar la variable
  Future<void> _seleccionarHora(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _horaSeleccionada,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF2D936C)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _horaSeleccionada) {
      setState(() {
        _horaSeleccionada = picked;
      });
    }
  }

  Future<File> _localFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/citas_locales.json');
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString(
        '[]',
        flush: true,
      ); // inicializar como lista vacía y forzar flush
    }
    return file;
  }

  Future<bool> _guardarCitaLocal(Map<String, dynamic> nuevaCita) async {
    try {
      final file = await _localFile();
      final content = await file.readAsString();
      final List<dynamic> lista = content.isNotEmpty ? jsonDecode(content) : [];
      // Añadir campo de guardado (fecha de registro) opcional
      nuevaCita['guardadoEn'] = DateTime.now().toIso8601String();
      // marcar como no sincronizado por defecto
      nuevaCita['sincronizado'] = false;
      lista.add(nuevaCita);
      final encoded = const JsonEncoder.withIndent('  ').convert(lista);
      await file.writeAsString(encoded, flush: true);
      // Opcional: print para debugging
      // ignore: avoid_print
      print('Cita guardada en: ${file.path}');
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Error guardando cita: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          doctorChoosed ? "Agendar Cita" : "Seleccionar Doctor",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2D936C),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Visibility(
                visible: !doctorChoosed,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final parts = doctors[index].split(',');
                    final name = parts.isNotEmpty ? parts[0].trim() : '';
                    final years = parts.length > 1 ? parts[1].trim() : '';
                    final specialty = parts.length > 2 ? parts[2].trim() : '';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          setState(() {
                            doctorChoosed = true;
                            _selectedDoctorName = name;
                            _selectedDoctorId = index + 1; // id provisional
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: const Color(0xFF2D936C),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Exp: $years',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      specialty,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Vista de reserva (visible cuando doctorChoosed == true)
              Visibility(
                visible: doctorChoosed,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Reserva con ${_selectedDoctorName ?? widget.doctorNombre}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Selecciona la fecha:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 280,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CalendarDatePicker(
                        initialDate: _fechaSeleccionada,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2026),
                        onDateChanged: (date) =>
                            setState(() => _fechaSeleccionada = date),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Selecciona la hora:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      onTap: () => _seleccionarHora(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      leading: const Icon(
                        Icons.access_time,
                        color: Color(0xFF2D936C),
                      ),
                      title: Text(
                        _horaSeleccionada.format(context),
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: const Icon(Icons.arrow_drop_down),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          final user = Provider.of<LoginViewModel>(
                            context,
                            listen: false,
                          ).user;
                          if (user == null) return;

                          final fechaFinal = DateTime(
                            _fechaSeleccionada.year,
                            _fechaSeleccionada.month,
                            _fechaSeleccionada.day,
                            _horaSeleccionada.hour,
                            _horaSeleccionada.minute,
                          );

                          final nuevaCita = {
                            "pacienteId": user.id,
                            "doctorId": _selectedDoctorId ?? widget.doctorId,
                            "doctorNombre":
                                _selectedDoctorName ?? widget.doctorNombre,
                            "fechaHora": fechaFinal.toIso8601String(),
                            "motivo": "Consulta General",
                          };

                          final guardadoLocal = await _guardarCitaLocal(
                            nuevaCita,
                          );
                          if (!context.mounted) return;

                          if (guardadoLocal) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "¡Cita guardada con éxito!",
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Error al guardar la cita.",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D936C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Confirmar Cita",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Botón para volver a la lista
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            doctorChoosed = false;
                            _selectedDoctorName = null;
                            _selectedDoctorId = null;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Volver',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
