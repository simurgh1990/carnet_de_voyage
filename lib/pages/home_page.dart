import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Retrait de 'const' ici
        title: const Text('Accueil'), // Garder 'const' ici car 'Text' est constant
      ),
      body: const Center(
        child: Text('Bienvenue sur la page d\'accueil!'),
      ),
    );
  }
}