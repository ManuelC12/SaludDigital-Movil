import 'dart:ui';
import 'package:flutter/material.dart';
import 'home.dart';
import 'agenda.dart';
import 'profile.dart';
import 'patient_appointments.dart';
// --- MODELOS DE DATOS ---
class StepItem {
  final String titulo;
  final String instruccion;
  final String icono;
  final int duracionSeg;

  StepItem({
    required this.titulo,
    required this.instruccion,
    required this.icono,
    required this.duracionSeg,
  });
}

class Routine {
  final int id;
  final String titulo;
  final String descripcion;
  final String icono;
  final int duracionTotal;
  final List<String> emocionesTarget; // Nueva propiedad para el filtro
  final List<StepItem> pasos;

  Routine({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.duracionTotal,
    required this.emocionesTarget,
    required this.pasos,
  });
}

class RutinasScreen extends StatefulWidget {
  const RutinasScreen({super.key});

  @override
  State<RutinasScreen> createState() => _RutinasScreenState();
}

class _RutinasScreenState extends State<RutinasScreen> {
  // COLORES
  final Color greenDark = const Color(0xFF1A3C2F);
  final Color greenPrimary = const Color(0xFF2D936C);
  final Color greenLight = const Color(0xFFA8E6CF);

  // ESTADO
  String? _emocionSeleccionada; // Si es null, mostramos el selector. Si tiene valor, la lista.
  List<Routine> _rutinasVisibles = [];
  
  // ESTADO DEL REPRODUCTOR
  Routine? _activeRoutine;
  int _currentStepIndex = 0;
  bool _showCelebration = false;

