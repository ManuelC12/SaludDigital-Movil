import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
// import '../services/citas_service.dart';
import 'agendar_cita.dart'; // Tu pantalla de agendar
//import 'home.dart'; // Para la navegación inferior

class PatientAppointmentsScreen extends StatefulWidget {
  const PatientAppointmentsScreen({super.key});

  @override
  State<PatientAppointmentsScreen> createState() =>
      _PatientAppointmentsScreenState();
}

class _PatientAppointmentsScreenState extends State<PatientAppointmentsScreen> {
  // final CitasService _citasService = CitasService();

  Future<File> _localFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/citas_locales.json');
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString('[]', flush: true);
    }
    return file;
  }

  Future<List<dynamic>> _leerCitasLocales() async {
    try {
      final file = await _localFile();
      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];
      final List<dynamic> lista = jsonDecode(content);
      return lista;
    } catch (e) {
      // ignore: avoid_print
      print('Error leyendo citas locales: $e');
      return [];
    }
  }

  Future<bool> _escribirCitasLista(List<dynamic> lista) async {
    try {
      final file = await _localFile();
      final encoded = const JsonEncoder.withIndent('  ').convert(lista);
      await file.writeAsString(encoded, flush: true);
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Error escribiendo citas locales: $e');
      return false;
    }
  }

  Future<bool> _eliminarCitaLocal(int index) async {
    try {
      final lista = await _leerCitasLocales();
      if (index < 0 || index >= lista.length) return false;
      lista.removeAt(index);
      final ok = await _escribirCitasLista(lista);
      return ok;
    } catch (e) {
      // ignore: avoid_print
      print('Error eliminando cita local: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginViewModel>(context).user;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Mis Citas Médicas"),
        backgroundColor: const Color(0xFF2D936C),
        elevation: 0,
      ),
      body: user == null
          ? const Center(child: Text("Error de sesión"))
          : FutureBuilder<List<dynamic>>(
              future: _leerCitasLocales(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final citas = snapshot.data ?? [];

                if (citas.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.event_busy,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "No tienes citas próximas",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _irAgendar(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D936C),
                          ),
                          child: const Text(
                            "Agendar mi primera cita",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: citas.length,
                  itemBuilder: (context, index) {
                    final cita = citas[index] as Map<String, dynamic>;
                    final doctorNombre = cita['doctorNombre'] ?? 'Especialista';
                    final fechaHora = cita['fechaHora'] ?? '';
                    final motivo = cita['motivo'] ?? '';
                    final estado = cita['estado'] ?? '';

                    DateTime? parsed;
                    try {
                      parsed = DateTime.parse(fechaHora);
                    } catch (_) {
                      parsed = null;
                    }

                    String fechaTexto;
                    if (parsed != null) {
                      final now = DateTime.now();
                      // comparar por fecha (sin horas) para contar días completos
                      final parsedDateOnly = DateTime(
                        parsed.year,
                        parsed.month,
                        parsed.day,
                      );
                      final nowDateOnly = DateTime(
                        now.year,
                        now.month,
                        now.day,
                      );
                      final diffDays = parsedDateOnly
                          .difference(nowDateOnly)
                          .inDays;

                      String twoDigits(int n) => n.toString().padLeft(2, '0');
                      final hourMin =
                          '${twoDigits(parsed.hour)}:${twoDigits(parsed.minute)}';

                      if (diffDays >= 0 && diffDays <= 2) {
                        if (diffDays == 0) {
                          // Calcular horas y minutos restantes (o pasadas) si la cita es hoy
                          final nowFull = DateTime.now();
                          final diff = parsed.difference(nowFull);
                          final minutes = diff.inMinutes.abs();
                          final hoursPart = minutes ~/ 60;
                          final minutesPart = minutes % 60;
                          String remainingText;
                          if (diff.inMinutes > 0) {
                            if (hoursPart > 0) {
                              remainingText =
                                  ' (en ${hoursPart}h ${minutesPart}m)';
                            } else {
                              remainingText = ' (en ${minutesPart}m)';
                            }
                          } else if (diff.inMinutes < 0) {
                            if (hoursPart > 0) {
                              remainingText =
                                  ' (hace ${hoursPart}h ${minutesPart}m)';
                            } else {
                              remainingText = ' (hace ${minutesPart}m)';
                            }
                          } else {
                            remainingText = ' (ahora)';
                          }

                          fechaTexto = 'Hoy $hourMin$remainingText';
                        } else if (diffDays == 1) {
                          fechaTexto = 'Dentro de 1 día';
                        } else {
                          fechaTexto = 'Dentro de 2 días';
                        }
                      } else {
                        // Mostrar en formato HH:mm DD/MM/YYYY
                        fechaTexto =
                            '${hourMin} ${twoDigits(parsed.day)}/${twoDigits(parsed.month)}/${parsed.year}';
                      }
                    } else {
                      fechaTexto = fechaHora.toString();
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.calendar_today,
                            color: Color(0xFF2D936C),
                          ),
                        ),
                        title: Text(doctorNombre.toString()),
                        subtitle: Text(
                          '$fechaTexto\nMotivo: $motivo${estado.isNotEmpty ? '\nEstado: $estado' : ''}',
                          style: const TextStyle(height: 1.5),
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Cancelar cita'),
                                content: const Text(
                                  '¿Deseas eliminar esta cita?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text(
                                      'Sí',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              final ok = await _eliminarCitaLocal(index);
                              if (ok) {
                                // Recargar la pantalla
                                if (mounted) {
                                  setState(() {});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Cita eliminada'),
                                    ),
                                  );
                                }
                              } else {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'No se pudo eliminar la cita',
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _irAgendar(context),
        backgroundColor: const Color(0xFF2D936C),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Nueva Cita", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _irAgendar(BuildContext context) {
    // Aquí deberías navegar a una pantalla para seleccionar doctor primero,
    // o ir directo a AgendarCitaScreen pasando un doctor predeterminado/seleccionado.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const AgendarCitaScreen(doctorId: 1, doctorNombre: "Dr. General"),
      ), // Ajusta el ID según tu lógica
    ).then((_) => setState(() {})); // Recargar al volver
  }
}
