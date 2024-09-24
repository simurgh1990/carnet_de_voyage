const admin = require('firebase-admin');
const serviceAccount = require('./firebase-adminsdk-carnet_de_voyage.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

module.exports = admin;