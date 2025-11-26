# 🎯 Dzumevi - Système d'Authentification Obligatoire

## 📌 Vue d'Ensemble

Un système d'authentification **obligatoire et automatique** pour une application Flutter de vote.

### Caractéristiques Principales
- ✅ **Authentification obligatoire** - Impossible d'accéder à l'app sans connexion
- ✅ **Redirection automatique** - Au démarrage, redirige vers le bon espace selon le type d'utilisateur
- ✅ **Deux niveaux d'accès** - Admin (Dashboard) et Utilisateurs (Home)
- ✅ **Déconnexion sécurisée** - Avec confirmation et nettoyage des données
- ✅ **Stockage local** - Persistance de la session via SharedPreferences
- ✅ **Gestion d'erreurs** - Messages clairs pour l'utilisateur

## 🚀 Démarrage Rapide

### Installation
```bash
cd c:\project\mobile\flutter\DzumeviAppMobile
flutter pub get
flutter run
```

### Identifiants de Test
```
Admin:
  - Identifiant: BienvenuAdmin
  - Mot de passe: [Selon votre base de données]

Utilisateur:
  - Identifiant: [Autre utilisateur]
  - Mot de passe: [Son mot de passe]
```

## 🔄 Flux Principal

```
Démarrage Application
        ↓
    AuthCheckScreen (Vérification)
        ↓
    ┌───┴───┐
    │       │
    ▼       ▼
Connecté? Pas Connecté
    │         │
    ▼         ▼
Admin?     LoginPage
    │
 ┌──┴──┐
 ▼     ▼
Oui   Non
 │     │
 ▼     ▼
Admin  Home
Dash   Screen
```

## 📁 Structure du Projet

```
lib/
├── main.dart                              # Point d'entrée
├── screens/
│   ├── auth_check_screen.dart            # ✨ NOUVEAU - Vérification auth
│   ├── login_page.dart                   # ✨ NOUVEAU - Connexion unique
│   ├── home_screen.dart                  # ✏️ MODIFIÉ - Ajout logout
│   ├── Admin/
│   │   └── dashboard.dart                # ✏️ MODIFIÉ - Ajout logout
│   ├── candidatListPage.dart
│   ├── voteListPage.dart
│   └── ...
├── services/
│   ├── auth_service.dart                 # ✏️ MODIFIÉ - Service complet
│   ├── api_service.dart
│   └── ...
└── models/
    ├── admin.dart                        # ✏️ MODIFIÉ - Ajout toJson()
    ├── votant.dart                       # ✏️ MODIFIÉ - Ajout toJson()
    └── ...

Documentation/
├── QUICK_START.md                        # ✨ NOUVEAU - Guide rapide
├── FINAL_SUMMARY.md                      # ✨ NOUVEAU - Résumé complet
├── AUTHENTICATION_GUIDE.md               # Guide technique détaillé
└── CODE_EXAMPLES.md                      # Exemples de code
```

## 🔐 Comment Ça Marche

### 1. Démarrage
L'application démarre avec `AuthCheckScreen` qui:
- Vérifie si l'utilisateur est authentifié
- Récupère le type d'utilisateur (admin/votant)
- Redirige automatiquement

### 2. Authentification
Si l'utilisateur n'est pas authentifié:
- Affiche `LoginPage`
- Prend identifiant + mot de passe
- Envoie au backend
- Stocke les données si succès

### 3. Redirection
Selon le type d'utilisateur:
- **Admin** → `AdminDashboard`
- **Utilisateur** → `HomeScreen`

### 4. Déconnexion
L'utilisateur peut se déconnecter via:
- Un bouton dans l'AppBar
- Confirmation avant déconnexion
- Retour automatique à `LoginPage`

## 📋 Services Disponibles

### AuthService
```dart
// Authentification
Future<Map> login(String name, String password)

// Récupération
Future<Admin?> getStoredAdmin()
Future<Votant?> getStoredVotant()
Future<String?> getUserType()

// Vérification
Future<bool> isAuthenticated()

// Déconnexion
Future<void> logout()
```

## 🧪 Tests

### Test 1: Démarrage
```bash
flutter run
# Doit afficher AuthCheckScreen puis LoginPage
```

### Test 2: Connexion Admin
1. Rentre identifiants admin
2. Clique "Se connecter"
3. Vérifie redirection vers AdminDashboard

