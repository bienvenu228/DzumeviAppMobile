import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class AppConstants {
  static const String baseUrl = "http://192.168.0.41:8080/Dzumevi_APi/public/api";
  // Couleurs officielles du Togo + vibe moderne
  static const Color primary = Color(0xFF006A4E); // Vert Togo
  static const Color secondary = Color(0xFFFFC107); // Jaune étoile
  static const Color accent = Color(0xFFD32F2F); // Rouge drapeau
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB00020);

  // Couleurs paiement
  static const Color tMoneyColor = Color(0xFF00A651); // Vert Togocel
  static const Color floozColor = Color(0xFF0066CC); // Bleu Moov

  // Textes
  static const String appName = "Dzumevi";
  static const String slogan = "Votez avec votre cœur, payez avec votre mobile";

  // Tarification (à rendre dynamique plus tard via API)
  static const int prixParVote = 100; // FCFA

  // URLs (dev / prod)
  static const String privacyPolicyUrl = "https://dzumevi.com/privacy";
  static const String termsUrl = "https://dzumevi.com/terms";
}

extension ThemeColors on BuildContext {
  Color get primary => Theme.of(this).primaryColor;
  Color get secondary => Theme.of(this).colorScheme.secondary;
  Color get tMoney => AppConstants.tMoneyColor;
  Color get flooz => AppConstants.floozColor;
  Color get background => Theme.of(this).colorScheme.background;
  Color get surface => Theme.of(this).colorScheme.surface;
}
