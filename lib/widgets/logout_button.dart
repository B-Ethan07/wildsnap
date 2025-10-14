import 'package:flutter/material.dart';
import 'package:wildsnap/services/auth_service.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () async {
          await AuthService().signOut();
        },
      ),
    );
  }
}
