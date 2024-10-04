const jwt = require('jsonwebtoken');

// Fonction pour générer un token
function generateToken(user) {
  const token = jwt.sign(
    { id: user.id, email: user.email }, // Données à inclure dans le token
    'secret_key', // Utilise une clé plus sécurisée en production
    { expiresIn: '1h' } // Expiration du token
  );
  return token;
}

// Middleware pour vérifier le token JWT
function authMiddleware(req, res, next) {
  const token = req.headers['authorization'];
  if (!token) {
    return res.status(403).send('Token is required');
  }

  jwt.verify(token, 'secret_key', (err, decoded) => {
    if (err) {
      return res.status(401).send('Invalid token');
    }
    req.user = decoded; // Stocke les informations utilisateur dans req.user
    next();
  });
}

module.exports = { generateToken, authMiddleware };