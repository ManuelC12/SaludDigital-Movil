import 'dart:ui'; // Necesario para el efecto vidrio
import 'package:flutter/material.dart';
import 'login.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // COLORES DEL DISEÑO (Coherentes con tu app)
    const Color greenDark = Color(0xFF1A3C2F);
    const Color greenPrimary = Color(0xFF2D936C);
    const Color greenLight = Color(0xFFA8E6CF);

    return Scaffold(
      body: Stack(
        children: [
          // 1. FONDO DEGRADADO
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [greenLight, greenPrimary],
              ),
            ),
          ),

          // 2. CONTENIDO (TARJETA DE VIDRIO CENTRADA)
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30), // Bordes redondeados del vidrio
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Efecto borroso
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.25), // Transparencia
                      borderRadius: BorderRadius.circular(30),
                      // ignore: deprecated_member_use
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: const Color(0xFF1F2687).withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // La tarjeta se ajusta al contenido
                      children: [
                        // ICONO / LOGO
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              )
                            ],
                          ),
                          child: const Icon(
                            Icons.health_and_safety, // Icono más representativo
                            size: 60,
                            color: greenPrimary,
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // TEXTOS
                        const Text(
                          'Salud Digital',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: greenDark, // Color oscuro para contraste
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Tu bienestar, simplificado.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            // ignore: deprecated_member_use
                            color: greenDark.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 50),

                        // BOTÓN INICIAR SESIÓN
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: greenDark, // Botón oscuro sólido
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                              // ignore: deprecated_member_use
                              shadowColor: greenDark.withOpacity(0.4),
                            ),
                            child: const Text(
                              'Iniciar Sesión',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // BOTÓN REGISTRARSE (Estilo Glass)
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RegisterScreen()),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: greenDark, width: 2), // Borde visible
                              // ignore: deprecated_member_use
                              backgroundColor: Colors.white.withOpacity(0.3), // Fondo semitransparente
                              foregroundColor: greenDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'Registrarse',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}