import 'dart:ui'; 
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <--- IMPORTANTE
import 'profile.dart'; 
import 'agenda.dart'; 
import 'rutinas.dart';
import 'subscription.dart';

// --- MODELO ---
class Meditacion {
  final String id;
  final String titulo;
  final String categoria;
  final int duracion;
  final Color color;
  final String audioPath;
  bool esFavorito;

  Meditacion({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.duracion,
    required this.color,
    required this.audioPath,
    this.esFavorito = false,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final Color greenDark = const Color(0xFF1A3C2F);
  final Color greenPrimary = const Color(0xFF2D936C);
  
  String filtroActual = 'todos';
  bool modoSOS = false;
  late AnimationController _breatheController;

  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _playingId;
  bool _isPlaying = false;

  // --- DATOS LOCALES (ASSETS) ---
  final List<Meditacion> _todasLasMeditaciones = [
    Meditacion(
      id: '1', 
      titulo: 'Calma Instantánea', 
      categoria: 'Ansiedad', 
      duracion: 4, 
      color: Colors.orangeAccent,
      audioPath: 'audio/ansiedad.mp3' 
    ),
    Meditacion(
      id: '2', 
      titulo: 'Sueño Profundo', 
      categoria: 'Dormir', 
      duracion: 4, 
      color: Colors.indigoAccent,
      audioPath: 'audio/sueno.mp3'
    ),
    Meditacion(
      id: '3', 
      titulo: 'Energía Matutina', 
      categoria: 'Energía', 
      duracion: 4, 
      color: Colors.yellow.shade700,
      audioPath: 'audio/ansiedad.mp3' 
    ),
    Meditacion(
      id: '4', 
      titulo: 'Respiración 4-7-8', 
      categoria: 'Ansiedad', 
      duracion: 4, 
      color: Colors.orangeAccent,
      audioPath: 'audio/ansiedad.mp3'
    ),
    Meditacion(
      id: '5', 
      titulo: 'Escaneo Corporal', 
      categoria: 'Dormir', 
      duracion: 4, 
      color: Colors.indigoAccent,
      audioPath: 'audio/sueno.mp3'
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    // 1. CARGAR FAVORITOS AL INICIAR
    _loadFavorites();

    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), 
    )..repeat(reverse: true);

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _playingId = null;
        });
      }
    });
  }

  // --- LÓGICA DE PERSISTENCIA DE FAVORITOS ---
  
  // Cargar lista de favoritos guardados
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // Obtenemos la lista de IDs guardados (ej: ['1', '3'])
    List<String> favIds = prefs.getStringList('favorite_meditations') ?? [];

    setState(() {
      // Recorremos todas las meditaciones y marcamos las que estén en la lista de guardados
      for (var m in _todasLasMeditaciones) {
        if (favIds.contains(m.id)) {
          m.esFavorito = true;
        } else {
          m.esFavorito = false;
        }
      }
    });
  }

  // Guardar/Quitar favorito
  Future<void> _toggleFavorite(Meditacion m) async {
    setState(() {
      m.esFavorito = !m.esFavorito; // Cambiamos visualmente
    });

    final prefs = await SharedPreferences.getInstance();
    List<String> favIds = prefs.getStringList('favorite_meditations') ?? [];

    if (m.esFavorito) {
      // Si ahora es favorito y no estaba en la lista, lo agregamos
      if (!favIds.contains(m.id)) {
        favIds.add(m.id);
      }
    } else {
      // Si ya no es favorito, lo sacamos de la lista
      favIds.remove(m.id);
    }

    // Guardamos la lista actualizada en el celular
    await prefs.setStringList('favorite_meditations', favIds);
  }

  @override
  void dispose() {
    _breatheController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // --- REPRODUCIR ---
  Future<void> _toggleAudio(Meditacion m) async {
    try {
      if (_playingId == m.id && _isPlaying) {
        await _audioPlayer.pause();
        if (mounted) setState(() => _isPlaying = false);
      } else {
        await _audioPlayer.stop();
        if (mounted) {
          setState(() {
            _playingId = m.id;
            _isPlaying = true;
          });
        }
        await _audioPlayer.play(AssetSource(m.audioPath));
      }
    } catch (e) {
      debugPrint("Error audio local: $e");
      if (mounted) setState(() => _isPlaying = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${m.audioPath} no encontrado'), backgroundColor: Colors.red)
        );
      }
    }
  }

  List<Meditacion> get meditacionesVisibles {
    if (filtroActual == 'todos') return _todasLasMeditaciones;
    return _todasLasMeditaciones.where((m) => m.categoria.toLowerCase() == filtroActual.toLowerCase()).toList();
  }

  String _getEmoji(String filtro) {
    switch (filtro) {
      case 'ansiedad': return '😰';
      case 'dormir': return '😴';
      case 'energia': return '⚡';
      default: return '🧘';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // CAPA 1: FONDO
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFA8E6CF), Color(0xFF2D936C)],
              ),
            ),
          ),

          // CAPA 2: CONTENIDO
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Hola, ¿Cómo te sientes?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 5),
                      Text("Elige una emoción para recomendarte algo:", style: TextStyle(fontSize: 14, color: Colors.white70)),
                    ],
                  ),
                ),

                SizedBox(
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildMoodBtn("Ansiedad", "ansiedad"),
                      _buildMoodBtn("Sueño", "dormir"),
                      _buildMoodBtn("Energía", "energia"),
                      _buildMoodBtn("Ver todo", "todos"),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          filtroActual == 'todos' ? 'Todas las meditaciones' : 'Recomendado para ti',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 100),
                            itemCount: meditacionesVisibles.length,
                            itemBuilder: (context, index) {
                              return _buildMeditacionItem(meditacionesVisibles[index]);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // CAPA 3: SOS
          if (modoSOS)
            Positioned.fill(
              child: Container(
                // ignore: deprecated_member_use
                color: const Color(0xFF1A3C2F).withOpacity(0.95),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Respira conmigo", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w300)),
                    const SizedBox(height: 50),
                    AnimatedBuilder(
                      animation: _breatheController,
                      builder: (context, child) {
                        return Container(
                          width: 100 + (_breatheController.value * 150),
                          height: 100 + (_breatheController.value * 150),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.5 - (_breatheController.value * 0.4)),
                          ),
                          child: Center(
                            child: Container(
                              width: 100, height: 100, 
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 50),
                    const Text("Inhala... Exhala...", style: TextStyle(color: Colors.white70, fontSize: 18)),
                    const SizedBox(height: 40),
                    OutlinedButton(
                      onPressed: () => setState(() => modoSOS = false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      child: const Text("Me siento mejor", style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),
            ),

          // CAPA 4: BOTÓN FLOTANTE SOS
          if (!modoSOS)
            Positioned(
              bottom: 90, right: 20,
              child: GestureDetector(
                onTap: () => setState(() => modoSOS = true),
                child: Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5252),
                    shape: BoxShape.circle,
                    // ignore: deprecated_member_use
                    boxShadow: [BoxShadow(color: const Color(0xFFFF5252).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 4))],
                  ),
                  child: const Center(child: Text("SOS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                ),
              ),
            ),

          // CAPA 5: BOTTOM NAV
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.25),
                    border: const Border(top: BorderSide(color: Colors.white30, width: 1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(Icons.self_improvement, "Meditar", true, onTap: () {}),
                      _buildNavItem(Icons.spa, "Rutinas", false, onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RutinasScreen()) );
                      }),
                      _buildNavItem(Icons.calendar_month, "Mi Diario", false, onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const AgendaScreen()));
                      }),
                      _buildNavItem(Icons.diamond, "Premium", false, onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SubscriptionScreen()));
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

  Widget _buildMoodBtn(String label, String filtro) {
    bool isActive = filtroActual.toLowerCase() == filtro.toLowerCase();
    return GestureDetector(
      onTap: () => setState(() => filtroActual = filtro),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        constraints: const BoxConstraints(minWidth: 75),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: isActive ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          // ignore: deprecated_member_use
          border: Border.all(color: Colors.white.withOpacity(0.3)),
          // ignore: deprecated_member_use
          boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))] : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_getEmoji(filtro), style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 5),
            // ignore: deprecated_member_use
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isActive ? greenDark : greenDark.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }

  Widget _buildMeditacionItem(Meditacion m) {
    bool isPlayingThis = _playingId == m.id && _isPlaying;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        // ignore: deprecated_member_use
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(width: 4, height: 40, decoration: BoxDecoration(color: m.color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 10),
          
          GestureDetector(
            onTap: () => _toggleAudio(m),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: greenPrimary, shape: BoxShape.circle),
              child: Icon(
                isPlayingThis ? Icons.pause : Icons.play_arrow, 
                color: Colors.white, size: 20
              ),
            ),
          ),

          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF333333))),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      // ignore: deprecated_member_use
                      decoration: BoxDecoration(color: m.color.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                      child: Text(m.categoria.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ),
                    if (m.duracion > 0)
                      Text(" • ${m.duracion} mins", style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
          
          // --- BOTÓN DE FAVORITO CON PERSISTENCIA ---
          IconButton(
            icon: Icon(
              m.esFavorito ? Icons.favorite : Icons.favorite_border, 
              color: m.esFavorito ? Colors.red : Colors.grey
            ),
            onPressed: () {
              _toggleFavorite(m); // <--- Llamamos a la función de guardado real
            },
          )
        ],
      ),
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
            Text(label, style: TextStyle(fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: isActive ? greenPrimary : greenDark)),
          ],
        ),
      ),
    );
  }
}