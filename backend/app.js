const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const dotenv = require('dotenv');

// Charger les variables d'environnement
dotenv.config();

// Importer express et les routes
const app = express();
const routes = require('./routes'); // Centralise toutes les routes dans /routes/index.js

// Middleware global pour logger chaque requête
app.use((req, res, next) => {
  console.log(`${req.method} ${req.path}`);
  console.log('Headers:', req.headers);
  console.log('Body:', req.body);
  next();
});

// Configuration CORS globale
app.use(cors()); // Autorise toutes les origines pour le développement

// Exemple de configuration CORS avec des origines spécifiques (peut être réactivée si nécessaire)
/*
const corsOptions = {
  origin: ['http://localhost:5001', 'https://carnet-de-voyage-20c9a.firebaseapp.com'], // Origines autorisées
  methods: ['GET', 'POST', 'PUT', 'DELETE'], // Méthodes autorisées
  allowedHeaders: ['Content-Type', 'Authorization'], // Headers autorisés
};
app.use(cors(corsOptions)); // Appliquer la configuration CORS avec restrictions
*/

// Utilisation de bodyParser pour parser les requêtes JSON
app.use(bodyParser.json()); 

// Route de test pour vérifier si l'API fonctionne
app.get('/', (req, res) => {
  res.send('Carnet de voyage API est en ligne !');
});

// Utilisation des routes centralisées (toutes commenceront par /api)
app.use('/api', routes); // Toutes les routes sous /api (auth, trips, etc.)

// Gestion des erreurs (au cas où aucune route ne correspond)
app.use((req, res, next) => {
  const error = new Error('Route non trouvée');
  error.status = 404;
  next(error);
});

// Middleware pour gérer les erreurs
app.use((error, req, res, next) => {
  res.status(error.status || 500);
  res.json({
    error: {
      message: error.message,
    },
  });
});

// Démarrer le serveur
const PORT = process.env.PORT || 5001;
app.listen(PORT, () => {
  console.log(`Serveur démarré sur le port ${PORT}`);
});