import 'dart:async';
import 'package:flutter/material.dart';
import 'rutinas.dart';

// --- MODELO DE MENSAJE MEJORADO ---
class ChatMessage {
  final String text;
  final bool isUser;
  final List<String> options; // Opciones interactivas para responder
  final bool isActionLink;    // Si es un enlace a una herramienta externa (opcional)
  final VoidCallback? onActionTap;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.options = const [],
    this.isActionLink = false,
    this.onActionTap,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // COLORES DEL TEMA
  final Color greenDark = const Color(0xFF1A3C2F);
  final Color greenPrimary = const Color(0xFF2D936C);
  final Color userBubble = const Color(0xFF8BC34A); // Verde claro para usuario
  final Color botBubble = Colors.white;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  bool _isTyping = false;
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    // Saludo inicial
    Future.delayed(const Duration(milliseconds: 500), () {
      _addBotMessage(
        "¡Hola! Soy tu compañero virtual. 🌿\nEstoy aquí para escucharte y darte herramientas rápidas.\n\n¿Cómo te sientes en este momento?",
        options: ["Me siento triste 😢", "Tengo ansiedad 😰", "Estoy aburrido 😐", "Necesito un doctor 🩺"]
      );
    });
  }

  // --- CEREBRO DEL BOT (Lógica Conversacional) ---
  void _handleUserMessage(String text) {
    _addUserMessage(text);
    _controller.clear();
    setState(() => _isTyping = true);

    // Simulamos pensamiento
    Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      
      String response = "";
      List<String> nextOptions = [];
      VoidCallback? externalAction;
      bool isLink = false;

      String lower = text.toLowerCase();

      // --- 1. TRISTEZA (Manejo interno) ---
      if (lower.contains("triste") || lower.contains("mal") || lower.contains("depre") || lower.contains("llorar")) {
        response = "Siento mucho que te sientas así. Es válido tener días grises. 💙\n\n¿Te gustaría un consejo para levantar el ánimo o prefieres hacer un ejercicio de gratitud aquí mismo?";
        nextOptions = ["Dame un consejo", "Ejercicio de gratitud", "Solo quiero desahogarme"];
      }
      
      // --- 1.1 CONSEJO TRISTEZA ---
      else if (lower.contains("consejo")) {
        response = "A veces, mover el cuerpo cambia la emoción. \n\nIntenta esto: Levántate, estira los brazos hacia arriba y toma un vaso de agua fría. 💧\n\n¿Te sientes capaz de intentarlo?";
        nextOptions = ["Lo intentaré", "No tengo energía"];
      }

      // --- 1.2 EJERCICIO GRATITUD ---
      else if (lower.contains("gratitud")) {
        response = "Perfecto. Vamos a hackear tu cerebro un momento. 🧠✨\n\nDime 3 cosas simples que hayas visto hoy que no sean feas (un color, una nube, un café).";
        nextOptions = []; // Esperamos que el usuario escriba
      }

      // --- 2. ANSIEDAD (Herramientas In-Chat) ---
      else if (lower.contains("ansiedad") || lower.contains("nervios") || lower.contains("panico")) {
        response = "Respira. No estás solo/a. La ansiedad es molesta, pero pasará. 🍃\n\nHagamos una técnica rápida llamada 'Grounding'.\n\n¿Estás listo?";
        nextOptions = ["Estoy listo", "Prefiero otra cosa"];
      }

      // --- 2.1 GROUNDING ---
      else if (lower.contains("listo") || lower.contains("grounding")) {
        response = "Mira a tu alrededor (fuera de la pantalla). \n\nEscribe aquí 3 objetos de color VERDE que puedas ver ahora mismo. 👇";
        nextOptions = []; // Esperamos input del usuario
      }

      // --- 3. RESPUESTA A INPUTS DE USUARIO (Gratitud/Grounding) ---
      // Si el usuario escribe una lista o frases cortas, asumimos que está haciendo el ejercicio
      else if (text.length > 3 && (lower.contains(",") || text.split(" ").length > 2)) {
        response = "¡Excelente! 🎉 Al enfocar tu atención en el exterior, le das un descanso a tu mente.\n\n¿Cómo te sientes ahora?";
        nextOptions = ["Un poco mejor", "Igual", "Necesito más ayuda"];
      }

      // --- 4. ABURRIMIENTO / ENERGÍA ---
      else if (lower.contains("aburrido") || lower.contains("cansado")) {
        response = "El aburrimiento a veces es falta de inspiración. ¿Qué tal si pruebas una rutina rápida de 5 minutos?";
        // Aquí sí ofrecemos ir a rutinas porque es una herramienta visual
        isLink = true;
        externalAction = () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RutinasScreen()));
        nextOptions = ["Ver rutinas", "No, sigamos hablando"];
      }

      // --- 5. AYUDA PROFESIONAL (Única redirección necesaria) ---
    

      // --- DEFAULT ---
      else {
        response = "Entiendo. Estoy aquí para acompañarte. Puedes contarme más o podemos intentar una respiración guiada.";
        nextOptions = ["Respiración guiada", "Contar más"];
      }

      setState(() => _isTyping = false);
      _addBotMessage(response, options: nextOptions, isAction: isLink, onAction: externalAction);
    });
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });
    _scrollToBottom();
  }

  void _addBotMessage(String text, {List<String> options = const [], bool isAction = false, VoidCallback? onAction}) {
    setState(() {
      _messages.add(ChatMessage(
        text: text, 
        isUser: false, 
        options: options,
        isActionLink: isAction,
        onActionTap: onAction
      ));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9), // Fondo suave
      appBar: AppBar(
        backgroundColor: greenPrimary,
        title: Row(
          children: const [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.psychology, color: Color(0xFF2D936C)), // Icono más "humano"
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Asistente Virtual", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("En línea", style: TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ],
        ),
        elevation: 2,
      ),
      body: Column(
        children: [
          // ZONA DE MENSAJES
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // INDICADOR DE "ESCRIBIENDO..."
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildDot(0), const SizedBox(width: 5),
                      _buildDot(100), const SizedBox(width: 5),
                      _buildDot(200),
                    ],
                  ),
                ),
              ),
            ),

          // INPUT DE TEXTO
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              // ignore: deprecated_member_use
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: "Escribe cómo te sientes...",
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) _handleUserMessage(value);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: greenPrimary,
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) _handleUserMessage(_controller.text);
                  },
                  child: const Icon(Icons.send, color: Colors.white, size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // BURBUJA DE CHAT
  Widget _buildMessageBubble(ChatMessage msg) {
    return Column(
      crossAxisAlignment: msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          decoration: BoxDecoration(
            color: msg.isUser ? greenPrimary : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: msg.isUser ? const Radius.circular(18) : Radius.zero,
              bottomRight: msg.isUser ? Radius.zero : const Radius.circular(18),
            ),
            // ignore: deprecated_member_use
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                msg.text,
                style: TextStyle(
                  color: msg.isUser ? Colors.white : const Color(0xFF333333),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              
              // Botón de acción externa (solo si es necesario, ej: ir al doctor)
              if (msg.isActionLink && msg.onActionTap != null)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: msg.onActionTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8F5E9),
                      foregroundColor: greenDark,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Abrir sección"),
                  ),
                ),
            ],
          ),
        ),

        // OPCIONES INTERACTIVAS (CHIPS) - Solo si es mensaje del bot
        if (!msg.isUser && msg.options.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 10),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: msg.options.map((option) {
                return GestureDetector(
                  onTap: () => _handleUserMessage(option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // ignore: deprecated_member_use
                      border: Border.all(color: greenPrimary.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(color: greenPrimary, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  // Animación simple de puntos
  Widget _buildDot(int delay) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, val, child) {
        return Opacity(
          opacity: (val > 0.5) ? 1 : 0.5,
          child: Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.grey[400], shape: BoxShape.circle)),
        );
      },
      onEnd: () {}, 
    );
  }
}