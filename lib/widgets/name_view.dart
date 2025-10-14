import 'package:flutter/material.dart';
import 'package:wildsnap/services/auth_service.dart';
import 'package:wildsnap/widgets/logout_button.dart';

class NameView extends StatefulWidget {
  const NameView({Key? key}) : super(key: key);

  @override
  _NameViewState createState() => _NameViewState();
}
  final AuthService _authService = AuthService();
class _NameViewState extends State<NameView> {

  final user = _authService.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bonjour, ${user?.displayName}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
            LogoutButton(),
          ],
        )

      );
  }
}
