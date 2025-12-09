import 'dart:ui'; // Para el efecto vidrio
import 'package:flutter/material.dart';
import 'home.dart';
import 'agenda.dart';
import 'rutinas.dart';
import 'profile.dart';

// --- MODELO DE DATOS ---
class Plan {
  final String id;
  final String nombre;
  final int precio;
  final String moneda;
  final String periodo;
  final String descripcion;
  final List<String> caracteristicas;
  final bool recomendado;
  final String colorBtn; // 'secondary', 'primary', 'dark'

  Plan({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.moneda,
    required this.periodo,
    required this.descripcion,
    required this.caracteristicas,
    required this.recomendado,
    required this.colorBtn,
  });
}

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  // COLORES DEL TEMA
  final Color greenDark = const Color(0xFF1A3C2F);
  final Color greenPrimary = const Color(0xFF2D936C);
  final Color greenLight = const Color(0xFFA8E6CF);

  // DATOS DE LOS PLANES
  final List<Plan> _planes = [
    Plan(
      id: 'free',
      nombre: 'Plan Gratis',
      precio: 0,
      moneda: 'MXN',
      periodo: 'Siempre',
      descripcion: 'Para empezar tu camino.',
      caracteristicas: [
        '🧘 Meditación básica',
        '🎧 Audios de naturaleza',
        '📅 Agenda personal limitada'
      ],
      recomendado: false,
      colorBtn: 'secondary',
    ),
    Plan(
      id: 'basic',
      nombre: 'Plan Básico',
      precio: 100,
      moneda: 'MXN',
      periodo: '/ mes',
      descripcion: 'El equilibrio perfecto.',
      caracteristicas: [
        '👩‍⚕️ 2 sesiones de terapeuta al mes',
        '🧠 Ejercicios avanzados',
        '✨ 25% desc. primer mes',
        '🔓 Desbloqueo de todas las rutinas'
      ],
      recomendado: true,
      colorBtn: 'primary',
    ),
    Plan(
      id: 'premium',
      nombre: 'Plan Premium',
      precio: 120,
      moneda: 'MXN',
      periodo: '/ mes',
      descripcion: 'Transformación total.',
      caracteristicas: [
        '👩‍⚕️ 4 sesiones de terapeuta al mes',
        '🚀 Acceso ilimitado a todo',
        '📞 Soporte prioritario 24/7',
        '📦 Kit de bienvenida físico'
      ],
      recomendado: false,
      colorBtn: 'dark',
    ),
  ];

  // --- LÓGICA DE SELECCIÓN ---
  void _seleccionarPlan(Plan plan) {
    if (plan.precio == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Ya tienes el plan gratuito activo! 🍃'), backgroundColor: greenDark),
      );
    } else {
      // Simulación de Pago
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Suscribirse a ${plan.nombre}", style: TextStyle(color: greenDark)),
          content: Text("¿Confirmar el pago de \$${plan.precio} ${plan.moneda}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: greenPrimary, foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('¡Gracias por tu compra! (Simulada) 🎉'), backgroundColor: Colors.green),
                );
              },
              child: const Text("Pagar"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. FONDO DEGRADADO
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [greenLight, greenPrimary],
              ),
            ),
          ),

          // 2. CONTENIDO SCROLLABLE
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Column(
                    children: [
                      const Text(
                        "Invierte en Ti",
                        style: TextStyle(
                          fontSize: 24, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.white,
                          shadows: [Shadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 4)]
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Elige el plan que mejor se adapte a tu bienestar.",
                        style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.9)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // LISTA DE PLANES
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 100), // Padding inferior para el Nav
                    itemCount: _planes.length,
                    itemBuilder: (context, index) {
                      return _buildPlanCard(_planes[index]);
                    },
                  ),
                ),
              ],
            ),
          ),

          // 3. BARRA DE NAVEGACIÓN
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    border: const Border(top: BorderSide(color: Colors.white30)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(Icons.self_improvement, "Meditar", false, onTap: () {
                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                      }),
                      _buildNavItem(Icons.spa, "Rutinas", false, onTap: () {
                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RutinasScreen()));
                      }),
                      _buildNavItem(Icons.calendar_today, "Mi Diario", false, onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AgendaScreen()));
                      }),
                      // Botón para ir a Premium

                      // PREMIUM (ACTIVO)
                      _buildNavItem(Icons.diamond, "Premium", true, onTap: () {}),
                      
                      _buildNavItem(Icons.person, "Perfil", false, onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildPlanCard(Plan plan) {
    // Si es recomendado, usamos un fondo más sólido y borde verde
    final bgOpacity = plan.recomendado ? 0.65 : 0.25;
    final borderColor = plan.recomendado ? greenPrimary : Colors.white.withValues(alpha: 0.2);
    final borderWidth = plan.recomendado ? 2.0 : 1.0;

    return GestureDetector(
      onTap: () => _seleccionarPlan(plan),
      child: Stack(
        clipBehavior: Clip.none, // Para que el badge sobresalga
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: bgOpacity),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: borderWidth),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: plan.recomendado ? 0.15 : 0.05),
                  blurRadius: plan.recomendado ? 15 : 10,
                  offset: const Offset(0, 4)
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  plan.nombre,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: greenDark),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  plan.descripcion,
                  style: TextStyle(fontSize: 13, color: greenDark.withValues(alpha: 0.8)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                
                // PRECIO
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("\$", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: greenDark)),
                    Text("${plan.precio}", style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: greenDark, height: 1)),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 5),
                      child: Text(plan.periodo, style: TextStyle(fontSize: 14, color: greenDark.withValues(alpha: 0.7))),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                Divider(color: greenDark.withValues(alpha: 0.1)),
                const SizedBox(height: 20),

                // CARACTERÍSTICAS
                ...plan.caracteristicas.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check, size: 18, color: greenPrimary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(feature, style: TextStyle(fontSize: 14, color: greenDark)),
                      ),
                    ],
                  ),
                )),

                const SizedBox(height: 20),

                // BOTÓN DE ACCIÓN
                ElevatedButton(
                  onPressed: () => _seleccionarPlan(plan),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getBtnColor(plan.colorBtn),
                    foregroundColor: plan.colorBtn == 'secondary' ? greenDark : Colors.white,
                    side: plan.colorBtn == 'secondary' ? BorderSide(color: greenDark, width: 2) : null,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: plan.colorBtn == 'secondary' ? 0 : 5,
                  ),
                  child: Text(
                    plan.precio == 0 ? 'Tu Plan Actual' : 'Elegir Plan',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // BADGE DE RECOMENDADO
          if (plan.recomendado)
            Positioned(
              top: -12,
              left: 0, 
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: greenPrimary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: const Text(
                    "RECOMENDADO",
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getBtnColor(String type) {
    switch (type) {
      case 'primary': return greenPrimary;
      case 'dark': return greenDark;
      case 'secondary': return Colors.transparent;
      default: return greenPrimary;
    }
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: isActive ? greenPrimary : greenDark),
            const SizedBox(height: 2),
            Text(
              label, 
              style: TextStyle(
                fontSize: 10, 
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? greenPrimary : greenDark
              )
            ),
          ],
        ),
      ),
    );
  }
}