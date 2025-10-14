import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createPost({
    required String animalName,
    required String location,
    String? description,
    required String imageUrl,
  }) async {
    try {
      final User? user = AuthService().currentUser;
      final String userId = user?.uid ?? 'anonymous';

      final docRef = _firestore.collection('posts').doc();
      final postId = docRef.id;

      await docRef.set({
        'animalName': animalName,
        'location': location,
        'description': description ?? '',
        'imageUrl': imageUrl,
        'userId': userId,
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

  Stream<QuerySnapshot> getUserPosts() {
    final String? userId = AuthService().currentUser?.uid;
    if (userId == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }
}
