import 'package:flutter/material.dart';
import 'new_password.dart'; // Importamos la pantalla de nueva contraseña

class CodeVerificationScreen extends StatelessWidget {
  const CodeVerificationScreen({super.key});

  // Define el color principal para mantener consistencia con el diseño verde
  static const Color primaryColor = Color(0xFF4CAF50);
  static const Color backgroundColor = Color(0xFFF1F8E9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Spacer(flex: 2),

            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green[100],
                child: Icon(
                  Icons.sms_outlined,
                  size: 50,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              'Código',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              'Introduce el código de 6 dígitos que enviamos a tu correo.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const Spacer(flex: 1),

            TextFormField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              style: const TextStyle(fontSize: 24, letterSpacing: 10),
              decoration: InputDecoration(
                hintText: '000000',
                hintStyle: TextStyle(letterSpacing: 10, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: primaryColor, width: 2.0),
                ),
                counterText: '',
              ),
            ),
            const SizedBox(height: 30.0),

            // Botón de Enviar Código
            ElevatedButton(
              onPressed: () {
                debugPrint('Navegando a la pantalla de nueva contraseña...');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewPasswordScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 2, // Reducido para un look más minimalista
              ),
              child: const Text(
                'Enviar Código',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}