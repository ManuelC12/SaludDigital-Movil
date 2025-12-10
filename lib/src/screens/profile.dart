import 'dart:convert';
import 'dart:ui'; // Necesario para el efecto vidrio (BackdropFilter)
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'home.dart'; 
import 'patient_appointments.dart'; // <--- Agrega esto
import 'login.dart';
import 'agenda.dart'; // <--- IMPORTANTE: Agregamos esto para poder ir a la Agenda
import 'package:salud_digital/src/screens/rutinas.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // COLORES DEL DISEÑO (SCSS)
  final Color greenDark = const Color(0xFF1A3C2F);
  final Color greenPrimary = const Color(0xFF2D936C);
  final Color greenLight = const Color(0xFFA8E6CF);
  
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // --- LEER DATOS DEL USUARIO ---
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      final String? userJson = prefs.getString('userData');
      if (userJson != null) {
        setState(() {
          _currentUser = User.fromJson(jsonDecode(userJson));
          _isLoading = false;
        });
      }
    } else {
      setState(() => _isLoading = false);
    }
  }

  // --- CERRAR SESIÓN ---
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Solo borramos los datos de la sesión actual, no la agenda
    await prefs.remove('userData');
    await prefs.remove('isLoggedIn');

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  String _getGenderString(String code) {
    if (code.toUpperCase() == 'M') return 'Masculino';
    if (code.toUpperCase() == 'F') return 'Femenino';
    return 'Otro';
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "";
    List<String> names = name.trim().split(" ");
    String initials = "";
    if (names.isNotEmpty) initials += names[0][0];
    if (names.length > 1) initials += names[1][0];
    return initials.toUpperCase();
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
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : _currentUser == null 
                ? const Center(child: Text("Sin sesión", style: TextStyle(color: Colors.white)))
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), // Padding inferior para el Nav
                    child: Column(
                      children: [
                        // HEADER
                        const Text(
                          "Mi Perfil",
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.white,
                            shadows: [Shadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 4)]
                          ),
                        ),
                        const SizedBox(height: 20),

                        // TARJETA DE VIDRIO (GLASS CARD)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                // ignore: deprecated_member_use
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(20),
                                // ignore: deprecated_member_use
                                border: Border.all(color: Colors.white.withOpacity(0.18)),
                                boxShadow: [
                                  BoxShadow(
                                    // ignore: deprecated_member_use
                                    color: const Color(0xFF1F2687).withOpacity(0.15),
                                    blurRadius: 32,
                                    offset: const Offset(0, 8),
                                  )
                                ]
                              ),
                              child: Column(
                                children: [
                                  // AVATAR CON INICIALES
                                  Container(
                                    width: 100, height: 100,
                                    decoration: BoxDecoration(
                                      // ignore: deprecated_member_use
                                      color: Colors.white.withOpacity(0.4),
                                      shape: BoxShape.circle,
                                      // ignore: deprecated_member_use
                                      border: Border.all(color: Colors.white.withOpacity(0.6), width: 3),
                                      // ignore: deprecated_member_use
                                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4))]
                                    ),
                                    child: Center(
                                      child: Text(
                                        _getInitials(_currentUser!.name),
                                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: greenDark),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  
                                  Text(
                                    _currentUser!.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: greenDark),
                                  ),
                                  Text(
                                    "Miembro Activo",
                                    // ignore: deprecated_member_use
                                    style: TextStyle(fontSize: 13, color: greenDark.withOpacity(0.8)),
                                  ),
                                  const SizedBox(height: 30),

                                  // CAMPOS DE TEXTO (Inputs Readonly)
                                  _buildGlassInput("Nombre Completo", _currentUser!.name),
                                  _buildGlassInput("Correo Electrónico", _currentUser!.email),
                                  
                                  Row(
                                    children: [
                                      Expanded(child: _buildGlassInput("Edad", "${_currentUser!.age} años", centered: true)),
                                      const SizedBox(width: 15),
                                      Expanded(child: _buildGlassInput("Género", _getGenderString(_currentUser!.gender), centered: true)),
                                    ],
                                  ),

                                  const SizedBox(height: 10),
                                

                                  const SizedBox(height: 15),

                                  // BOTÓN CERRAR SESIÓN
                                  OutlinedButton.icon(
                                    onPressed: _logout,
                                    icon: const Icon(Icons.logout, size: 18),
                                    label: const Text("Cerrar Sesión"),
                                    style: OutlinedButton.styleFrom(
                                      // ignore: deprecated_member_use
                                      backgroundColor: Colors.white.withOpacity(0.5),
                                      foregroundColor: const Color(0xFFC22323),
                                      minimumSize: const Size(double.infinity, 50),
                                      // ignore: deprecated_member_use
                                      side: BorderSide(color: const Color(0xFFC22323).withOpacity(0.3)),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),

          // 3. BARRA DE NAVEGACIÓN (Bottom Nav Glass)
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
                    // ignore: deprecated_member_use
                    border: Border(top: BorderSide(color: Colors.white.withOpacity(0.18))),
                    // ignore: deprecated_member_use
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, -4))]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // 1. MEDITAR (Va al Home)
                      _buildNavItem(Icons.self_improvement, "Meditar", false, onTap: () {
                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                      }),
                       _buildNavItem(Icons.spa, "Rutinas", false, onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RutinasScreen()) );
                      }),
                      // 2. AGENDA (Va a la Agenda)
                      _buildNavItem(Icons.calendar_month, "Mi Diario", false, onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => const AgendaScreen()));
                      }),
                             _buildNavItem(Icons.medical_services, "Citas", false, onTap: () {
  Navigator.push(context, MaterialPageRoute(builder: (context) => const PatientAppointmentsScreen()));
}),
                      // 3. PERFIL (Activo)
                      _buildNavItem(Icons.person, "Perfil", true, onTap: () {}),
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

  // --- WIDGETS AUXILIARES ---

  Widget _buildGlassInput(String label, String value, {bool centered = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: greenDark, fontWeight: FontWeight.w500, fontSize: 14),
          ),
          const SizedBox(height: 5),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
              // ignore: deprecated_member_use
              border: Border.all(color: Colors.white.withOpacity(0.4)),
            ),
            child: Text(
              value,
              textAlign: centered ? TextAlign.center : TextAlign.start,
              style: TextStyle(
                color: greenDark,
                fontSize: 15,
                fontWeight: FontWeight.w500, 
              ),
            ),
          ),
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
            const SizedBox(height: 2),
            Text(
              label, 
              style: TextStyle(
                fontSize: 10, 
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? greenPrimary : greenDark
              )
            ),
          ],
        ),
      ),
    );
  }
}