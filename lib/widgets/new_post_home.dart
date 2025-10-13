import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wildsnap/services/post_service.dart';

class NewPostHome extends StatefulWidget {
  const NewPostHome({Key? key}) : super(key: key);

  @override
  _NewPostHomeState createState() => _NewPostHomeState();
}

class _NewPostHomeState extends State<NewPostHome> {
  final PostService _postService = PostService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _postService.getPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final posts = snapshot.data!.docs;
          return Column(
            children: posts.map((post) {
              final isDark = Theme
                  .of(context)
                  .brightness == Brightness.dark;

              return Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  boxShadow: isDark
                      ? [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: Offset(0, 0),
                    ),
                  ]
                      : [],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Card(
                  color: isDark ? Colors.black87 : Colors.amber[200],
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        post['imageUrl'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 400,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Animal:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(post['animalName']),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Localisation:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(post['location']),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Description:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(post['description'], style:
                                  TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              );
            }).toList(),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
