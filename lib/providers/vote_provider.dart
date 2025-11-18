import 'package:flutter/foundation.dart';
import '../models/vote.dart';
import '../services/vote_service.dart' hide Vote;

class VoteProvider with ChangeNotifier {
  final VoteService _service = VoteService();
  List<Vote> votes = [];
  bool isLoading = false;

  Future<void> fetchVotes() async {
    isLoading = true;
    notifyListeners();

    votes = await _service.getVotes();

    isLoading = false;
    notifyListeners();
  }
}
