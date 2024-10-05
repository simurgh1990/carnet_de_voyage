// controllers/tripController.js
const { db } = require('../config/firebaseConfig');

// Créer un nouveau carnet de voyage
exports.createTrip = async (req, res) => {
  const { title, destination, startDate, endDate, description } = req.body;

  if (!title || !destination || !startDate || !endDate) {
    return res.status(400).json({ success: false, message: 'Tous les champs requis doivent être remplis.' });
  }

  try {
    // Crée un document dans Firestore
    const tripRef = db.collection('trips').doc();
    const newTrip = {
      id: tripRef.id, // génère automatiquement un id pour le voyage
      title,
      destination,
      startDate,
      endDate,
      description,
      userId: req.user.id, // l'id de l'utilisateur récupéré à partir du middleware auth
      createdAt: new Date(),
    };

    await tripRef.set(newTrip); // Enregistre les données dans Firestore

    return res.status(201).json({ success: true, message: 'Voyage créé avec succès !', trip: newTrip });
  } catch (error) {
    console.error('Erreur lors de la création du voyage:', error);
    return res.status(500).json({ success: false, message: 'Erreur lors de la création du voyage.', error });
  }
};

// Obtenir tous les voyages d'un utilisateur
exports.getAllTrips = async (req, res) => {
  try {
    const tripsSnapshot = await db.collection('trips').where('userId', '==', req.user.id).get();
    const trips = tripsSnapshot.docs.map(doc => doc.data());

    return res.status(200).json({ success: true, trips });
  } catch (error) {
    console.error('Erreur lors de la récupération des voyages:', error);
    return res.status(500).json({ success: false, message: 'Erreur lors de la récupération des voyages.', error });
  }
};

// Obtenir un voyage par ID
exports.getTripById = async (req, res) => {
  const { tripId } = req.params;

  try {
    const tripDoc = await db.collection('trips').doc(tripId).get();
    if (!tripDoc.exists) {
      return res.status(404).json({ success: false, message: 'Voyage non trouvé.' });
    }

    return res.status(200).json({ success: true, trip: tripDoc.data() });
  } catch (error) {
    console.error('Erreur lors de la récupération du voyage:', error);
    return res.status(500).json({ success: false, message: 'Erreur lors de la récupération du voyage.', error });
  }
};

// Mettre à jour un voyage
exports.updateTrip = async (req, res) => {
  const { tripId } = req.params;
  const { title, destination, startDate, endDate, description } = req.body;

  try {
    const tripRef = db.collection('trips').doc(tripId);

    const tripDoc = await tripRef.get();
    if (!tripDoc.exists) {
      return res.status(404).json({ success: false, message: 'Voyage non trouvé.' });
    }

    await tripRef.update({
      title,
      destination,
      startDate,
      endDate,
      description,
      updatedAt: new Date(),
    });

    return res.status(200).json({ success: true, message: 'Voyage mis à jour avec succès.' });
  } catch (error) {
    console.error('Erreur lors de la mise à jour du voyage:', error);
    return res.status(500).json({ success: false, message: 'Erreur lors de la mise à jour du voyage.', error });
  }
};

// Supprimer un voyage
exports.deleteTrip = async (req, res) => {
  const { tripId } = req.params;

  try {
    const tripRef = db.collection('trips').doc(tripId);
    const tripDoc = await tripRef.get();
    if (!tripDoc.exists) {
      return res.status(404).json({ success: false, message: 'Voyage non trouvé.' });
    }

    await tripRef.delete();

    return res.status(200).json({ success: true, message: 'Voyage supprimé avec succès.' });
  } catch (error) {
    console.error('Erreur lors de la suppression du voyage:', error);
    return res.status(500).json({ success: false, message: 'Erreur lors de la suppression du voyage.', error });
  }
};