//import 'dart:io';
import 'package:flutter/material.dart';
import 'src/screens/welcome.dart'; // Importa la pantalla de bienvenida
//import '../src/services/api_service.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bienestar Digital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Define la pantalla de bienvenida como la pantalla inicial
      home: const WelcomeScreen(),
    );
  }
}