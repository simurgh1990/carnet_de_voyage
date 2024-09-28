import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Importe les fichiers de tes pages
import 'package:carnet_de_voyage/lib/screens/home_page.dart';
import 'package:carnet_de_voyage/lib/screens/carnet_page.dart';
import 'package:carnet_de_voyage/lib/screens/wallet_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configuration de Firebase en fonction de la plateforme
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AlzaSyDWBQ0DwZxpzeSR9ZwMl-nNb6dhn3E4xNo", 
        authDomain: "carnet-de-voyage-20c9a.firebaseapp.com", 
        projectId: "carnet-de-voyage-20c9a", 
        storageBucket: "carnet-de-voyage-20c9a.appspot.com", 
        messagingSenderId: "156623633534", 
        appId: "1:156623633534:web:2c41d045c952e12f062c2f", 
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carnet de Voyage',
      debugShowCheckedModeBanner: false, // Supprime la bannière de debug
      theme: ThemeData(
        primarySwatch: Colors.blue, // Tu peux personnaliser la couleur du thème ici
      ),
      // La page d'accueil par défaut
      home: HomePage(), 
      
      // Définition des routes pour naviguer entre les pages
      routes: {
        '/carnet': (context) => CarnetPage(),
        '/wallet': (context) => WalletPage(),
      },
    );
  }
}