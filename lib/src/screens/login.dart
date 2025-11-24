import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:salud_digital/src/screens/home.dart';
//import 'package:salud_digital/src/screens/welcome.dart';
import 'register_screen.dart';
import 'password_recovery.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  // Paleta de colores minimalista verde
  static const Color primaryColor = Color(0xFF4CAF50);
  static const Color accentColor = Color(0xFF8BC34A);
  static const Color backgroundColor = Color(0xFFF1F8E9); // Un verde muy claro para el fondo
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Iniciar Sesión',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 40.0),
              _buildTextField(
                controller: _emailController,
                labelText: 'Correo o Celular',
                hintText: 'tu@email.com o +12345678',
                icon: Icons.person,
              ),
              const SizedBox(height: 16.0),
              _buildPasswordField(
                controller: _passwordController,
                labelText: 'Contraseña',
                hintText: 'Tu contraseña',
                obscureText: _obscurePassword,
                onTapIcon: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              const SizedBox(height: 8.0),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PasswordRecoveryScreen()),
                    );
                  },
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 22.0),

              // Botón de Iniciar Sesión
              ElevatedButton(
                onPressed: () {
                  if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, completa todos los campos')),
                    );
                    return;
                  }
                  debugPrint('Inicio de sesión exitoso (simulado)');
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
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
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24.0),
              Row(
                children: const <Widget>[
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('O inicia sesión con'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton('Facebook', const Color(0xFF1877F2), () => debugPrint('Iniciar con Facebook')),
                  _buildSocialButton('Gmail', const Color(0xFFEA4335), () => debugPrint('Iniciar con Gmail')),
                ],
              ),
              const SizedBox(height: 30.0),
              Center(
                child: Text.rich(
                  TextSpan(
                    text: '¿No tienes cuenta? ',
                    style: const TextStyle(color: Colors.black54),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Regístrate',
                        style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: primaryColor),
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

  Widget _buildSocialButton(String text, Color color, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 10,
          ),
          const SizedBox(width: 10),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}