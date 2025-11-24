import 'package:flutter/material.dart';
import 'profile.dart'; // Importante para poder navegar al perfil

// --- PALETA DE COLORES CONSISTENTE ---
// Definimos los colores en un solo lugar para fácil mantenimiento
class AppColors {
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color accentGreen = Color(0xFF8BC34A);
  static const Color backgroundLight = Color(0xFFF1F8E9);
  static const Color cardSurface = Colors.white;
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.grey;
  static const Color textOnPrimary = Colors.white;
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight, // Fondo verde claro
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER CON NAVEGACIÓN
              const HomeHeader(),

              const SizedBox(height: 32),

              // MOOD SECTION
              const MoodSection(),

              const SizedBox(height: 32),

              // RECOMENDACIONES
              const SectionTitle(title: "Recomendado para ti", actionText: "Ver Todo"),
              const SizedBox(height: 16),
              const RecommendationCard(title: "Respiración Consciente", time: "3 mins", type: "Meditación"),
              const RecommendationCard(title: "Exploración Corporal", time: "5 mins", type: "Relajación"),
              const RecommendationCard(title: "Sonidos de Lluvia", time: "10 mins", type: "Sueño"),

              const SizedBox(height: 32),

              // EXPLORAR
              const SectionTitle(title: "Explorar"),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: ExploreCard(title: "Ansiedad", icon: Icons.favorite, backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1), iconColor: AppColors.primaryGreen)),
                  const SizedBox(width: 16),
                  Expanded(child: ExploreCard(title: "Tristeza", icon: Icons.sentiment_satisfied_alt, backgroundColor: AppColors.accentGreen.withValues(alpha: 0.1), iconColor: AppColors.accentGreen)),
                ],
              ),
              const SizedBox(height: 100), // Espacio para que no tape la barra
            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGETS INTERNOS ---

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
              child: Icon(Icons.menu, size: 20, color: Colors.grey[700]),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Buenas tardes,", style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
                const Text("Ana María", style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        // AVATAR CON NAVEGACIÓN AL PERFIL
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1), // Fondo verde muy claro
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cardSurface, width: 2),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
            ),
            child: Icon(Icons.person, color: AppColors.primaryGreen, size: 24), // Icono verde
          ),
        ),
      ],
    );
  }
}

class MoodSection extends StatelessWidget {
  const MoodSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.cardSurface, borderRadius: BorderRadius.circular(24)), // Fondo blanco
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("¿Cómo te sientes hoy?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text("Registra tu estado para personalizar tu plan.", style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
              
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen, // Botón verde
                foregroundColor: AppColors.textOnPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
              child: const Text("Registrar ahora"),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final String? actionText;
  const SectionTitle({super.key, required this.title, this.actionText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        if (actionText != null)
          Text(actionText!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      ],
    );
  }
}

class RecommendationCard extends StatelessWidget {
  final String title, time, type;
  const RecommendationCard({super.key, required this.title, required this.time, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.play_arrow, color: Colors.grey[600]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                Text("$type • $time", style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExploreCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  const ExploreCard({super.key, required this.title, required this.icon, required this.backgroundColor, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      
      },
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: iconColor, size: 28),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}