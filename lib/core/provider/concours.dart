// lib/core/providers/concours_provider.dart
import 'package:dzumevimobile/core/services/concours_api.dart';
import 'package:flutter/foundation.dart';
import 'package:dzumevimobile/models/concours.dart';

class ConcoursProvider with ChangeNotifier {
  List<Concours> _concours = [];
  bool _isLoading = false;
  String _error = '';
  Concours? _selectedConcours;

  // Getters
  List<Concours> get concours => _concours;
  bool get isLoading => _isLoading;
  String get error => _error;
  Concours? get selectedConcours => _selectedConcours;

  // Récupérer tous les concours actifs
  Future<void> loadConcours() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _concours = await ApiService.getConcoursActifs();
      _error = '';
    } catch (e) {
      _error = 'Erreur lors du chargement des concours: $e';
      _concours = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sélectionner un concours
  void selectConcours(Concours concours) {
    _selectedConcours = concours;
    notifyListeners();
  }

  // Effacer la sélection
  void clearSelection() {
    _selectedConcours = null;
    notifyListeners();
  }

  // Récupérer les concours par statut
  List<Concours> getConcoursByStatut(String statut) {
    return _concours.where((c) => c.statut == statut).toList();
  }

  // Récupérer les concours actifs
  List<Concours> get concoursActifs {
    return _concours.where((c) => c.statut == 'actif').toList();
  }

  // Rafraîchir les données
  Future<void> refresh() async {
    await loadConcours();
  }
}