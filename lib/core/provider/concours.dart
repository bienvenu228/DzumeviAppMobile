// lib/providers/concours_provider.dart
import 'package:dzumevimobile/core/services/concours_api.dart';
import 'package:dzumevimobile/models/concours.dart';
import 'package:flutter/foundation.dart';

class ConcoursProvider with ChangeNotifier {
  final ConcoursApiService _apiService;

  ConcoursProvider({required ConcoursApiService apiService})
      : _apiService = apiService;

  // États
  List<Concours> _concoursList = [];
  bool _isLoading = false;
  String _error = '';
  Concours? _selectedConcours;

  // Getters
  List<Concours> get concoursList => _concoursList;
  bool get isLoading => _isLoading;
  String get error => _error;
  Concours? get selectedConcours => _selectedConcours;

  // Concours filtrés par statut
  List<Concours> get concoursEnCours => _concoursList.where((c) => c.isActive).toList();
  List<Concours> get concoursAVenir => _concoursList.where((c) => c.isComing).toList();
  List<Concours> get concoursPasses => _concoursList.where((c) => c.isFinished).toList();

  // Charger tous les concours
  Future<void> loadAllConcours() async {
    _setLoading(true);
    _setError('');

    try {
      final concours = await _apiService.getAllConcours();
      _concoursList = concours;
      notifyListeners();
    } catch (e) {
      _setError('Erreur lors du chargement des concours: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Charger un concours spécifique
  Future<void> loadConcoursById(int id) async {
    _setLoading(true);
    _setError('');

    try {
      final concours = await _apiService.getConcoursById(id);
      _selectedConcours = concours;
      notifyListeners();
    } catch (e) {
      _setError('Erreur lors du chargement du concours: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Sélectionner un concours
  void selectConcours(Concours concours) {
    _selectedConcours = concours;
    notifyListeners();
  }

  // Recherche
  List<Concours> searchConcours(String query) {
    if (query.isEmpty) return _concoursList;
    
    return _concoursList.where((concours) =>
        concours.name.toLowerCase().contains(query.toLowerCase()) ||
        concours.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Méthodes privées
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  // Nettoyer
  void clear() {
    _concoursList.clear();
    _selectedConcours = null;
    _error = '';
    notifyListeners();
  }
}