// Routes pour la gestion des carnets de voyage

const express = require('express');
const router = express.Router();
const tripController = require('../controllers/tripController');
const { authMiddleware } = require('../middlewares/auth');

// Ajouter un nouveau carnet de voyage
router.post('/', authMiddleware, tripController.createTrip);

// Obtenir tous les carnets de voyage d'un utilisateur
router.get('/', authMiddleware, tripController.getAllTrips);

// Obtenir un carnet de voyage spécifique
router.get('/:tripId', authMiddleware, tripController.getTripById);

// Mettre à jour un carnet de voyage
router.put('/:tripId', authMiddleware, tripController.updateTrip);

// Supprimer un carnet de voyage
router.delete('/:tripId', authMiddleware, tripController.deleteTrip);

module.exports = router;