  // --- CATÁLOGO DE RUTINAS (Datos de tu Angular) ---
  final List<Routine> _allRutinas = [
    Routine(
      id: 1,
      titulo: 'Mañana Zen ☀️',
      descripcion: 'Empieza el día con claridad y sin el celular.',
      icono: '🌅',
      duracionTotal: 5,
      emocionesTarget: ['cansancio', 'tristeza'],
      pasos: [
        StepItem(titulo: 'Hidratación', instruccion: 'Bebe un vaso grande de agua para despertar tu cerebro.', icono: '💧', duracionSeg: 30),
        StepItem(titulo: 'Estiramiento', instruccion: 'Estira los brazos hacia el techo y toca tus pies suavemente.', icono: '🙆', duracionSeg: 60),
        StepItem(titulo: 'Luz Natural', instruccion: 'Abre la ventana y deja que el sol toque tu cara.', icono: '☀️', duracionSeg: 60),
        StepItem(titulo: 'Intención', instruccion: 'Di en voz alta: "Hoy elijo estar en paz".', icono: '🗣️', duracionSeg: 30),
      ],
    ),
    Routine(
      id: 2,
      titulo: 'SOS: Calma el Pánico 🚨',
      descripcion: 'Intervención rápida para crisis de ansiedad.',
      icono: '🛑',
      duracionTotal: 3,
      emocionesTarget: ['ansiedad', 'estres'],
      pasos: [
        StepItem(titulo: 'Alto Total', instruccion: 'Deja lo que estés haciendo. Siéntate y pon los pies firmes en el suelo.', icono: '🦶', duracionSeg: 15),
        StepItem(titulo: 'Respiración 4-7-8', instruccion: 'Inhala en 4s, Retén el aire 7s, Exhala en 8s. (Repetiremos 3 veces).', icono: '🌬️', duracionSeg: 60),
        StepItem(titulo: 'Hielo o Agua', instruccion: 'Mójate la cara con agua fría o sostén un hielo. Esto resetea tu sistema nervioso.', icono: '🧊', duracionSeg: 45),
        StepItem(titulo: 'Grounding 5-4-3-2-1', instruccion: 'Nombra 5 cosas que ves y 4 que puedes tocar ahora mismo.', icono: '👀', duracionSeg: 60),
      ],
    ),
    Routine(
      id: 3,
      titulo: 'Dulces Sueños 🌙',
      descripcion: 'Desconecta tu mente para dormir profundo.',
      icono: '🛌',
      duracionTotal: 10,
      emocionesTarget: ['cansancio', 'estres'],
      pasos: [
        StepItem(titulo: 'Adiós Pantallas', instruccion: 'Pon el celular en modo "No Molestar" y aléjalo de la cama.', icono: '📵', duracionSeg: 30),
        StepItem(titulo: 'Descarga Mental', instruccion: 'Si tienes pendientes, anótalos en un papel para sacarlos de tu cabeza.', icono: '📝', duracionSeg: 120),
        StepItem(titulo: 'Gratitud', instruccion: 'Piensa en 3 cosas pequeñas que salieron bien hoy.', icono: '🙏', duracionSeg: 60),
        StepItem(titulo: 'Escaneo Corporal', instruccion: 'Acuéstate y relaja: Dedos de los pies, piernas, estómago, hombros y mandíbula.', icono: '✨', duracionSeg: 180),
      ],
    ),
    Routine(
      id: 4,
      titulo: 'Abrazo al Corazón ❤️',
      descripcion: 'Autocompasión para cuando te sientes bajo de ánimo.',
      icono: '🩹',
      duracionTotal: 6,
      emocionesTarget: ['tristeza', 'soledad'],
      pasos: [
        StepItem(titulo: 'Mano al Pecho', instruccion: 'Pon una mano sobre tu corazón y la otra en tu estómago. Siente tu calor.', icono: '👐', duracionSeg: 60),
        StepItem(titulo: 'Validación', instruccion: 'Repite: "Es válido sentirme así. No tengo que estar bien todo el tiempo".', icono: '💭', duracionSeg: 60),
        StepItem(titulo: 'Bebida Caliente', instruccion: 'Prepárate un té o café caliente. Siente el aroma y el calor de la taza.', icono: '☕', duracionSeg: 120),
        StepItem(titulo: 'Mensaje Amable', instruccion: 'Envíale un mensaje a alguien que quieras, o escríbete una nota amable a ti mismo.', icono: '💌', duracionSeg: 60),
      ],
    ),
    Routine(
      id: 5,
      titulo: 'Desbloqueo Mental 🧠',
      descripcion: 'Recupera el enfoque cuando te sientes abrumado.',
      icono: '⚡',
      duracionTotal: 4,
      emocionesTarget: ['estres', 'cansancio'],
      pasos: [
        StepItem(titulo: 'Ventilación', instruccion: 'Abre una ventana. El aire fresco oxigena el cerebro.', icono: '💨', duracionSeg: 30),
        StepItem(titulo: 'Micro-Orden', instruccion: 'Ordena SOLO lo que está frente a ti en tu mesa/escritorio.', icono: '🧹', duracionSeg: 60),
        StepItem(titulo: 'Una sola cosa', instruccion: 'Elige UNA sola tarea pequeña para hacer en los próximos 5 minutos.', icono: '1️⃣', duracionSeg: 60),
        StepItem(titulo: 'Empezar', instruccion: 'Cuenta 5, 4, 3, 2, 1... ¡Y empieza!', icono: '🚀', duracionSeg: 10),
      ],
    ),
    Routine(
      id: 6,
      titulo: 'Caminata Consciente 🚶',
      descripcion: 'Movimiento suave para salir de tu cabeza.',
      icono: '🌳',
      duracionTotal: 15,
      emocionesTarget: ['ansiedad', 'tristeza', 'estres'],
      pasos: [
        StepItem(titulo: 'Zapatos', instruccion: 'Ponte zapatos cómodos. Vamos a salir (o caminar por la casa).', icono: '👟', duracionSeg: 60),
        StepItem(titulo: 'Sin Audífonos', instruccion: 'Intenta no usar música por unos minutos. Escucha el mundo.', icono: '👂', duracionSeg: 10),
        StepItem(titulo: 'Ritmo', instruccion: 'Camina a un ritmo normal. Siente cómo tus pies tocan el suelo.', icono: '👣', duracionSeg: 300),
        StepItem(titulo: 'Colores', instruccion: 'Busca 5 cosas de color verde y 5 de color azul mientras caminas.', icono: '🎨', duracionSeg: 180),
      ],
    ),
  ];

