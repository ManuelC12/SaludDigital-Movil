import 'package:flutter/material.dart';
import 'login.dart'; // Importamos la pantalla de login
import 'register_screen.dart'; // Importamos la pantalla de registro

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // Define el color principal para mantener consistencia con el diseño verde
  static const Color primaryColor = Color(0xFF4CAF50);
  static const Color backgroundColor = Color(0xFFF1F8E9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(flex: 2),
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.green[100],
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Salud Digital',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '¡Hola de Nuevo!',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.grey,
                ),
              ),
              const Spacer(flex: 3),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 2, // Reducido para un look más minimalista
                ),
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 15),
              // Botón de Registrarse
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: primaryColor),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Registrarse',
                  style: TextStyle(fontSize: 18, color: primaryColor),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}