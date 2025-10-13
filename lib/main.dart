import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:wildsnap/screens/login_screen.dart';
import 'package:wildsnap/screens/register_page.dart';
import 'package:wildsnap/theme.dart';
import 'package:wildsnap/widgets/auth_wrapper.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initialise les Widgets
  await Firebase.initializeApp( // Initialise la connexion avec Firebase
  options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    // Ecoute les widget et le changement de thème
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),  // Crée une instance du Theme
        child: const MyApp(),            // Tout ce qui est en dessous peut y accéder
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
      initialRoute: '/login',
      // pour le dev
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
      title: 'WildSnap',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      // AuthWrapper gère automatiquement la navigation selon l'état d'auth
      home: const AuthWrapper(),
    );
  }
}
