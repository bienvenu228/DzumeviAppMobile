// lib/providers/vote_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/vote_result.dart';
import '../services/vote_service.dart';

class VoteState {
  final List<VoteResult> voteResults;
  final List<VoteResult> topThree;
  final int totalVotes;
  final bool isLoading;
  final String? error;

  const VoteState({
    this.voteResults = const [],
    this.topThree = const [],
    this.totalVotes = 0,
    this.isLoading = false,
    this.error,
  });

  VoteState copyWith({
    List<VoteResult>? voteResults,
    List<VoteResult>? topThree,
    int? totalVotes,
    bool? isLoading,
    String? error,
  }) {
    return VoteState(
      voteResults: voteResults ?? this.voteResults,
      topThree: topThree ?? this.topThree,
      totalVotes: totalVotes ?? this.totalVotes,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class VoteNotifier extends StateNotifier<VoteState> {
  final VoteService _voteService;

  VoteNotifier(this._voteService) : super(const VoteState());

  Future<void> loadVoteResults() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final results = await _voteService.getVoteResults();
      final totalVotes = await _voteService.getTotalVotes();
      
      // Extraire le top 3
      final topThree = results.length >= 3 ? results.sublist(0, 3) : results;
      
      state = state.copyWith(
        voteResults: results,
        topThree: topThree,
        totalVotes: totalVotes,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> refreshVoteResults() async {
    await loadVoteResults();
  }
}

// Providers
final voteServiceProvider = Provider<VoteService>((ref) => VoteService());

final voteNotifierProvider = StateNotifierProvider<VoteNotifier, VoteState>(
  (ref) => VoteNotifier(ref.read(voteServiceProvider)),
);