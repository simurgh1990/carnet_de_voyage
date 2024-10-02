import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  ProfilScreenState createState() => ProfilScreenState();
}

class ProfilScreenState extends State<ProfilScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  String? _imageUrl;
  String _name = '';
  String _bio = '';

  // Récupérer l'UID de l'utilisateur actuel
  User? get currentUser => _auth.currentUser;

  // Contrôleurs de texte pour la modification
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    if (currentUser != null) {
      DocumentSnapshot userProfile = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (userProfile.exists) {
        setState(() {
          _name = userProfile['name'] ?? '';
          _bio = userProfile['bio'] ?? '';
          _imageUrl = userProfile['profileImageUrl'] ?? '';
        });
        _nameController.text = _name;
        _bioController.text = _bio;
      }
    }
  }

  Future<void> _uploadProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      TaskSnapshot uploadTask = await _storage
          .ref('profile_images/${currentUser!.uid}.jpg')
          .putFile(imageFile);

      String downloadUrl = await uploadTask.ref.getDownloadURL();

      setState(() {
        _imageUrl = downloadUrl;
      });

      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .update({'profileImageUrl': _imageUrl});
    }
  }

  Future<void> _updateUserProfile() async {
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser!.uid).set({
        'name': _nameController.text,
        'bio': _bioController.text,
        'profileImageUrl': _imageUrl,
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil mis à jour avec succès !')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Affiche l'image de profil
            if (_imageUrl != null && _imageUrl!.isNotEmpty)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(_imageUrl!),
              )
            else
              CircleAvatar(
                radius: 50,
                child: Icon(Icons.person),
              ),
            const SizedBox(height: 20),
            // IconButton pour permettre à l'utilisateur de télécharger une nouvelle image de profil
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: _uploadProfileImage,
              tooltip: 'Changer l\'image de profil',
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nom'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _bioController,
                decoration: InputDecoration(labelText: 'Bio'),
              ),
            ),
            ElevatedButton(
              onPressed: _updateUserProfile,
              child: Text('Mettre à jour le profil'),
            ),
          ],
        ),
      ),
    );
  }
}