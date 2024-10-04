const admin = require('firebase-admin');
const serviceAccount = require('../firebaseAdmin/firebase-adminsdk-carnet_de_voyage.json');

// Initialisation de Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// Initialisation de Firestore
const db = admin.firestore();

// Exporter Firebase Admin et Firestore
module.exports = { admin, db };