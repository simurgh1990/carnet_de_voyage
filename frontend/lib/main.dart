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

  // Initialisation de Firebase
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDWBQ0DwZxpzeSR9ZwM-InNb6dhn3E4xNo",
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
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Pendant la vérification de l'état de connexion, afficher un loader
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        final bool isLoggedIn = snapshot.hasData;

        // Configuration de GoRouter
        final GoRouter router = GoRouter(
          // Si l'utilisateur est connecté, il est redirigé vers la page d'accueil. Sinon, vers la page de login.
          initialLocation: isLoggedIn ? '/' : '/login',
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
            final currentLocation = state.uri.toString();

            // Si l'utilisateur est connecté et essaie d'aller sur /login ou /register, redirige-le vers la page d'accueil
            if (isLoggedIn && (currentLocation == '/login' || currentLocation == '/register')) {
              return '/';
            }

            // Si l'utilisateur n'est pas connecté et tente d'accéder à une autre page que /login ou /register, redirige-le vers /login
            if (!isLoggedIn && currentLocation != '/login' && currentLocation != '/register') {
              return '/login';
            }

            return null; // Pas de redirection nécessaire
          },
          refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
        );

        // Retourne MaterialApp avec le router
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

// Classe pour rafraîchir GoRouter à chaque changement d'état d'authentification
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners(); // Notification initiale

    stream.listen((_) {
      notifyListeners(); // Notification à chaque changement d'état
    });
  }
}