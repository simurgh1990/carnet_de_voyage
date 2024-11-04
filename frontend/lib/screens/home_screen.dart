import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:carnet_de_voyage/screens/trip/add_trip_screen.dart';
import 'profil_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Liste des pages pour le bottom navigation
  static const List<Widget> _pages = <Widget>[
    HomePageContent(),
    Center(child: Text("Carte")), // Placeholder for Map Screen
    Center(child: Text("Checklist")), // Placeholder for Checklist Screen
    ProfilScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Fonction pour déconnecter l'utilisateur et rediriger vers la page de login
  void _signOut(BuildContext context) {
    GoRouter.of(context).go('/login');
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carnet de Voyage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateTripPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.71, -0.71),
            end: Alignment(-0.71, 0.71),
            colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
          ),
        ),
        child: Center(
          child: _pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Carte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'Checklist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF2196F3), // Couleur de l'icône sélectionnée
        unselectedItemColor: Colors.grey, // Couleur des icônes non sélectionnées
        type: BottomNavigationBarType.fixed, // Garde tous les items visibles
      ),
    );
  }
}

// Contenu de la page d'accueil
class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/logo_nomadnotes.png',
          width: 200,
          height: 160,
        ),
        const SizedBox(height: 20),
        Text(
          'Bienvenue dans votre Carnet de Voyage',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Placeholder pour une future fonctionnalité
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            minimumSize: const Size(200, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Text(
            'Autre fonctionnalité',
            style: TextStyle(color: Color(0xFF2196F3)),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateTripPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4CAF50),
            minimumSize: const Size(200, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Text(
            'Créer un Nouveau Carnet',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}