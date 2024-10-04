const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

// Route pour l'inscription
router.post('/register', authController.register);

// Route pour la connexion via email/mot de passe ou Google
router.post('/login', authController.login);  // Utilisation de Firebase pour vérifier le token

// Route pour déconnecter l'utilisateur
router.post('/logout', authController.logout);

module.exports = router;