import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:wildsnap/screens/login_screen.dart';
import 'package:wildsnap/screens/register_page.dart';
import 'package:wildsnap/screens/main_screen.dart';
import 'package:wildsnap/theme.dart';
import 'package:wildsnap/widgets/auth_wrapper.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WildSnap',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,

      // AuthWrapper gère automatiquement la navigation
      home: const AuthWrapper(),

      // Routes nommées pour la navigation
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
