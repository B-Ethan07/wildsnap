import 'package:cloud_firestore/cloud_firestore.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createPost({
    required String animalName,
    required String location,
    String? description,
    required String imageUrl,
    String? userId,
  }) async {
    try {
      final docRef = _firestore.collection('posts').doc();
      final postId = docRef.id;

      await docRef.set({
        'animalName': animalName,
        'location': location,
        'description': description ?? '',
        'imageUrl': imageUrl,
        'userId': userId ?? 'anonymous',
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Post créé avec succès: $postId');
    } catch (e) {
      print('Erreur lors de la création du post: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