  // --- LÓGICA DE FILTRADO ---
  void _seleccionarEmocion(String emocion) {
    setState(() {
      _emocionSeleccionada = emocion;
      _rutinasVisibles = _allRutinas.where((r) => r.emocionesTarget.contains(emocion)).toList();
    });
  }

  void _limpiarSeleccion() {
    setState(() {
      _emocionSeleccionada = null;
      _rutinasVisibles = [];
    });
  }

  String _obtenerNombreEmocion(String cod) {
    switch (cod) {
      case 'estres': return 'Estrés y Abrumación';
      case 'ansiedad': return 'Ansiedad y Nervios';
      case 'cansancio': return 'Cansancio Mental';
      case 'tristeza': return 'Tristeza o Soledad';
      default: return cod;
    }
  }

  // --- LÓGICA DEL REPRODUCTOR ---
  void _iniciarRutina(Routine rutina) {
    setState(() {
      _activeRoutine = rutina;
      _currentStepIndex = 0;
      _showCelebration = false;
    });
  }

  void _nextStep() {
    if (_activeRoutine != null) {
      if (_currentStepIndex < _activeRoutine!.pasos.length - 1) {
        setState(() {
          _currentStepIndex++;
        });
      } else {
        setState(() {
          _activeRoutine = null;
          _showCelebration = true;
        });
      }
    }
  }

