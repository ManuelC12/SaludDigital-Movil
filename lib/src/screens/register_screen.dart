import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'login.dart'; // Importamos la pantalla de login para poder navegar a ella

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  // Define el color principal verde minimalista
  static const Color primaryColor = Color(0xFF4CAF50);
  static const Color accentColor = Color(0xFF8BC34A);
  static const Color backgroundColor = Color(0xFFF1F8E9); // Un verde muy claro para el fondo

  // Controladores para los campos de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variable para controlar la visibilidad de la contraseña
  bool _obscurePassword = true;
  
  // Variable para almacenar el género seleccionado
  String _selectedGender = 'Masculino';

  @override
  void dispose() {
    // Limpia los controladores cuando el widget se destruye
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          // Permite hacer scroll si el contenido es muy grande
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch, // Estira los widgets horizontalmente
            children: <Widget>[
              // Título de la pantalla
              const Text(
                'Crear Mi Cuenta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 40.0),

              // Campo de Nombre Completo
              _buildTextField(
                controller: _nameController,
                labelText: 'Nombre Completo',
                hintText: 'Tu nombre completo',
                icon: Icons.person,
              ),
              const SizedBox(height: 16.0),

              // Campo de Correo
              _buildTextField(
                controller: _emailController,
                labelText: 'Correo',
                hintText: 'tu@email.com',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16.0),

              // Campo de Celular
              _buildTextField(
                controller: _phoneController,
                labelText: 'Número de Celular',
                hintText: 'Tu número de teléfono',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16.0),

              // Campo de Edad
              _buildTextField(
                controller: _ageController,
                labelText: 'Edad',
                hintText: 'Tu edad',
                icon: Icons.cake,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),

              // Campo de Género
              _buildGenderField(),
              const SizedBox(height: 16.0),

              // Campo de Contraseña
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
              const SizedBox(height: 30.0),

              // Botón de Confirmar
              ElevatedButton(
                onPressed: () {
                  // Aquí iría la lógica de registro
                  debugPrint('Registrando usuario...');
                  // Ejemplo de validación simple
                  if (_passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor ingresa una contraseña')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Confirmar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24.0),

              // Separador para inicio de sesión social
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

              // Botones de inicio de sesión social
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton(
                    'Facebook',
                    const Color(0xFF1877F2),
                    () => debugPrint('Iniciar con Facebook'),
                  ),
                  _buildSocialButton(
                    'Gmail',
                    const Color(0xFFEA4335),
                    () => debugPrint('Iniciar con Gmail'),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),

              // Texto para ir a la pantalla de login
              Center(
                child: Text.rich(
                  TextSpan(
                    text: '¿Ya tienes cuenta? ',
                    style: const TextStyle(color: Colors.black54),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Inicia sesión',
                        style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        // NAVEGACIÓN: Al presionar, lleva a la pantalla de login.
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
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

  // Widget para construir los campos de texto generales
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

  // Widget para construir el campo de género
  Widget _buildGenderField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.people, color: primaryColor),
          const SizedBox(width: 15),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedGender,
                icon: const Icon(Icons.arrow_drop_down, color: primaryColor),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black87),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
                items: <String>['Masculino', 'Femenino', 'Otro']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para construir el campo de contraseña
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

  // Widget para los botones de inicio de sesión social
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
          // Aquí podrías usar el icono real de Facebook/Gmail
          // Por ejemplo, con el paquete 'font_awesome_flutter'
          // Icon(FontAwesomeIcons.facebook, color: color),
          // Icon(FontAwesomeIcons.google, color: color),
          // Por ahora, usamos un círculo de color como placeholder
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