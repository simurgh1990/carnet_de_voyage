import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

// Import des pages
import 'screens/home_screen.dart';
import 'screens/trip/trip_screen.dart';
import 'screens/profil_screen.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuration de Firebase en fonction de la plateforme
  if (kIsWeb) {
    // Initialisation spécifique pour le Web avec les bonnes options
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDWBQ0DwZxpzeSR9ZwM-InNb6dhn3E4xNo",
        authDomain: "carnet-de-voyage-20c9a.firebaseapp.com",
        projectId: "carnet-de-voyage-20c9a",
        storageBucket: "carnet-de-voyage-20c9a.appspot.com",
        messagingSenderId: "156623633534",
        appId: "1:156623633534:web:2c41d045c952e12f062c2f", // App ID pour le Web
      ),
    );
  } else {
    // Initialisation pour Android et iOS - cela utilisera les fichiers de configuration natifs
    await Firebase.initializeApp();
  }

  runApp(CarnetDeVoyageApp());
}

class CarnetDeVoyageApp extends StatelessWidget {
  const CarnetDeVoyageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Afficher un indicateur de chargement
        }

        // Configuration de go_router après la vérification de l'authentification
        final GoRouter router = GoRouter(
          initialLocation: snapshot.hasData ? '/' : '/login', // Définir la route initiale
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: '/carnet/:tripId',
              builder: (context, state) {
                final tripId = state.pathParameters['tripId']!;
                return TripDetailScreen(tripId: tripId);
              },
            ),
            GoRoute(
              path: '/profil',
              builder: (context, state) => const ProfilScreen(),
            ),
            GoRoute(
              path: '/login',
              builder: (context, state) => const LoginScreen(),
            ),
            GoRoute(
              path: '/register',
              builder: (context, state) => const RegisterScreen(),
            ),
          ],
          redirect: (context, state) {
            final isLoggedIn = FirebaseAuth.instance.currentUser != null;
             final currentLocation = state.uri.toString(); // Utilise `state.uri.toString()` à la place de `state.location`

            // Si l'utilisateur est connecté et essaie d'aller sur /login ou /register, redirige vers /
            if (isLoggedIn && (currentLocation == '/login' || currentLocation == '/register')) {
              return '/';
            }

            // Si l'utilisateur n'est pas connecté et essaie d'accéder à d'autres pages que /login ou /register, redirige vers /login
            if (!isLoggedIn && currentLocation != '/login' && currentLocation != '/register') {
              return '/login';
            }

            return null; // Pas de redirection nécessaire
          },
          refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
        );

        return MaterialApp.router(
          title: 'Carnet de Voyage',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routerConfig: router,
        );
      },
    );
  }
}

// Classe pour écouter les changements d'état d'authentification et informer GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners(); // Notification initiale

    stream.listen((_) {
      notifyListeners(); // Notification à chaque changement d'état
    });
  }
}