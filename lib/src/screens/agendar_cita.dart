import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import '../services/citas_service.dart';

class AgendarCitaScreen extends StatefulWidget {
  final int doctorId;
  final String doctorNombre;

  const AgendarCitaScreen({super.key, required this.doctorId, required this.doctorNombre});

  @override
  State<AgendarCitaScreen> createState() => _AgendarCitaScreenState();
}

class _AgendarCitaScreenState extends State<AgendarCitaScreen> {
  DateTime _fechaSeleccionada = DateTime.now();
  TimeOfDay _horaSeleccionada = TimeOfDay.now(); // Ahora sí cambiaremos su valor
  
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reserva con ${widget.doctorNombre}"),
        backgroundColor: const Color(0xFF2D936C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Selecciona la fecha:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            // Calendario (Limitado en altura para que no ocupe todo)
            Container(
              height: 280, 
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12)
              ),
              child: CalendarDatePicker(
                initialDate: _fechaSeleccionada,
                firstDate: DateTime.now(),
                lastDate: DateTime(2026),
                onDateChanged: (date) => setState(() => _fechaSeleccionada = date),
              ),
            ),
            
            const SizedBox(height: 20),

            // Selector de Hora (Soluciona el warning de prefer_final_fields)
            const Text("Selecciona la hora:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListTile(
              onTap: () => _seleccionarHora(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              leading: const Icon(Icons.access_time, color: Color(0xFF2D936C)),
              title: Text(
                _horaSeleccionada.format(context),
                style: const TextStyle(fontSize: 16),
              ),
              trailing: const Icon(Icons.arrow_drop_down),
            ),

            const Spacer(),
            
         SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final user = Provider.of<LoginViewModel>(context, listen: false).user;
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
                    "doctorId": widget.doctorId,
                    "fechaHora": fechaFinal.toIso8601String(),
                    "motivo": "Consulta General"
                  };

                  // 1. Llamada asíncrona
                  bool exito = await _service.crearCita(nuevaCita);
                  
                  // 2. VERIFICACIÓN DE SEGURIDAD (Esto elimina el error)
                  if (!context.mounted) return; 

                  // 3. Uso del contexto (ahora seguro)
                  if (exito) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("¡Cita creada con éxito!")),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Error al agendar. Verifica tu conexión."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D936C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Confirmar Cita", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}