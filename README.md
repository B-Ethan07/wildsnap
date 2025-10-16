# WildSnap

**Application mobile Flutter pour photographier et partager des observations d'animaux sauvages.**

## Description

WildSnap est une plateforme communautaire permettant aux utilisateurs de documenter leurs rencontres avec la faune.  
L'application offre un flux social, la gestion de collections personnelles et l'intégration de faits animaliers via une API.

## Fonctionnalités

### Authentification

- Inscription et connexion par email/mot de passe  
- Connexion via Google Sign-In  
- Gestion de session utilisateur

### Pages principales

- **Home** : Flux communautaire des publications + intégration de la Cat Fact API  
- **Ajout** : Capture photo et formulaire de publication (nom, type, description)  
- **Collection** : Galerie personnelle, profil utilisateur et déconnexion

### Interface

- Support du mode sombre/clair  
- Navigation par onglets  
- Design responsive

## Stack technique

- **Flutter** : Framework mobile  
- **Firebase Authentication** : Gestion des utilisateurs  
- **Cloud Firestore** : Base de données  
- **Firebase Storage** : Stockage d'images  
- **Cat Fact API** : Contenu additionnel

## Installation

### Prérequis

- Flutter SDK 3.0+  
- Compte Firebase

### Configuration

1. Cloner le repository :
   ```bash
   git clone https://github.com/B-Ethan07/wildsnap
   cd wildsnap
   flutter pub get
   ```

2. Configurer Firebase
   - Créer un projet sur [Firebase Console](https://console.firebase.google.com)
   - Ajouter les applications Android/iOS
   - Télécharger `google-services.json` et `GoogleService-Info.plist`
   - Activer Authentication (Email/Password et Google)
   - Créer une base de donnée Firestore

3. Placer les fichiers de configuration
```
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```

4. Lancer l'application
```bash
flutter run
```

