const express = require('express');
const router = express.Router();

// Import des différents modules de route
const authRoutes = require('./authRoutes');
const tripRoutes = require('./tripRoutes');
// const mediaRoutes = require('./mediaRoutes');
// const userRoutes = require('./userRoutes');

// Utilisation des routes
router.use('/auth', authRoutes);
router.use('/trips', tripRoutes);
// router.use('/media', mediaRoutes);
// router.use('/users', userRoutes);

module.exports = router;