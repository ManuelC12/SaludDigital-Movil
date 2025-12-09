import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
//import 'package:flutter/gestures.dart'; // Para los links de texto
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../models/user_model.dart';
import '../services/api_service.dart'; // <--- IMPORTANTE: Importamos el servicio
import 'home.dart';
import 'register_screen.dart';
import 'password_recovery.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final Color greenDark = const Color(0xFF1A3C2F);
  final Color greenPrimary = const Color(0xFF2D936C);
  final Color greenLight = const Color(0xFFA8E6CF);
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _obscurePassword = true; 
  bool _isLoading = false;

  // Instancia del servicio
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, completa los campos')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. LLAMAMOS AL SERVICIO (Ya no usamos http directo aquí)
      final jsonResponse = await _apiService.login(
        _emailController.text.trim(), 
        _passwordController.text
      );

      // 2. VERIFICAMOS LA RESPUESTA
      if (jsonResponse['status'] == 'ok' && jsonResponse['content'] != null) {
        
        String token = jsonResponse['content'];
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        
        // 3. CREAMOS EL USUARIO
        final user = User(
          name: decodedToken['Name'] ?? decodedToken['unique_name'] ?? 'Usuario',
          email: decodedToken['email'] ?? _emailController.text,
          phone: decodedToken['PhoneNumber'] ?? decodedToken['phone'] ?? 'Sin número',
          age: int.tryParse(decodedToken['Age'].toString()) ?? 0, 
          gender: decodedToken['Gender'] ?? 'O',
        );
        
        // 4. GUARDAMOS DATOS EN EL CELULAR
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userData', jsonEncode(user.toJson()));
        await prefs.setBool('isLoggedIn', true);
        
        // --- GUARDAMOS EL TOKEN PARA USARLO EN OTRAS PETICIONES (TERAPEUTAS) ---
        await prefs.setString('token_jwt', token); 
        // ----------------------------------------------------------------------

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        }
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Respuesta inesperada')));
      }

    } catch (e) {
      // Capturamos cualquier error que venga del servicio
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ... (El resto del método build y los widgets visuales se quedan IGUAL, no cambian)
  @override
  Widget build(BuildContext context) {
    // ... Pega aquí todo el código visual (build y _buildGlassInput) que ya tenías ...
    // (Por espacio no lo repito todo, pero es EXACTAMENTE el mismo diseño que me pasaste)
    return Scaffold(
      body: Stack(
        children: [
          // Fondo y Widgets visuales...
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [greenLight, greenPrimary],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Bienvenido", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 4)])),
                  const SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withValues(alpha: 0.18)), boxShadow: [BoxShadow(color: const Color(0xFF1F2687).withValues(alpha: 0.15), blurRadius: 32, offset: const Offset(0, 8))]),
                        child: Column(
                          children: [
                            _buildGlassInput(controller: _emailController, label: "Correo electrónico", hint: "tu@email.com", icon: Icons.email, inputType: TextInputType.emailAddress),
                            const SizedBox(height: 20),
                            _buildGlassInput(controller: _passwordController, label: "Contraseña", hint: "••••••••", icon: Icons.lock, isPassword: true, obscureText: _obscurePassword, onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword)),
                            const SizedBox(height: 30),
                            _isLoading ? const CircularProgressIndicator(color: Colors.white) : SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: _login, style: ElevatedButton.styleFrom(backgroundColor: greenDark, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 5), child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))),
                            const SizedBox(height: 20),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 20,
                              runSpacing: 10,
                              children: [
                                GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PasswordRecoveryScreen())), child: Text("¿Olvidaste tu contraseña?", style: TextStyle(color: greenDark, fontSize: 12, fontWeight: FontWeight.w500))),
                                GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())), child: Text("Crear cuenta", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, decoration: TextDecoration.underline))),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassInput({required TextEditingController controller, required String label, required String hint, required IconData icon, bool isPassword = false, bool obscureText = false, TextInputType inputType = TextInputType.text, VoidCallback? onToggleVisibility}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: greenDark, fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(12), border: Border.all(color: greenDark.withValues(alpha: 0.3))),
          child: TextField(controller: controller, obscureText: isPassword ? obscureText : false, keyboardType: inputType, style: TextStyle(color: greenDark), decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14), prefixIcon: Icon(icon, color: greenDark.withValues(alpha: 0.7), size: 20), suffixIcon: isPassword ? IconButton(icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: greenDark.withValues(alpha: 0.6)), onPressed: onToggleVisibility) : null, border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14))),
        ),
      ],
    );
  }
}