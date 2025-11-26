# 🚀 Guide de Démarrage - Authentification Dzumevi

## Installation Rapide

### 1. Dépendances
```bash
cd c:\project\mobile\flutter\DzumeviAppMobile
flutter pub get
```

### 2. Lancer l'Application
```bash
flutter run
```

## 🔐 Flux de Connexion

### À chaque démarrage:
1. **AuthCheckScreen** s'affiche (écran de chargement)
2. Vérification automatique de l'authentification
3. Redirection vers:
   - **LoginPage** si non connecté
   - **AdminDashboard** si admin connecté
   - **HomeScreen** si utilisateur connecté

### Connexion:
```
LoginPage
  ↓ [Rentre identifiants]
  ↓ [Clique "Se connecter"]
  ↓ [Authentification avec backend]
  ↓ [Si succès]
  ├─ Admin → AdminDashboard
  └─ Utilisateur → HomeScreen
```

### Déconnexion:
```
AdminDashboard ou HomeScreen
  ↓ [Clique bouton logout]
  ↓ [Confirmation dialog]
  ↓ [Clique "Déconnexion"]
  ↓
LoginPage
```

## 📝 Identifiants de Test

### Admin
- **Identifiant:** BienvenuAdmin
- **Mot de passe:** [Selon votre base de données]
- **Redirection:** AdminDashboard

### Utilisateur Normal
- **Identifiant:** [Tout autre utilisateur]
- **Mot de passe:** [Son mot de passe]
- **Redirection:** HomeScreen

## 🔧 Configuration

### URL du Backend
Modifier dans `lib/services/auth_service.dart`:
```dart
final String baseUrl = "http://127.0.0.1:8000/api";
```

### Couleurs
- Admin: `Color(0xFF1976D2)` (Bleu)
- Utilisateur: Défaut Material

## 📚 Fichiers Importants

| Fichier | Description |
|---------|-------------|
| `lib/main.dart` | Point d'entrée, routes |
| `lib/screens/auth_check_screen.dart` | Vérification auth au démarrage |
| `lib/screens/login_page.dart` | Formulaire de connexion |
| `lib/services/auth_service.dart` | Service d'authentification |
| `lib/screens/home_screen.dart` | Page utilisateur |
| `lib/screens/Admin/dashboard.dart` | Page admin |

## ✅ Checklist Avant Production

```
[ ] Backend Laravel configuré
[ ] AdminSeeder exécuté
[ ] HTTPS activé
[ ] Identifiants de test fonctionnels
[ ] Déconnexion testée
[ ] Authentification automatique testée
[ ] Erreurs affichées correctement
```

## 🔍 Vérification Rapide

### 1. Authentification correcte
```bash
# Tester avec Postman/Insomnia
POST http://127.0.0.1:8000/api/auth/login
Body: {"name": "BienvenuAdmin", "password": "..."}
```

### 2. App s'affiche correctement
```bash
flutter run
# Doit afficher AuthCheckScreen puis LoginPage
```

### 3. Connexion fonctionne
- Rentre identifiants
- Clic "Se connecter"
- Vérifie la redirection

### 4. Déconnexion fonctionne
- Clic bouton logout
- Confirme
- Vérifie redirection vers LoginPage

## 📞 Problèmes Courants

### "Connection refused"
→ Vérifier que Laravel est en cours d'exécution
```bash
php artisan serve
```

### Les identifiants ne fonctionnent pas
→ Vérifier dans la base de données
```sql
SELECT * FROM admins;
SELECT * FROM votants;
```

### Écran blanc au démarrage
→ Vérifier les logs
```bash
flutter run -v
```

## 🎓 Architecture Simplifiée

```
┌─ AuthCheckScreen (Démarrage)
│  ├─ Vérifie si connecté
│  └─ Redirige
│
├─ LoginPage (Connexion)
│  ├─ Formulaire
│  └─ AuthService.login()
│
├─ AdminDashboard (Admin)
│  └─ Logout
│
└─ HomeScreen (Utilisateur)
   └─ Logout
```

## 💡 Conseils

1. **Développement:** Gardez le développement local pendant le test
2. **Production:** Passez à HTTPS
3. **Sécurité:** Ne partagez pas les identifiants en clair
4. **Logs:** Utilisez les logs Flutter pour déboguer

## 📖 Documentation Complète

Pour plus de détails, consultez:
- `FINAL_SUMMARY.md` - Résumé complet
- `AUTHENTICATION_GUIDE.md` - Guide technique détaillé
- `CODE_EXAMPLES.md` - Exemples de code

---

**Version:** 1.0.0
**Status:** ✅ Prêt pour la production
