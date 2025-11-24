import 'package:flutter/material.dart';

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Agenda
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.menu, size: 24),
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
                    child: const Icon(Icons.person, color: Colors.grey, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text("5 Octubre 2025", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text("Jueves", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[500])),
              const SizedBox(height: 32),

              // Timeline Simple
              _buildEvent("08:00 AM", "Respiración", true),
              _buildEvent("10:30 AM", "Disminuir estrés", false),
              _buildEvent("04:00 PM", "Meditación guiada", false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEvent(String time, String title, bool active) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: active ? Border.all(color: Colors.purple, width: 1) : null,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Text(time, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[500])),
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}