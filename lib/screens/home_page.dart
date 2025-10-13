import 'package:flutter/material.dart';
import 'package:wildsnap/widgets/custom_appbar.dart';
import 'package:wildsnap/widgets/new_post_home.dart';
import 'package:wildsnap/widgets/random_catfact.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RandomCatfact(),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "New Post",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            NewPostHome(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}