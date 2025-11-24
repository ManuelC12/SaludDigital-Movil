import 'package:flutter/material.dart';

// --- PALETA DE COLORES ---
// Definida fuera del widget para un acceso limpio y sin errores.
class _AppColors {
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color backgroundLight = Color(0xFFF1F8E9);
  static const Color cardSurface = Colors.white;
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.grey;
  static const Color textOnPrimary = Colors.white;
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.backgroundLight, // Fondo verde claro
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. HEADER (Botón atrás y Título)
              _buildHeader(context),
              
              const SizedBox(height: 32),

              // 2. SECCIÓN DE AVATAR
              _buildAvatarSection(),
              
              const SizedBox(height: 32),

              // 3. FORMULARIO (Campos de solo lectura)
              _buildInfoFields(),
              
              const SizedBox(height: 32),

              // 4. BOTONES DE ACCIÓN
              _buildActionButtons(),
              
              const SizedBox(height: 40), // Espacio final
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS DE LA SECCIÓN ---

  Widget _buildHeader(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () {
              Navigator.pop(context); // Navegación hacia atrás funcional
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 32.0), // Compensación visual para centrar
              child: const Text(
                "Mi Perfil",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _AppColors.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: _AppColors.primaryGreen.withValues(alpha: 0.1), // Fondo verde muy claro
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))
            ],
          ),
          child: Icon(Icons.person, size: 60, color: _AppColors.primaryGreen), // Icono verde
        ),
        const SizedBox(height: 16),
        const Text(
          "Ana María",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _AppColors.textPrimary),
        ),
        Text(
          "Miembro desde 2025",
          style: TextStyle(fontSize: 14, color: _AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildInfoFields() {
    return Column(
      children: [
        _buildLabel("Nombre completo"),
        _buildReadOnlyInput("Ana María Perez"),
        
        const SizedBox(height: 16),
        
        _buildLabel("Email"),
        _buildReadOnlyInput("ana.maria@ejemplo.com"),
        
        const SizedBox(height: 16),
        
        // Fila de Edad y Género
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _buildLabel("Edad"),
                  _buildReadOnlyInput("28", alignCenter: true),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _buildLabel("Género"),
                  _buildReadOnlyInput("Mujer", alignCenter: true),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
            },
            icon: const Icon(Icons.settings, size: 18),
            label: const Text("Configuración"),
            style: ElevatedButton.styleFrom(
              backgroundColor: _AppColors.primaryGreen, // Botón verde
              foregroundColor: _AppColors.textOnPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
          
            },
            icon: const Icon(Icons.logout, size: 18),
            label: const Text("Cerrar Sesión"),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red[500],
              side: BorderSide(color: Colors.red[100]!),
              backgroundColor: _AppColors.cardSurface, // Fondo blanco
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _AppColors.textSecondary),
      ),
    );
  }

  Widget _buildReadOnlyInput(String value, {bool alignCenter = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100], // Fondo gris claro para simular campo desactivado
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
      child: Text(
        value, 
        textAlign: alignCenter ? TextAlign.center : TextAlign.start,
        style: const TextStyle(fontSize: 14, color: _AppColors.textSecondary),
      ),
    );
  }
}