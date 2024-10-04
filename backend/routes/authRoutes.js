// routes liées à l'authentification 

const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const { generateToken } = require('../middlewares/auth');

// Route pour l'inscription
router.post('/register', authController.register);

// Route pour la connexion
router.post('/login', (req, res) => {
    const user = req.body;
    
    // Simule une vérification des identifiants (à remplacer par Firebase Auth)
    if (user.email && user.password) {
        const token = generateToken(user); // Génère un token JWT
        res.json({ token });
    } else {
        res.status(401).send('Invalid login');
    }
});

// Route pour déconnecter l'utilisateur
router.post('/logout', authController.logout);

module.exports = router;