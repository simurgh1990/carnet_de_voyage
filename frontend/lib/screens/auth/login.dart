import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // Pour utiliser jsonEncode

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger(); // Initialise le logger

  // Méthode pour envoyer le idToken au backend
  Future<void> _sendIdTokenToBackend(String idToken) async {
    final url = Uri.parse('http://localhost:3000/auth/login'); // URL de ton backend
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',  // JSON content type
      },
      body: jsonEncode({
        'idToken': idToken,  // Envoyer le idToken dans le corps de la requête
      }),
    );

    if (response.statusCode == 200) {
      // Si le token est envoyé avec succès
      _logger.i(idToken);('Token envoyé au backend avec succès');
    } else {
      // Erreur lors de l'envoi du token
      _logger.e('Erreur: ${response.body}');
    }
  }

  // Méthode pour la connexion via email
  Future<void> _signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = _auth.currentUser;

      if (user != null) {
        String idToken = await user.getIdToken() ?? ''; // Assure que tu as une chaîne vide si le token est nul
        _logger.i(idToken);  // Ce token devra être envoyé au backend
        await _sendIdTokenToBackend(idToken); // Envoyer le token au backend
      }

      if (!mounted) return;
      context.go('/');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${e.message ?? 'Erreur de connexion'}')),
      );

      _logger.e('FirebaseAuthException: ${e.code} - ${e.message}');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur inconnue : $e')),
      );

      _logger.e('Erreur inconnue : $e');
    }
  }

  // Méthode pour réinitialiser le mot de passe
  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un e-mail valide.')),
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail de réinitialisation envoyé.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'envoi de l\'e-mail de réinitialisation : $e')),
      );

      _logger.e('Erreur lors de la réinitialisation du mot de passe : $e');
    }
  }

  // Méthode pour gérer la connexion via Google
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return; // L'utilisateur a annulé la connexion
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      User? user = _auth.currentUser;

      if (user != null) {
        String idToken = await user.getIdToken() ?? ''; // Assure que tu as une chaîne vide si le token est nul
        _logger.i(idToken);  // Ce token devra être envoyé au backend
        await _sendIdTokenToBackend(idToken); // Envoyer le token au backend
      }

      if (!mounted) return;
      context.go('/');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion avec Google : ${e.message}')),
      );

      _logger.e('FirebaseAuthException (Google): ${e.code} - ${e.message}');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur inconnue avec Google : $e')),
      );

      _logger.e('Erreur inconnue avec Google : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _signIn, // Appel à la fonction de connexion par e-mail
              child: const Text('Se connecter'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _signInWithGoogle, // Appel à la fonction de connexion via Google
              icon: Image.asset(
                'assets/google_logo.png', // Chemin vers ton image
                height: 24,
              ),
              label: const Text('Se connecter avec Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Utilisez 'backgroundColor' au lieu de 'primary'
                foregroundColor: Colors.black, // Utilisez 'foregroundColor' au lieu de 'onPrimary'
                minimumSize: const Size(double.infinity, 36),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _resetPassword, // Ajout de la fonctionnalité de mot de passe oublié
              child: const Text("Mot de passe oublié ?"),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                context.go('/register'); // Redirige vers la page d'inscription
              },
              child: const Text("Pas encore inscrit ? Créez un compte"),
            ),
          ],
        ),
      ),
    );
  }
}