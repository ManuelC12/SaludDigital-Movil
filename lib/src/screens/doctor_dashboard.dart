import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salud_digital/src/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../viewmodels/login_viewmodel.dart';
import '../services/citas_service.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  final Color greenDark = const Color.fromRGBO(26, 60, 47, 1);
  final Color greenPrimary = const Color.fromRGBO(45, 147, 108, 1);
  final CitasService service = CitasService();

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // Solo borramos los datos de la sesión actual, no la agenda
    await prefs.remove('userData');
    await prefs.remove('isLoggedIn');

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginViewModel>(context).user;

    return Scaffold(
      appBar: AppBar(title: const Text("Agenda del Especialista")),
      body: Stack(
        children: [
          FutureBuilder<List<dynamic>>(
            future: service.leerCitasLocales(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final todas = snapshot.data ?? [];
              // Filtrar por doctorId igual al id del usuario (toString para seguridad)
              final citas = todas.where((c) {
                try {
                  final doctorId = c['doctorId'];
                  return doctorId.toString() == (user?.id?.toString() ?? '');
                } catch (_) {
                  return false;
                }
              }).toList();

              if (todas.isEmpty) {
                return const Center(child: Text("No tienes citas hoy"));
              }

              return ListView.builder(
                itemCount: todas.length,
                itemBuilder: (context, index) {
                  final cita = Map<String, dynamic>.from(todas[index]);
                  final estado = cita['estado'] ?? 'pendiente';
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        "Paciente: ${cita['pacienteNombre'] ?? cita['pacienteId'] ?? 'Desconocido'}",
                      ),
                      subtitle: Text(
                        "Fecha: ${cita['fechaHora']}\nMotivo: ${cita['motivo'] ?? ''}\nEstado: $estado",
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            tooltip: 'Confirmar',
                            onPressed: () async {
                              // Encontrar índice real en la lista completa para actualizar
                              final all = await service.leerCitasLocales();
                              final realIndex = all.indexWhere((item) {
                                try {
                                  return item['fechaHora'] ==
                                          cita['fechaHora'] &&
                                      item['doctorId'].toString() ==
                                          cita['doctorId'].toString() &&
                                      item['pacienteId'].toString() ==
                                          cita['pacienteId'].toString();
                                } catch (_) {
                                  return false;
                                }
                              });
                              if (realIndex == -1) return;
                              final ok = await service.confirmarCitaPorIndice(
                                realIndex,
                              );
                              if (ok && mounted) setState(() {});
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            tooltip: 'Cancelar',
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Cancelar cita'),
                                  content: const Text(
                                    '¿Deseas cancelar esta cita?',
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
                              if (confirm != true) return;
                              final all = await service.leerCitasLocales();
                              final realIndex = all.indexWhere((item) {
                                try {
                                  return item['fechaHora'] ==
                                          cita['fechaHora'] &&
                                      item['doctorId'].toString() ==
                                          cita['doctorId'].toString() &&
                                      item['pacienteId'].toString() ==
                                          cita['pacienteId'].toString();
                                } catch (_) {
                                  return false;
                                }
                              });
                              if (realIndex == -1) return;
                              final ok = await service.cancelarCitaPorIndice(
                                realIndex,
                              );
                              if (ok && mounted) setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenPrimary,
                  ),
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    'Cerrar sesión',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => _logout(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