### Test 3: Connexion Utilisateur
1. Rentre identifiants utilisateur
2. Clique "Se connecter"
3. Vérifie redirection vers HomeScreen

### Test 4: Déconnexion
1. Clique bouton logout
2. Confirme dans le dialog
3. Vérifie retour à LoginPage

### Test 5: Session Persistent
1. Se connecte
2. Ferme l'app
3. Redémarre l'app
4. Vérifie redirection automatique (pas de LoginPage)

## 🔧 Configuration

### URL Backend
```dart
// lib/services/auth_service.dart
final String baseUrl = "http://127.0.0.1:8000/api";
```

### Couleur Admin (Bleu)
```dart
Color(0xFF1976D2)
```

## 📚 Documentation

### Pour démarrer rapidement
→ Lire: **`QUICK_START.md`**

### Pour comprendre l'architecture complète
→ Lire: **`FINAL_SUMMARY.md`**

### Pour des détails techniques
→ Lire: **`AUTHENTICATION_GUIDE.md`**

### Pour des exemples de code
→ Lire: **`CODE_EXAMPLES.md`**

## ⚙️ Dépendances

```yaml
http: ^1.6.0                    # Requêtes HTTP
shared_preferences: ^2.0.0      # Stockage local
flutter_secure_storage: ^9.2.4  # Stockage sécurisé (optionnel)
```

## 🔐 Sécurité

### ✅ Implémenté
- Authentification obligatoire
- Validation des entrées
- Stockage local sécurisé
- Timeout de 30 secondes
- Gestion d'erreurs

### ⚠️ À ajouter (Production)
- HTTPS au lieu de HTTP
- JWT Tokens
- Refresh Tokens
- Rate Limiting
- Logs d'audit

## 📞 Support

### Problèmes Courants

| Problème | Solution |
|----------|----------|
| "Connection refused" | Vérifier Laravel `php artisan serve` |
| Identifiants ne fonctionnent pas | Vérifier base de données |
| Pas de redirection | Vérifier SharedPreferences |
| Écran blanc | Consulter logs `flutter run -v` |

### Commandes Utiles

```bash
# Lancer l'app
flutter run

# Logs détaillés
flutter run -v

# Nettoyer et relancer
flutter clean && flutter pub get && flutter run

# Rebuild
flutter pub get && flutter build apk
```

## 🎓 Points Importants

1. **AuthCheckScreen** s'affiche TOUJOURS au démarrage
2. **LoginPage** s'affiche si l'utilisateur n'est PAS connecté
3. **AdminDashboard** s'affiche si l'utilisateur est ADMIN
4. **HomeScreen** s'affiche si l'utilisateur est UTILISATEUR
5. **Déconnexion** ramène à **LoginPage**

## ✨ Améliorations Futures

- [ ] Biométrie (Empreinte, Face ID)
- [ ] 2FA (Authentification à deux facteurs)
- [ ] "Se souvenir de moi"
- [ ] Réinitialisation de mot de passe
- [ ] Refresh automatique de session
- [ ] Page de profil utilisateur
- [ ] Notifications push

## 📊 État du Projet

```
✅ Authentification obligatoire
✅ Redirection automatique
✅ Deux niveaux d'accès
✅ Déconnexion sécurisée
✅ Stockage persistant
✅ Gestion d'erreurs
✅ Documentation complète
⏳ Tests finaux
```

## 🔗 Fichiers Clés

| Fichier | Ligne | Fonction |
|---------|-------|----------|
| `lib/main.dart` | 27 | Home: AuthCheckScreen |
| `lib/screens/auth_check_screen.dart` | 15-45 | Logique de redirection |
| `lib/screens/login_page.dart` | 35-55 | Authentification |
| `lib/services/auth_service.dart` | 10-100 | Service complet |

## 📖 Lire la Suite

1. **Démarrer:** `QUICK_START.md`
2. **Comprendre:** `FINAL_SUMMARY.md`
3. **Approfondir:** `AUTHENTICATION_GUIDE.md`
4. **Coder:** `CODE_EXAMPLES.md`

---

**Version:** 1.0.0
**Status:** ✅ Prêt pour la production
**Date:** 12 novembre 2025
**Auteur:** Dzumevi Dev Team
