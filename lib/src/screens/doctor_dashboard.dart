import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import '../services/citas_service.dart';

class DoctorDashboard extends StatelessWidget {
  const DoctorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<LoginViewModel>(context).user;
    final service = CitasService();

    return Scaffold(
      appBar: AppBar(title: const Text("Agenda del Especialista")),
      body: FutureBuilder(
        // CORRECCIÓN: Ahora user.id es String y el servicio acepta String.
        // Usamos '' por defecto si user es null.
        future: service.obtenerCitasDoctor(user?.id ?? ''), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return const Center(child: Text("No tienes citas hoy"));
          }

          final citas = snapshot.data as List;

          return ListView.builder(
            itemCount: citas.length,
            itemBuilder: (context, index) {
              final cita = citas[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  // Manejo seguro de nulos en la respuesta JSON
                  title: Text("Paciente: ${cita['paciente']?['name'] ?? 'Desconocido'}"),
                  subtitle: Text("Fecha: ${cita['fechaHora']}\nLink: ${cita['linkVideollamada']}"),
                  isThreeLine: true,
                  trailing: const Icon(Icons.video_call, color: Colors.green),
                ),
              );
            },
          );
        },
      ),
    );
  }
}