import 'package:flutter/material.dart';
import 'login.dart'; // Importamos LoginScreen para navegar a ella al finalizar

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  // Define el color principal para mantener consistencia con el diseño verde
  static const Color primaryColor = Color(0xFF4CAF50);
  static const Color backgroundColor = Color(0xFFF1F8E9);

  // Controladores para los campos de texto
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Variables para controlar la visibilidad de las contraseñas
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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

            // Avatar circular
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green[100],
                child: Icon(
                  Icons.lock,
                  size: 50,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Título
            const Text(
              'Nueva Contraseña',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Spacer(flex: 1),

            // Campo de Nueva Contraseña
            _buildPasswordField(
              controller: _newPasswordController,
              labelText: 'Nueva Contraseña',
              hintText: 'Tu nueva contraseña',
              obscureText: _obscureNewPassword,
              onTapIcon: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              },
            ),
            const SizedBox(height: 16.0),

            // Campo de Confirmar Contraseña
            _buildPasswordField(
              controller: _confirmPasswordController,
              labelText: 'Confirmar Contraseña',
              hintText: 'Repite tu nueva contraseña',
              obscureText: _obscureConfirmPassword,
              onTapIcon: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            const SizedBox(height: 30.0),

            // Botón de Confirmar
            ElevatedButton(
              onPressed: () {
                // Lógica para confirmar la nueva contraseña
                if (_newPasswordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Por favor, completa todos los campos')),
                  );
                  return;
                }

                if (_newPasswordController.text != _confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Las contraseñas no coinciden')),
                  );
                  return;
                }

                // Si todo es correcto, muestra un mensaje y navega al login
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('¡Contraseña cambiada con éxito!')),
                );

                // Navega a la pantalla de login y elimina el historial de pantallas de recuperación
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
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
                'Confirmar',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }

  // Widget para construir los campos de contraseña
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required bool obscureText,
    required VoidCallback onTapIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: const Icon(Icons.lock, color: primaryColor),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: primaryColor,
          ),
          onPressed: onTapIcon,
        ),
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
      ),
    );
  }
}