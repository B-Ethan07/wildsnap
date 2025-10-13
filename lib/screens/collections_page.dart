import 'package:flutter/material.dart';
import 'package:wildsnap/services/auth_service.dart';
import 'package:wildsnap/widgets/custom_appbar.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(),
      body: Center(
                child: IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await AuthService().signOut();
                  },
                )
            )
    );
  }
}
