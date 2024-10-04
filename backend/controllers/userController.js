// ajouter un document à une collection
const { db } = require('./firebaseAdmin');

async function addDocument() {
  const docRef = db.collection('users').doc('user1');
  await docRef.set({
    nom: 'Doe',
    prenom: 'John',
    email: 'johndoe@example.com'
  });
  console.log('Document ajouté');
}

addDocument();

// lire un document
async function getDocument() {
    const docRef = db.collection('users').doc('user1');
    const doc = await docRef.get();
  
    if (doc.exists) {
      console.log('Données du document:', doc.data());
    } else {
      console.log('Aucun document trouvé');
    }
  }
  
  getDocument();

  // mettre à jour un document
  async function updateDocument() {
    const docRef = db.collection('users').doc('user1');
    await docRef.update({
      prenom: 'Jane'
    });
    console.log('Document mis à jour');
  }
  
  updateDocument();

  //supprimer un document
  async function deleteDocument() {
    const docRef = db.collection('users').doc('user1');
    await docRef.delete();
    console.log('Document supprimé');
  }
  
  deleteDocument();