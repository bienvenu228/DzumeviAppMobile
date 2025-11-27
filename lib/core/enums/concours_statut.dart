// lib/core/enums/concours_statut.dart
import 'dart:ui';

import 'package:flutter/material.dart';

enum ConcoursStatut {
  actif,
  inactif,
  termine;

  static String getDisplayText(String statut) {
    switch (statut) {
      case 'actif':
        return 'en cours';
      case 'inactif':
        return 'à venir';
      case 'termine':
        return 'passé';
      default:
        return 'Inconnu';
    }
  }

  static Color getColor(String statut) {
    switch (statut) {
      case 'actif':
        return Colors.green;
      case 'inactif':
        return Colors.orange;
      case 'termine':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  static IconData getIcon(String statut) {
    switch (statut) {
      case 'actif':
        return Icons.play_circle_fill;
      case 'inactif':
        return Icons.pause_circle_filled;
      case 'termine':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }
}