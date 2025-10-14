import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wildsnap/screens/open_one_post.dart';
import 'package:wildsnap/services/post_service.dart';

class PicCollection extends StatefulWidget {
  const PicCollection({Key? key}) : super(key: key);

  @override
  _PicCollectionState createState() => _PicCollectionState();
}

class _PicCollectionState extends State<PicCollection> {

  final PostService _postService = PostService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _postService.getUserPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Aucun post trouvé pour cet utilisateur.'));
          }
          final posts = snapshot.data!.docs;
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Card(
            color: isDark ? Colors.black : Colors.amber[200],
            shadowColor: isDark ? Colors.white : Colors.black,
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final data = post.data() as Map<String, dynamic>;
                    final imageUrl = data['imageUrl'] ?? '';
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OpenOnePost(postId: post.id),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark ? Colors.white : Colors.black,
                            width: 0.3,
                          ),
                        ),
                        clipBehavior: Clip.hardEdge, // pour que l'image suive le borderRadius
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
    );
  }
}
