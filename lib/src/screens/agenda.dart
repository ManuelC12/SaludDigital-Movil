import 'dart:convert'; 
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'home.dart';
import 'profile.dart';
import 'rutinas.dart';
import 'patient_appointments.dart';
// --- MODELO ---
class DiaryEntry {
  final String id;
  final DateTime date;
  final String title;
  final String reflection;
  final String mood;
  final int sleepHours;
  final int waterGlasses;
  final String gratitude;

  DiaryEntry({
    required this.id,
    required this.date,
    required this.title,
    required this.reflection,
    required this.mood,
    required this.sleepHours,
    required this.waterGlasses,
    required this.gratitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'title': title,
      'reflection': reflection,
      'mood': mood,
      'sleepHours': sleepHours,
      'waterGlasses': waterGlasses,
      'gratitude': gratitude,
    };
  }

  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['id'],
      date: DateTime.parse(json['date']),
      title: json['title'],
      reflection: json['reflection'],
      mood: json['mood'],
      sleepHours: json['sleepHours'],
      waterGlasses: json['waterGlasses'],
      gratitude: json['gratitude'],
    );
  }
}

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  final Color greenDark = const Color(0xFF1A3C2F);
  final Color greenPrimary = const Color(0xFF2D936C);
  final Color greenLight = const Color(0xFFA8E6CF);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _reflectionController = TextEditingController();
  final TextEditingController _sleepController = TextEditingController();
  final TextEditingController _waterController = TextEditingController();
  final TextEditingController _gratitudeController = TextEditingController();
  
  String _selectedMood = 'happy';
  DateTime _selectedDate = DateTime.now();
  
  List<DiaryEntry> _entries = []; 

  @override
  void initState() {
    super.initState();
    _loadEntries(); 
  }

  @override
  void dispose() {
    _titleController.dispose();
    _reflectionController.dispose();
    _sleepController.dispose();
    _waterController.dispose();
    _gratitudeController.dispose();
    super.dispose();
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? entriesString = prefs.getString('diary_entries');

    if (entriesString != null) {
      List<dynamic> jsonList = jsonDecode(entriesString);
      setState(() {
        _entries = jsonList.map((json) => DiaryEntry.fromJson(json)).toList();
      });
    }
  }

  Future<void> _saveEntriesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String encodedData = jsonEncode(_entries.map((e) => e.toJson()).toList());
    await prefs.setString('diary_entries', encodedData);
  }

  void _saveEntry() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, escribe un título'))
      );
      return;
    }

    setState(() {
      _entries.insert(0, DiaryEntry(
        id: DateTime.now().toString(),
        date: _selectedDate,
        title: _titleController.text,
        reflection: _reflectionController.text,
        mood: _selectedMood,
        sleepHours: int.tryParse(_sleepController.text) ?? 0,
        waterGlasses: int.tryParse(_waterController.text) ?? 0,
        gratitude: _gratitudeController.text,
      ));
    });

    _saveEntriesToPrefs(); 

    _titleController.clear();
    _reflectionController.clear();
    _sleepController.clear();
    _waterController.clear();
    _gratitudeController.clear();
    _selectedMood = 'happy';
    FocusScope.of(context).unfocus(); 

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Guardado en tu diario! 📖'))
    );
  }

  void _deleteEntry(String id) {
    setState(() {
      _entries.removeWhere((element) => element.id == id);
    });
    _saveEntriesToPrefs();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: greenPrimary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  // --- LÓGICA DE RECOMENDACIÓN MEJORADA ---
  Map<String, String> _getRecomendacion() {
    switch (_selectedMood) {
      case 'sad':
        return {
          'titulo': 'Está bien no estar bien 💙',
          'texto': 'La tristeza es temporal. Prueba la rutina "SOS: Calma" o escribe todo lo que sientes aquí.',
          'icono': '🌧️'
        };
      case 'tired':
        return {
          'titulo': 'Tu cuerpo pide descanso 🌙',
          'texto': 'No te exijas demasiado hoy. Intenta la rutina "Desconexión Nocturna" y duerme temprano.',
          'icono': '🔋'
        };
      case 'anxious':
        return {
          'titulo': 'Respira, estás a salvo 🍃',
          'texto': 'La ansiedad miente. Haz 5 minutos de "Respiración 4-7-8" para bajar las revoluciones.',
          'icono': '💨'
        };
      case 'irritated':
        return {
          'titulo': 'Libera esa tensión 🔥',
          'texto': 'Haz algo físico o sal a caminar. Canaliza esa energía en movimiento para despejarte.',
          'icono': '⚡'
        };
      case 'neutral':
        return {
          'titulo': 'Un día tranquilo 🍃',
          'texto': 'Es un buen momento para una meditación corta de "Enfoque" y mantener el equilibrio.',
          'icono': '😐'
        };
      case 'happy':
      default:
        return {
          'titulo': '¡Qué bueno verte así! ☀️',
          'texto': 'Aprovecha esta energía positiva. ¿Qué tal si agradeces 3 cosas nuevas hoy?',
          'icono': '✨'
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final recomendacion = _getRecomendacion();

    return Scaffold(
      body: Stack(
        children: [
          // 1. FONDO
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [greenLight, greenPrimary],
              ),
            ),
          ),

          // 2. CONTENIDO
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      const Text("Mi Diario", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                      // ignore: deprecated_member_use
                      Text("Registro emocional y físico", style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9))),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        // TARJETA DE RECOMENDACIÓN (DINÁMICA)
                        _buildRecommendationCard(
                          recomendacion['titulo']!,
                          recomendacion['texto']!,
                          recomendacion['icono']!
                        ),
                        
                        const SizedBox(height: 20),

                        // FORMULARIO DETALLES
                        _buildGlassCard(
                          title: "📝 Detalles",
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child: _buildInputDecor(
                                  label: "Fecha",
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}", style: TextStyle(color: greenDark, fontSize: 16)),
                                      Icon(Icons.calendar_today, color: greenPrimary, size: 20),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              _buildTextField(controller: _titleController, label: "Título del día", hint: "Ej: Un día reflexivo..."),
                              const SizedBox(height: 15),
                              _buildTextField(controller: _reflectionController, label: "Reflexión / Desahogo", hint: "¿Qué tienes en mente hoy?", maxLines: 3),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // BIENESTAR (MOOD SELECTOR AMPLIADO)
                        _buildGlassCard(
                          title: "✨ Bienestar",
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("¿Cómo te sentiste?", style: TextStyle(color: greenDark, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 10),
                              
                              // LISTA DE EMOCIONES SCROLLABLE (Para que quepan todas)
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildMoodOption("happy", "😃", "Bien"),
                                    const SizedBox(width: 10),
                                    _buildMoodOption("neutral", "😐", "Normal"),
                                    const SizedBox(width: 10),
                                    _buildMoodOption("tired", "😴", "Agotado"), // NUEVO
                                    const SizedBox(width: 10),
                                    _buildMoodOption("anxious", "😰", "Ansioso"), // NUEVO
                                    const SizedBox(width: 10),
                                    _buildMoodOption("sad", "😔", "Triste"),
                                    const SizedBox(width: 10),
                                    _buildMoodOption("irritated", "😠", "Irritado"), // NUEVO
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(child: _buildTextField(controller: _sleepController, label: "😴 Horas sueño", hint: "0", isNumber: true)),
                                  const SizedBox(width: 15),
                                  Expanded(child: _buildTextField(controller: _waterController, label: "💧 Vasos agua", hint: "0", isNumber: true)),
                                ],
                              )
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // GRATITUD
                        _buildGlassCard(
                          title: "🙏 Gratitud",
                          child: _buildTextField(controller: _gratitudeController, label: "Hoy agradezco por...", hint: "El café, una llamada..."),
                        ),

                        const SizedBox(height: 25),

                        // BOTÓN GUARDAR
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: _saveEntry,
                            icon: const Icon(Icons.save),
                            label: const Text("Guardar Registro"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: greenDark,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 5,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // HISTORIAL
                        if (_entries.isNotEmpty) ...[
                          const Text("📅 Mis Registros Anteriores", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 15),
                          ..._entries.map((entry) => _buildHistoryCard(entry)),
                        ]
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // BARRA INFERIOR
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.25),
                    border: const Border(top: BorderSide(color: Colors.white30)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(Icons.self_improvement, "Meditar", false, onTap: () {
                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                      }),
                      _buildNavItem(Icons.spa, "Rutinas", false, onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RutinasScreen()));
                      }),
                      _buildNavItem(Icons.calendar_month, "", true, onTap: () {}),
                      // Reemplaza el botón de Premium por:
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
        ],
      ),
    );
  }

  // --- WIDGETS ---

  // NUEVA TARJETA DE RECOMENDACIÓN
  Widget _buildRecommendationCard(String title, String body, String icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.9), 
        borderRadius: BorderRadius.circular(15),
        // ignore: deprecated_member_use
        border: Border.all(color: greenPrimary.withOpacity(0.5), width: 1.5),
        // ignore: deprecated_member_use
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 30)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: greenDark, fontSize: 15)),
                const SizedBox(height: 4),
                Text(body, style: TextStyle(fontSize: 13, color: Colors.grey[800], height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
        // ignore: deprecated_member_use
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        // ignore: deprecated_member_use
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: greenDark)),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required String hint, bool isNumber = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: greenDark, fontWeight: FontWeight.w500, fontSize: 13)),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
            // ignore: deprecated_member_use
            border: Border.all(color: Colors.white.withOpacity(0.5)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            maxLines: maxLines,
            style: TextStyle(color: greenDark),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputDecor({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: greenDark, fontWeight: FontWeight.w500, fontSize: 13)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
            // ignore: deprecated_member_use
            border: Border.all(color: Colors.white.withOpacity(0.5)),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildMoodOption(String value, String emoji, String label) {
    bool isSelected = _selectedMood == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedMood = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), // Ajusté un poco el padding
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          // ignore: deprecated_member_use
          border: Border.all(color: isSelected ? greenPrimary : Colors.white.withOpacity(0.3), width: isSelected ? 2 : 1),
          // ignore: deprecated_member_use
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)] : [],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: greenDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(DiaryEntry entry) {
    String emoji;
    switch (entry.mood) {
      case 'happy': emoji = '😃'; break;
      case 'neutral': emoji = '😐'; break;
      case 'sad': emoji = '😔'; break;
      case 'tired': emoji = '😴'; break;
      case 'anxious': emoji = '😰'; break;
      case 'irritated': emoji = '😠'; break;
      default: emoji = '😐';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: greenPrimary, width: 5)),
        // ignore: deprecated_member_use
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${entry.date.day}/${entry.date.month}/${entry.date.year}", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              Text(emoji, style: const TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 5),
          Text(entry.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: greenDark)),
          if (entry.reflection.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text('"${entry.reflection}"', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade700)),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              if (entry.gratitude.isNotEmpty) _buildTag("🙏 ${entry.gratitude}"),
              const SizedBox(width: 8),
              _buildTag("😴 ${entry.sleepHours}h"),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: () => _deleteEntry(entry.id),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)), child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)));
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