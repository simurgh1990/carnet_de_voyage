// controllers/tripController.js

exports.createTrip = (req, res) => {
    // Logique pour créer un trip
    res.status(201).send('Trip created');
};

exports.getAllTrips = (req, res) => {
    // Logique pour obtenir tous les trips
    res.status(200).send('All trips');
};

exports.getTripById = (req, res) => {
    // Logique pour obtenir un trip par ID
    res.status(200).send('Trip by ID');
};

exports.updateTrip = (req, res) => {
    // Logique pour mettre à jour un trip
    res.status(200).send('Trip updated');
};

exports.deleteTrip = (req, res) => {
    // Logique pour supprimer un trip
    res.status(200).send('Trip deleted');
};