// lib/core/providers/candidat_provider.dart
import 'package:dzumevimobile/core/services/concours_api.dart';
import 'package:flutter/foundation.dart';
import 'package:dzumevimobile/models/candidat.dart';
import 'package:dzumevimobile/models/concours.dart';

class CandidatProvider with ChangeNotifier {
  List<Candidat> _candidats = [];
  bool _isLoading = false;
  String _error = '';
  Candidat? _selectedCandidat;
  int? _currentConcoursId;

  // Getters
  List<Candidat> get candidats => _candidats;
  bool get isLoading => _isLoading;
  String get error => _error;
  Candidat? get selectedCandidat => _selectedCandidat;
  int? get currentConcoursId => _currentConcoursId;

  // Récupérer les candidats d'un concours
  Future<void> loadCandidatsByConcours(int concoursId) async {
   _isLoading = true;
    _error = '';
    _currentConcoursId = concoursId;
    notifyListeners();

    try {
      final candidats = await ApiService.getCandidatsByConcours(concoursId);
      
      // Filtre les candidats invalides si nécessaire
      _candidats = candidats.where((c) => c.id > 0).toList();
      _error = '';
    } catch (e) {
      _error = 'Erreur lors du chargement des candidats: $e';
      _candidats = [];
      print('Erreur détaillée: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }

  }

  // Sélectionner un candidat
  void selectCandidat(Candidat candidat) {
    _selectedCandidat = candidat;
    notifyListeners();
  }

  // Effacer la sélection
  void clearSelection() {
    _selectedCandidat = null;
    notifyListeners();
  }

  // Trier les candidats par votes (décroissant)
  List<Candidat> get candidatsTries {
    return List<Candidat>.from(_candidats)
      ..sort((a, b) => b.votes.compareTo(a.votes));
  }

  // Obtenir le candidat en tête
  Candidat? get leader {
    if (_candidats.isEmpty) return null;
    return candidatsTries.first;
  }

  // Calculer le total des votes
  int get totalVotes {
    return _candidats.fold(0, (sum, candidat) => sum + candidat.votes);
  }

  // Rafraîchir les candidats
  Future<void> refreshCandidats() async {
    if (_currentConcoursId != null) {
      await loadCandidatsByConcours(_currentConcoursId!);
    }
  }
  
}