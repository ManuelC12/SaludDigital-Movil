import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // Descomenta cuando uses el Provider
// import '../viewmodels/citas_viewmodel.dart'; // Descomenta cuando conectes el ViewModel

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  // VARIABLES DE ESTADO (Ahora se actualizarán, así que no darán error de 'final')
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  
  final String _terapeuta = "Dra. Ana López"; // Esto podrías recibirlo por parámetro

  // FUNCIÓN PARA SELECCIONAR HORA
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF2D936C)),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reservar Sesión"),
        backgroundColor: const Color(0xFF2D936C),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // INFO DEL TERAPEUTA
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE8F5E9),
                child: Icon(Icons.person, color: Color(0xFF2D936C)),
              ),
              title: Text(_terapeuta, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Psicóloga Clínica • Especialista en Ansiedad"),
            ),
            const Divider(height: 30),
            
            // SELECTOR DE FECHA (Esto soluciona el 'prefer_final_fields' de _selectedDate)
            const Text("Selecciona Fecha:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CalendarDatePicker(
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
                onDateChanged: (date) {
                  // ALERTA: Esta es la parte clave. Al asignar un nuevo valor,
                  // Dart entiende que la variable NO debe ser 'final'.
                  setState(() {
                    _selectedDate = date; 
                  });
                },
              ),
            ),
            
            const SizedBox(height: 20),

            // SELECTOR DE HORA
            const Text("Selecciona Hora:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            ListTile(
              onTap: () => _selectTime(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey.shade300)
              ),
              leading: const Icon(Icons.access_time, color: Color(0xFF2D936C)),
              title: Text(
                _selectedTime.format(context),
                style: const TextStyle(fontSize: 16),
              ),
              trailing: const Icon(Icons.arrow_drop_down),
            ),
            
            const Spacer(),
            
            // BOTÓN CONFIRMAR
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Combinar fecha y hora
                  final fechaFinal = DateTime(
                    _selectedDate.year, 
                    _selectedDate.month, 
                    _selectedDate.day,
                    _selectedTime.hour, 
                    _selectedTime.minute
                  );
                  
                  // SOLUCIÓN A 'AVOID_PRINT':
                  // En lugar de print(), usamos debugPrint() o mostramos un mensaje visual.
                  debugPrint("Intentando agendar para: $fechaFinal"); 

                  // Aquí llamarías a tu servicio:
                  // Provider.of<CitasViewModel>(context, listen: false).agendarCita(...)

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Procesando reserva..."),
                      backgroundColor: Color(0xFF2D936C),
                    )
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D936C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Confirmar Reserva", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}