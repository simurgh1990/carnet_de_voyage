import 'package:flutter/material.dart';
import 'package:carnet_de_voyage/screens/trip/trip_screen.dart';
import 'package:carnet_de_voyage/screens/trip/add_trip_screen.dart'; // Importe la page de création de carnet
import 'profil_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> { 
  int _selectedIndex = 0;

  // Ajout d'un bouton dans la page d'accueil pour créer un nouveau carnet
  static const List<Widget> _pages = <Widget>[
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Bienvenue dans votre Carnet de Voyage'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: null, // Placeholder pour un autre bouton
            child: Text('Autre fonctionnalité'),
          ),
        ],
      ),
    ),
    TripDetailScreen(tripId: '123'), 
    ProfilScreen(), 
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
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Naviguer vers la page de création de carnet de voyage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateTripPage()),
              );
            },
          )
        ],
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
            icon: Icon(Icons.person_2_rounded),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}