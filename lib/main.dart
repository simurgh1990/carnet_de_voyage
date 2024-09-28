import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Import des pages
import 'pages/home_page.dart';
import 'pages/carnet_page.dart';
import 'pages/wallet_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configuration de Firebase en fonction de la plateforme
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
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

  runApp(const CarnetDeVoyageApp());
}

class CarnetDeVoyageApp extends StatelessWidget {
  const CarnetDeVoyageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carnet de Voyage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, // Couleur de thème personnalisée
      ),
      home: const MainScreen(), // La page d'accueil par défaut
      routes: {
        '/carnet': (context) => const CarnetPage(),
        '/wallet': (context) => const WalletPage(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState(); // Renommé en MainScreenState
}

// La classe est maintenant publique
class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const HomePage(),
    const CarnetPage(),
    const WalletPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Carnet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}