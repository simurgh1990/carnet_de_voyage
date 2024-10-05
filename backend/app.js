const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const dotenv = require('dotenv');

// Charger les variables d'environnement
dotenv.config();

// Importer Firebase Admin et Firestore depuis firebaseConfig.js
const { db } = require('./config/firebaseConfig');

// Importe express
const app = express();

// Configuration CORS avec des origines spécifiques
const corsOptions = {
  origin: ['http://localhost:5001', 'https://carnet-de-voyage-20c9a.firebaseapp.com'], // Origines autorisées
  methods: ['GET', 'POST', 'PUT', 'DELETE'], // Méthodes autorisées
  allowedHeaders: ['Content-Type', 'Authorization'], // Headers autorisés
};

app.use(cors(corsOptions)); // Appliquer la configuration CORS
app.use(bodyParser.json()); // Parser les requêtes JSON

// Route de test pour vérifier si l'API fonctionne
app.get('/', (req, res) => {
  res.send('Carnet de voyage API est en ligne !');
});

// Import et utilisation des routes d'authentification
const authRoutes = require('./routes/authRoutes');
app.use('/auth', authRoutes);  // Ajout de la route pour l'authentification

// Import et utilisation des routes centralisées
const routes = require('./routes'); // Importe le fichier index.js du dossier routes
app.use('/api', routes);            // Utilise les routes avec le préfixe /api

// Démarrer le serveur
const PORT = process.env.PORT || 5001;
app.listen(PORT, () => {
  console.log(`Serveur démarré sur le port ${PORT}`);
});