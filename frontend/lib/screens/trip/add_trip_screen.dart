import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour l'encodage JSON
import 'package:logger/logger.dart'; // Importer le package logger

// Initialise un logger
var logger = Logger();

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({super.key}); // Utilisation du super parameter

  @override
  CreateTripPageState createState() => CreateTripPageState();
}

class CreateTripPageState extends State<CreateTripPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  DateTime? startDate;
  DateTime? endDate;

  // Méthode pour sélectionner une date
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  // Méthode pour envoyer les données au backend
  Future<void> createTrip(String title, String description, DateTime startDate, DateTime endDate) async {
    final String apiUrl = 'https://ton-api-url/api/trips';
    final token = "TonTokenJWT"; // Remplace avec ton vrai token JWT

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i('Carnet créé avec succès'); // Remplace print par logger
        return; // Fin de la méthode en cas de succès
      } else {
        logger.e('Erreur lors de la création du carnet : ${response.statusCode}'); // Remplace print par logger
        throw Exception('Erreur lors de la création du carnet');
      }
    } catch (e) {
      logger.e('Erreur : $e'); // Remplace print par logger
      rethrow; // Lancer à nouveau l'exception pour qu'elle soit captée par le catch
    }
  }

  // Méthode pour gérer la création du carnet
  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await createTrip(title, description, startDate!, endDate!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Carnet créé avec succès')),
          );
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de la création du carnet')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un Carnet de Voyage'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Titre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
                onSaved: (value) {
                  title = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  description = value!;
                },
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _selectDate(context, true),
                    child: Text('Date de début'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _selectDate(context, false),
                    child: Text('Date de fin'),
                  ),
                ],
              ),
              if (startDate != null)
                Text('Date de début sélectionnée : ${startDate.toString()}'),
              if (endDate != null)
                Text('Date de fin sélectionnée : ${endDate.toString()}'),
              SizedBox(height: 20),
              // Bouton de soumission avec le code pour créer le carnet
              ElevatedButton(
                onPressed: _handleSubmit, // Appel de la méthode asynchrone
                child: Text('Créer le carnet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}