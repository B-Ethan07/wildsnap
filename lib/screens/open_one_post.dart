import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wildsnap/services/post_service.dart';

class OpenOnePost extends StatefulWidget {
  final String postId;

  const OpenOnePost({required this.postId, Key? key}) : super(key: key);

  @override
  _OpenOnePostState createState() => _OpenOnePostState();
}

class _OpenOnePostState extends State<OpenOnePost> {
  final PostService _postService = PostService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Détail du Post')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _postService.getPostById(widget.postId),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            final post = snapshot.data!;
            final data = post.data() as Map<String, dynamic>;

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(data['imageUrl']),
                  SizedBox(height: 16),
                  Text('Animal: ${data['animalName']}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Localisation: ${data['location']}',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(data['description'], style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
