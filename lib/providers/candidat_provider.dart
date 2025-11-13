import 'package:flutter/foundation.dart';
import '../models/candidat.dart';
import '../services/candidat_service.dart';

class CandidatProvider with ChangeNotifier {
  List<Candidat> candidats = [];
  bool isLoading = false;

  Future<void> loadCandidats(int voteId) async {
    isLoading = true;
    notifyListeners();

    try {
      // ⚡ Appel statique via la classe, pas via une instance
      candidats = await CandidatService.getCandidatsByVote(voteId);
    } catch (e) {
      // Gérer l'erreur si nécessaire
      debugPrint("Erreur lors du chargement des candidats : $e");
      candidats = [];
    }

    isLoading = false;
    notifyListeners();
  }
}
