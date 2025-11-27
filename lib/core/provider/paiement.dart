// lib/core/providers/paiement_provider.dart
import 'package:dzumevimobile/core/services/concours_api.dart';
import 'package:flutter/foundation.dart';
import 'package:dzumevimobile/models/paiement.dart';

class PaiementProvider with ChangeNotifier {
  PaiementResponse? _currentPaiement;
  bool _isProcessing = false;
  String _error = '';
  bool _isVerifying = false;

  // Getters
  PaiementResponse? get currentPaiement => _currentPaiement;
  bool get isProcessing => _isProcessing;
  bool get isVerifying => _isVerifying;
  String get error => _error;

  // Effectuer un paiement
  Future<PaiementResponse?> effectuerPaiement({
    dynamic dataToSend
  }) async {
    _isProcessing = true;
    _error = '';
    notifyListeners();

    try {
      final response = await ApiService.effectuerPaiement(
        dataToSend
      );

      _currentPaiement = response;
      _error = '';
      return response;
    } catch (e) {
      _error = 'Erreur lors du paiement: $e';
      _currentPaiement = null;
      return null;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  // Vérifier le statut d'un paiement
  Future<PaiementResponse?> verifierStatutPaiement(String transactionId) async {
    _isVerifying = true;
    _error = '';
    notifyListeners();

    try {
      final response = await ApiService.verifierStatutPaiement(transactionId);
      _currentPaiement = response;
      _error = '';
      return response;
    } catch (e) {
      _error = 'Erreur lors de la vérification: $e';
      return null;
    } finally {
      _isVerifying = false;
      notifyListeners();
    }
  }

  // Effacer le paiement courant
  void clearPaiement() {
    _currentPaiement = null;
    _error = '';
    notifyListeners();
  }

  // Réinitialiser les erreurs
  void clearError() {
    _error = '';
    notifyListeners();
  }
}