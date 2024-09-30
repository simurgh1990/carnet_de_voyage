import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

// Import des pages
import 'screens/home_screen.dart';
import 'screens/trip/trip_screen.dart';
import 'screens/wallet_screen.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configuration de Firebase en fonction de la plateforme
  if (kIsWeb) {
    // Initialisation spécifique pour le Web
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDWBQ0DwZxpzeSR9ZwM-InNb6dhn3E4xNo",
        authDomain: "carnet-de-voyage-20c9a.firebaseapp.com",
        projectId: "carnet-de-voyage-20c9a",
        storageBucket: "carnet-de-voyage-20c9a.appspot.com",
        messagingSenderId: "156623633534",
        appId: "1:156623633534:android:950ab4d298ac3303062c2f",
      ),
    );
  } else {
    // Initialisation pour Android et iOS - cela utilisera les fichiers de configuration 
    await Firebase.initializeApp();
  }
  runApp(CarnetDeVoyageApp());
}

class CarnetDeVoyageApp extends StatelessWidget {
  CarnetDeVoyageApp({super.key});

  // Configuration de go_router avec écoute de l'état d'authentification
  final GoRouter _router = GoRouter(
    initialLocation: FirebaseAuth.instance.currentUser == null ? '/login' : '/', // Définit la page initiale
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
        path: '/wallet',
        builder: (context, state) => const WalletScreen(),
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

      final isGoingToLogin = currentLocation == '/login';
      final isGoingToRegister = currentLocation == '/register';

      // Si l'utilisateur est connecté et essaie d'aller à la page de connexion ou d'inscription, rediriger vers la page d'accueil
      if (isLoggedIn && (isGoingToLogin || isGoingToRegister)) {
        return '/';
      }

      // Si l'utilisateur n'est pas connecté et tente d'aller ailleurs que la page de connexion ou d'inscription, le rediriger vers /login
      if (!isLoggedIn && currentLocation != '/login' && currentLocation != '/register') {
        return '/login';
      }

      return null; // Pas de redirection nécessaire
    },
    refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Carnet de Voyage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
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