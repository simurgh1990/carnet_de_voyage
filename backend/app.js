const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const dotenv = require('dotenv');

// Charger les variables d'environnement
dotenv.config();

const app = express();

// Middlewares
app.use(cors()); // Autoriser les requêtes cross-origin
app.use(bodyParser.json()); // Parser les requêtes JSON

// Route de test pour vérifier si l'API fonctionne
app.get('/', (req, res) => {
  res.send('Carnet de voyage API est en ligne !');
});

// Import et utilisation des routes centralisées
const routes = require('./routes'); // Importe le fichier index.js du dossier routes
app.use('/api', routes);            // Utilise les routes avec le préfixe /api

// Démarrer le serveur
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Serveur démarré sur le port ${PORT}`);
});