// lib/enums/concours_statut.dart
import 'package:flutter/material.dart';

enum ConcoursStatut {
  enCours('en cours'),
  passe('passé'),
  aVenir('à venir');

  const ConcoursStatut(this.value);
  
  final String value;
  
  static ConcoursStatut fromString(String value) {
    switch (value) {
      case 'en cours':
        return ConcoursStatut.enCours;
      case 'passé':
        return ConcoursStatut.passe;
      case 'à venir':
        return ConcoursStatut.aVenir;
      default:
        return ConcoursStatut.aVenir;
    }
  }
  
  static Color getColor(ConcoursStatut statut) {
    switch (statut) {
      case ConcoursStatut.enCours:
        return Colors.green;
      case ConcoursStatut.passe:
        return Colors.red;
      case ConcoursStatut.aVenir:
        return Colors.orange;
    }
  }
  
  static IconData getIcon(ConcoursStatut statut) {
    switch (statut) {
      case ConcoursStatut.enCours:
        return Icons.play_circle_filled;
      case ConcoursStatut.passe:
        return Icons.check_circle;
      case ConcoursStatut.aVenir:
        return Icons.schedule;
    }
  }

  static String getDisplayText(ConcoursStatut statut) {
    switch (statut) {
      case ConcoursStatut.enCours:
        return 'En Cours';
      case ConcoursStatut.passe:
        return 'Terminé';
      case ConcoursStatut.aVenir:
        return 'À Venir';
    }
  }
}