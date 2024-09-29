import 'package:flutter/material.dart';

class TripDetailScreen extends StatelessWidget {
  final String tripId;

  const TripDetailScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du voyage $tripId'),
      ),
      body: Center(
        child: Text('Affichage des détails du voyage pour le tripId: $tripId'),
      ),
    );
  }
}