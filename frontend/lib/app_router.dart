import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';
import 'screens/home_screen.dart';
import 'screens/trip/trip_screen.dart';
import 'stream_listenable.dart'; // Importe la classe StreamListenable

final GoRouter appRouter = GoRouter(
  initialLocation: FirebaseAuth.instance.currentUser == null ? '/login' : '/', // Définit la route initiale
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/trip/:tripId',
      builder: (context, state) {
        final tripId = state.pathParameters['tripId']!;
        return TripDetailScreen(tripId: tripId);
      },
    ),
  ],
  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final currentLocation = state.uri.toString(); // Utilise `state.uri.toString()` à la place de `state.location`
    
    final goingToLogin = currentLocation == '/login';
    final goingToRegister = currentLocation == '/register';

    // Si l'utilisateur est connecté et tente d'aller à /login ou /register, on le redirige vers /
    if (isLoggedIn && (goingToLogin || goingToRegister)) {
      return '/';
    }

    // Si l'utilisateur n'est pas connecté et tente d'aller ailleurs que /login ou /register, on le redirige vers /login
    if (!isLoggedIn && currentLocation != '/login' && currentLocation != '/register') {
      return '/login';
    }

    return null; // Pas de redirection nécessaire
  },
  refreshListenable: StreamListenable(FirebaseAuth.instance.authStateChanges()), // Utilise StreamListenable
);