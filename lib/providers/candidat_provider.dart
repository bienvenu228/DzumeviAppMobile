import 'package:flutter/foundation.dart';
import '../models/candidat.dart';
import '../services/candidat_service.dart';

class CandidatProvider with ChangeNotifier {
  final CandidatService _service = CandidatService();
  List<Candidat> candidats = [];
  bool isLoading = false;

  Future<void> loadCandidats(int voteId) async {
    isLoading = true;
    notifyListeners();

    // candidats = await _service.getCandidatsByVote(voteId);

    isLoading = false;
    notifyListeners();
  }
}
