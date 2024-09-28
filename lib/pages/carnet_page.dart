import 'package:flutter/material.dart';

class CarnetPage extends StatelessWidget {
  const CarnetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carnet de Voyage'),
      ),
      body: const Center(
        child: Text('Page du carnet de voyage'),
      ),
    );
  }
}