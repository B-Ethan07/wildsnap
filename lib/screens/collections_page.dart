import 'package:flutter/material.dart';
import 'package:wildsnap/widgets/custom_appbar.dart';
import 'package:wildsnap/widgets/name_view.dart';
import 'package:wildsnap/widgets/pic_collection.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbar(),
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NameView(),
                const SizedBox(height: 20),
                Expanded(
                  child: PicCollection(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        )
    );
  }
}
