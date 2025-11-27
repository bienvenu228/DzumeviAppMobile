// lib/core/providers/app_provider.dart
import 'package:dzumevimobile/core/provider/candidats.dart';
import 'package:dzumevimobile/core/provider/concours.dart';
import 'package:dzumevimobile/core/provider/paiement.dart';
import 'package:flutter/foundation.dart';

class AppProvider with ChangeNotifier {
  final ConcoursProvider concoursProvider = ConcoursProvider();
  final CandidatProvider candidatProvider = CandidatProvider();
  final PaiementProvider paiementProvider = PaiementProvider();

  // Initialiser l'application
  Future<void> initializeApp() async {
    await concoursProvider.loadConcours();
  }

  // Rafraîchir toutes les données
  Future<void> refreshAll() async {
    await concoursProvider.refresh();
    if (candidatProvider.currentConcoursId != null) {
      await candidatProvider.refreshCandidats();
    }
  }
}