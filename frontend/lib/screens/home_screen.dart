import 'package:flutter/material.dart';
import 'trip/trip_screen.dart';
import 'wallet_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState(); // Supprimer l'underscore ici
}

class HomeScreenState extends State<HomeScreen> { // Supprimer l'underscore ici
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Page d\'accueil')),
    TripDetailScreen(tripId: '123'), // Exemple d'écran de détail de voyage
    WalletScreen(), // Exemple d'écran de portefeuille
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carnet de Voyage'),
      ),
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
            label: 'Portefeuille',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}