import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import '../services/citas_service.dart';
import 'agendar_cita.dart'; // Tu pantalla de agendar
//import 'home.dart'; // Para la navegación inferior

class PatientAppointmentsScreen extends StatefulWidget {
  const PatientAppointmentsScreen({super.key});

  @override
  State<PatientAppointmentsScreen> createState() => _PatientAppointmentsScreenState();
}

class _PatientAppointmentsScreenState extends State<PatientAppointmentsScreen> {
  final CitasService _citasService = CitasService();

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
          : FutureBuilder(
              // Usamos el ID del usuario (asegúrate que sea String como corregimos antes)
              future: _citasService.obtenerCitasPaciente(user.id),
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
                        const Icon(Icons.event_busy, size: 80, color: Colors.grey),
                        const SizedBox(height: 20),
                        const Text("No tienes citas próximas", style: TextStyle(fontSize: 18, color: Colors.grey)),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _irAgendar(context),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2D936C)),
                          child: const Text("Agendar mi primera cita"),
                        )
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: citas.length,
                  itemBuilder: (context, index) {
                    final cita = citas[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.calendar_today, color: Color(0xFF2D936C)),
                        ),
                        title: Text("Dr/a. ${cita['terapeuta']?['name'] ?? 'Especialista'}"),
                        subtitle: Text(
                          "${cita['fechaHora'].toString().substring(0, 16)}\nEstado: ${cita['estado']}",
                          style: const TextStyle(height: 1.5),
                        ),
                        isThreeLine: true,
                        trailing: cita['linkVideollamada'] != null && cita['linkVideollamada'].toString().isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.video_call, color: Colors.green, size: 30),
                                onPressed: () {
                                  // Aquí abrirías el link
                                },
                              )
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _irAgendar(context),
        backgroundColor: const Color(0xFF2D936C),
        icon: const Icon(Icons.add),
        label: const Text("Nueva Cita"),
      ),
    );
  }

  void _irAgendar(BuildContext context) {
    // Aquí deberías navegar a una pantalla para seleccionar doctor primero, 
    // o ir directo a AgendarCitaScreen pasando un doctor predeterminado/seleccionado.
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => const AgendarCitaScreen(doctorId: 1, doctorNombre: "Dr. General")) // Ajusta el ID según tu lógica
    ).then((_) => setState(() {})); // Recargar al volver
  }
}