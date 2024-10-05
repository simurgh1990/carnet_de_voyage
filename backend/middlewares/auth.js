const jwt = require('jsonwebtoken');

// Fonction pour générer un token JWT
function generateToken(user) {
  const token = jwt.sign(
    { id: user.id, email: user.email }, // Payload avec les infos utilisateur
    process.env.JWT_SECRET || 'default_secret_key', // Utilisation de la clé JWT sécurisée depuis .env
    { expiresIn: '1h' } // Durée de validité du token
  );
  return token;
}

// Middleware pour vérifier le token JWT
function authMiddleware(req, res, next) {
  const authHeader = req.headers['authorization'];
  
  // Vérifie que le header Authorization existe
  if (!authHeader) {
    return res.status(403).json({ success: false, message: 'Token is required' });
  }

  const token = authHeader.split(' ')[1]; // Récupère le token après "Bearer"

  // Si le token est absent
  if (!token) {
    return res.status(403).json({ success: false, message: 'Token is required' });
  }

  // Vérification du token JWT
  jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
    if (err) {
      return res.status(401).json({ success: false, message: 'Invalid token' });
    }

    req.user = decoded; // Ajoute les infos utilisateur à req.user
    next(); // Passe à la prochaine middleware ou route
  });
}

module.exports = { generateToken, authMiddleware };