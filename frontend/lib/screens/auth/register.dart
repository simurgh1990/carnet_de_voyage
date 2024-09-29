import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../services/firestore_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService(); // Instance du service Firestore

  // Méthode pour gérer l'inscription de l'utilisateur
  Future<void> _register() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();
    final String name = _nameController.text.trim();

    // Vérification que les mots de passe correspondent
    if (password != confirmPassword) {
      if (!mounted) return; // Vérifie si le widget est monté avant d'utiliser `context`
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Les mots de passe ne correspondent pas')),
      );
      return;
    }

    try {
      // Inscription de l'utilisateur avec Firebase
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ajoute les données de l'utilisateur dans Firestore
      await _firestoreService.addUserData(name);

      // Inscription réussie
      if (!mounted) return; // Vérifie si le widget est monté avant d'utiliser `context`
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inscription réussie')),
      );

      // Redirection vers la page principale après l'inscription
      context.go('/'); // Redirige vers la page d'accueil

    } on FirebaseAuthException catch (e) {
      if (!mounted) return; // Vérifie si le widget est monté avant d'utiliser `context`

      // Gérer les codes d'erreurs de Firebase spécifiques
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Cet e-mail est déjà utilisé. Veuillez en choisir un autre.';
          break;
        case 'invalid-email':
          errorMessage = 'L\'adresse e-mail n\'est pas valide. Veuillez entrer un e-mail valide.';
          break;
        case 'weak-password':
          errorMessage = 'Le mot de passe est trop faible. Il doit contenir au moins 6 caractères.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'L\'inscription avec un e-mail/mot de passe est désactivée.';
          break;
        default:
          errorMessage = e.message ?? 'Une erreur inconnue est survenue.';
      }

      // Affiche le message d'erreur spécifique
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );

    } catch (e) {
      // Capture les autres erreurs potentielles
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur inconnue : $e')),
      );
    }
  }

  // Méthode pour gérer la réinitialisation du mot de passe
  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      if (!mounted) return; // Vérifie si le widget est monté avant d'utiliser `context`
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un e-mail valide.')),
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      if (!mounted) return; // Vérifie si le widget est monté avant d'utiliser `context`
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail de réinitialisation envoyé.')),
      );
    } catch (e) {
      if (!mounted) return; // Vérifie si le widget est monté avant d'utiliser `context`
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'envoi de l\'e-mail de réinitialisation : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirmez le mot de passe'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _register, // Appel à la fonction d'inscription
              child: const Text("S'inscrire"),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _resetPassword, // Ajout de la fonctionnalité de mot de passe oublié
              child: const Text("Mot de passe oublié ?"),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                context.go('/login'); // Redirection vers la page de connexion
              },
              child: const Text("Déjà inscrit ? Connectez-vous"),
            ),
          ],
        ),
      ),
    );
  }
}