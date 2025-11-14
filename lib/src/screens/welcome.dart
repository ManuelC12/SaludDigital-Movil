import 'package:flutter/material.dart';
import 'login.dart'; // Importamos la pantalla de login
import 'register.dart'; // <-- CAMBIO: Importamos la pantalla de registro

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(flex: 2),
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.purple[100],
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.purple[400],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Bienestar Digital',
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
                  backgroundColor: Colors.grey[700],
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
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
                  // <-- CAMBIO: Navegación a la pantalla de Registro
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey[700]!),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Registrarse',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]!),
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