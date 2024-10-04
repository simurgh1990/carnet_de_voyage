const admin = require('../firebaseConfig');
const { generateToken } = require('../middlewares/auth');

// Connexion de l'utilisateur
exports.login = async (req, res) => {
    const { idToken } = req.body;

    try {
        // Vérifie l'authenticité du token Firebase reçu depuis le frontend
        const decodedToken = await admin.auth().verifyIdToken(idToken);
        const uid = decodedToken.uid;

        // Génère un token JWT à partir de l'ID utilisateur Firebase
        const token = generateToken({ id: uid, email: decodedToken.email });

        // Renvoie le token JWT
        res.json({ token });
    } catch (error) {
        res.status(401).send('Authentication failed');
    }
};

// Inscription d'un utilisateur
exports.register = (req, res) => {
    // Logique pour enregistrer un utilisateur
    res.status(201).send('User registered');
};

// Déconnexion de l'utilisateur
exports.logout = (req, res) => {
    // Logique pour déconnecter un utilisateur
    res.status(200).send('User logged out');
};