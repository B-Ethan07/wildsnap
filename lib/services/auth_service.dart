import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/foundation.dart' show kDebugMode;

/// Gère l'authentification email/password et Google (Web + Mobile)
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Stream pour écouter les changements d'état d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Obtenir l'utilisateur actuellement connecté
  User? get currentUser => _auth.currentUser;

  /// Inscription avec email et mot de passe
  Future<UserCredential?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Validation des entrées
      if (email.trim().isEmpty || !email.contains('@')) {
        throw 'Adresse email invalide.';
      }
      if (password.length < 6) {
        throw 'Le mot de passe doit contenir au moins 6 caractères.';
      }
      if (name.trim().isEmpty) {
        throw 'Le nom ne peut pas être vide.';
      }

      // Création du compte
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Mise à jour du profil
      await userCredential.user?.updateDisplayName(name.trim());
      await userCredential.user?.reload();

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  // Connexion avec email et mot de passe
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Validation des entrées
      if (email.trim().isEmpty || !email.contains('@')) {
        throw 'Adresse email invalide.';
      }
      if (password.isEmpty) {
        throw 'Le mot de passe ne peut pas être vide.';
      }

      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  // Déconnecte l'utilisateur de Firebase et de Google (si applicable)
  Future<void> signOut() async {
    try {
      // Déconnexion de Google uniquement sur mobile
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// Connexion avec Google
  /// Utilise signInWithPopup sur Web et google_sign_in sur Mobile
  Future<UserCredential> loginWithGoogle() async {
    try {
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        googleProvider.setCustomParameters({
          'prompt': 'select_account',
        });

        return await _auth.signInWithPopup(googleProvider);

      } else {
        await _googleSignIn.signOut();

        final googleAccount = await _googleSignIn.signIn();

        if (googleAccount == null) {
          throw 'Connexion annulée.';
        }

        final googleAuth = await googleAccount.authentication;

        if (googleAuth.accessToken == null || googleAuth.idToken == null) {
          throw 'Impossible d\'obtenir les informations d\'authentification.';
        }

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        return await _auth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      throw _handleAuthException(e);
    } catch (e) {
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }

      final errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('popup') && errorMsg.contains('closed')) {
        throw 'Connexion annulée.';
      }
      if (errorMsg.contains('network')) {
        throw 'Erreur de connexion. Vérifiez votre connexion internet.';
      }

      throw 'Erreur lors de la connexion avec Google.';
    }
  }

  /// Réinitialisation du mot de passe par email
  Future<void> resetPassword(String email) async {
    try {
      if (email.trim().isEmpty || !email.contains('@')) {
        throw 'Adresse email invalide.';
      }

      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Gestion centralisée des erreurs Firebase avec messages localisés
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Le mot de passe est trop faible (minimum 6 caractères).';
      case 'email-already-in-use':
        return 'Un compte existe déjà avec cet email.';
      case 'invalid-email':
        return 'L\'adresse email est invalide.';
      case 'user-not-found':
        return 'Aucun compte trouvé avec cet email.';
      case 'wrong-password':
        return 'Mot de passe incorrect.';
      case 'too-many-requests':
        return 'Trop de tentatives. Veuillez réessayer dans quelques minutes.';
      case 'account-exists-with-different-credential':
        return 'Un compte existe avec cet email. Utilisez une autre méthode de connexion.';
      case 'invalid-credential':
        return 'Les informations d\'identification sont invalides ou ont expiré.';
      case 'operation-not-allowed':
        return 'Cette méthode de connexion n\'est pas activée.';
      case 'user-disabled':
        return 'Ce compte a été désactivé.';
      case 'popup-closed-by-user':
        return 'Connexion annulée.';
      case 'cancelled-popup-request':
        return 'Connexion annulée.';
      case 'popup-blocked':
        return 'La popup a été bloquée. Autorisez les popups pour ce site.';
      default:
      // Log l'erreur pour le débogage (en dev uniquement)
        if (kDebugMode) {
          return 'Erreur (${e.code}): ${e.message}';
        }
        return 'Une erreur est survenue. Veuillez réessayer.';
    }
  }
}