  void _prevStep() {
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
      });
    }
  }

  void _closeRoutine() {
    // Diálogo de confirmación simple
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("¿Detener rutina?", style: TextStyle(color: greenDark)),
        content: const Text("Perderás el progreso actual."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _activeRoutine = null;
                _currentStepIndex = 0;
              });
            },
            child: Text("Salir", style: TextStyle(color: greenPrimary)),
          ),
        ],
      ),
    );
  }

  void _finalizarTodo() {
    setState(() {
      _showCelebration = false;
      _currentStepIndex = 0;
      _emocionSeleccionada = null; // Volver al inicio
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. FONDO DEGRADADO
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [greenLight, greenPrimary],
              ),
            ),
          ),

          // 2. CONTENIDO PRINCIPAL
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        "Rutinas Guiadas",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      if (_emocionSeleccionada == null)
                        Text(
                          "Elige cómo te sientes para empezar:",
                          style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.9)),
                        )
                      else
                        Text(
                          "Recetas para: ${_obtenerNombreEmocion(_emocionSeleccionada!)}",
                          style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),

                // CONTENIDO CAMBIANTE (GRID O LISTA)
                Expanded(
                  child: _emocionSeleccionada == null 
                    ? _buildMoodGrid() 
                    : _buildRoutineList(),
                ),
              ],
            ),
          ),

          // 3. BARRA DE NAVEGACIÓN
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    border: const Border(top: BorderSide(color: Colors.white30)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(Icons.self_improvement, "Meditar", false, onTap: () {
                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                      }),
                      // Rutinas (Activo)
                      _buildNavItem(Icons.spa, "Rutinas", true, onTap: () {}),
                      
      

                      _buildNavItem(Icons.calendar_month, "Mi Diario", false, onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => const AgendaScreen()));
                      }),
          


                       _buildNavItem(Icons.medical_services, "Citas", false, onTap: () {
  Navigator.push(context, MaterialPageRoute(builder: (context) => const PatientAppointmentsScreen()));
}),
                      _buildNavItem(Icons.person, "Perfil", false, onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 4. OVERLAY REPRODUCTOR
          if (_activeRoutine != null)
            _buildRoutinePlayer(),

          // 5. OVERLAY CELEBRACIÓN
          if (_showCelebration)
            _buildCelebrationOverlay(),
        ],
      ),
    );
  }

  // --- VISTAS INTERNAS ---

  // VISTA 1: SELECTOR DE EMOCIONES
  Widget _buildMoodGrid() {
    return GridView.count(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.1,
      children: [
        _buildMoodCard("😫", "Estrés", "estres"),
        _buildMoodCard("😰", "Ansiedad", "ansiedad"),
        _buildMoodCard("😴", "Cansancio", "cansancio"),
        _buildMoodCard("😔", "Tristeza", "tristeza"),
      ],
    );
  }

  Widget _buildMoodCard(String emoji, String label, String code) {
    return GestureDetector(
      onTap: () => _seleccionarEmocion(code),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            Text(label, style: TextStyle(color: greenDark, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // VISTA 2: LISTA DE RUTINAS
  Widget _buildRoutineList() {
    return Column(
      children: [
        // Botón volver
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TextButton.icon(
            onPressed: _limpiarSeleccion,
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
            label: const Text("Elegir otra emoción", style: TextStyle(color: Colors.white, decoration: TextDecoration.underline)),
          ),
        ),
        
        Expanded(
          child: _rutinasVisibles.isEmpty 
            ? const Center(child: Text("No hay rutinas específicas para esto aún.", style: TextStyle(color: Colors.white)))
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                itemCount: _rutinasVisibles.length,
                itemBuilder: (context, index) {
                  return _buildRoutineCard(_rutinasVisibles[index]);
                },
              ),
        ),
      ],
    );
  }

  Widget _buildRoutineCard(Routine routine) {
    return GestureDetector(
      onTap: () => _iniciarRutina(routine),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3), // Un poco más claro que el fondo
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Center(child: Text(routine.icono, style: const TextStyle(fontSize: 30))),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(routine.titulo, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: greenDark)),
                  const SizedBox(height: 5),
                  Text(routine.descripcion, style: TextStyle(fontSize: 12, color: greenDark.withValues(alpha: 0.8), height: 1.3)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildTag("⏱ ${routine.duracionTotal} min"),
                      const SizedBox(width: 8),
                      _buildTag("${routine.pasos.length} Pasos"),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: greenPrimary,
              radius: 18,
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
            )
          ],
        ),
      ),
    );
  }

  // REPRODUCTOR OVERLAY
  Widget _buildRoutinePlayer() {
    final step = _activeRoutine!.pasos[_currentStepIndex];
    final progress = (_currentStepIndex + 1) / _activeRoutine!.pasos.length;

    return Positioned.fill(
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: const Color(0xFFE6F5EB).withValues(alpha: 0.98), // Fondo casi sólido
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: SafeArea(
              child: Column(
                children: [
                  // Header Progreso
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: greenDark, size: 28),
                        onPressed: _closeRoutine,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.black12,
                            color: greenPrimary,
                            minHeight: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        "${_currentStepIndex + 1}/${_activeRoutine!.pasos.length}",
                        style: TextStyle(fontWeight: FontWeight.bold, color: greenDark),
                      )
                    ],
                  ),

                  const Spacer(),

                  // Contenido del Paso
                  Text(step.icono, style: const TextStyle(fontSize: 80)),
                  const SizedBox(height: 30),
                  Text(
                    step.titulo,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: greenPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    step.instruccion,
                    style: TextStyle(fontSize: 18, height: 1.5, color: greenDark.withValues(alpha: 0.9)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  
                  // Hint de duración
                  if(step.duracionSeg > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "⏳ Duración sugerida: ${step.duracionSeg} seg",
                        style: TextStyle(fontSize: 14, color: greenDark.withValues(alpha: 0.7)),
                      ),
                    ),

                  const Spacer(),

                  // Controles
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _currentStepIndex > 0 ? _prevStep : null, // Disabled if 0
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            side: BorderSide(color: greenDark.withValues(alpha: _currentStepIndex > 0 ? 1 : 0.3)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: Text("← Atrás", style: TextStyle(color: greenDark.withValues(alpha: _currentStepIndex > 0 ? 1 : 0.3), fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      
                      const SizedBox(width: 20),

                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: _nextStep,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: greenDark,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 5,
                          ),
                          child: Text(
                            _currentStepIndex == _activeRoutine!.pasos.length - 1 ? 'Finalizar ✨' : 'Siguiente ➜',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCelebrationOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.6),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(30),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("✨🌿✨", style: TextStyle(fontSize: 50)),
                const SizedBox(height: 20),
                Text("¡Lo lograste!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: greenPrimary)),
                const SizedBox(height: 10),
                const Text(
                  "Has dedicado tiempo valioso para ti.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _finalizarTodo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text("Volver al menú", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: greenDark.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: greenDark)),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: isActive ? greenPrimary : greenDark),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.w500, color: isActive ? greenPrimary : greenDark)),
          ],
        ),
      ),
    );
  }
}