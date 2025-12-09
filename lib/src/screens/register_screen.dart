import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';

import '../viewmodels/register_viewmodel.dart';
import 'home.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  // COLORES DEL DISEÑO
  final Color greenDark = const Color.fromRGBO(26, 60, 47, 1);
  final Color greenPrimary = const Color.fromRGBO(45, 147, 108, 1);
  final Color greenLight = const Color.fromRGBO(168, 230, 207, 1);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  String _selectedGender = 'Masculino';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor llena todos los campos')),
      );
      return;
    }

    String genderChar = (_selectedGender == 'Masculino')
        ? 'M'
        : (_selectedGender == 'Femenino' ? 'F' : 'O');

    final Map<String, dynamic> userDataMap = {
      "nombre": _nameController.text,
      "email": _emailController.text,
      "celular": _phoneController.text,
      "password": _passwordController.text,
      "edad": int.tryParse(_ageController.text) ?? 0,
      "genre": genderChar,
    };

    try {
      final vm = Provider.of<RegisterViewModel>(context, listen: false);

      bool success = await vm.register(userDataMap);

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Bienvenido!'),
              backgroundColor: Color.fromRGBO(45, 147, 108, 1),
            ),
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al registrar usuario'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Crear Cuenta",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black12,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.18),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(31, 38, 135, 1).withValues(alpha: 0.15),
                              blurRadius: 32,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildGlassInput(
                              controller: _nameController,
                              label: 'Nombre Completo',
                              hint: 'Tu nombre',
                              icon: Icons.person,
                            ),
                            const SizedBox(height: 15),
                            _buildGlassInput(
                              controller: _emailController,
                              label: 'Correo',
                              hint: 'tu@email.com',
                              icon: Icons.email,
                              inputType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 15),
                            _buildGlassInput(
                              controller: _phoneController,
                              label: 'Celular',
                              hint: 'Tu teléfono',
                              icon: Icons.phone,
                              inputType: TextInputType.phone,
                            ),
                            const SizedBox(height: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: _buildGlassInput(
                                    controller: _ageController,
                                    label: 'Edad',
                                    hint: '00',
                                    icon: Icons.cake,
                                    inputType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  flex: 3,
                                  child: _buildGlassGenderDropdown(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            _buildGlassInput(
                              controller: _passwordController,
                              label: 'Contraseña',
                              hint: 'Mínimo 6 caracteres',
                              icon: Icons.lock,
                              isPassword: true,
                              obscureText: _obscurePassword,
                              onToggleVisibility: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Consumer<RegisterViewModel>(
                              builder: (context, vm, _) {
                                return vm.isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: _registerUser,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: greenDark,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            elevation: 5,
                                          ),
                                          child: const Text(
                                            'Confirmar',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                              },
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Text.rich(
                                TextSpan(
                                  text: '¿Ya tienes cuenta? ',
                                  style: TextStyle(
                                    color: greenDark,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Inicia sesión',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen(),
                                            ),
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    TextInputType inputType = TextInputType.text,
    VoidCallback? onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: greenDark,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: greenDark.withValues(alpha: 0.3)),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword ? obscureText : false,
            keyboardType: inputType,
            style: TextStyle(color: greenDark),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              prefixIcon: Icon(
                icon,
                color: greenDark.withValues(alpha: 0.7),
                size: 20,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        color: greenDark.withValues(alpha: 0.6),
                      ),
                      onPressed: onToggleVisibility,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Género",
          style: TextStyle(
            color: greenDark,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: greenDark.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.people,
                color: greenDark.withValues(alpha: 0.7),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedGender,
                    icon: Icon(Icons.arrow_drop_down, color: greenDark),
                    dropdownColor: Colors.white,
                    style: TextStyle(color: greenDark, fontSize: 15),
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue!;
                      });
                    },
                    items: <String>['Masculino', 'Femenino', 'Otro']
                        .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, overflow: TextOverflow.ellipsis),
                          );
                        })
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
