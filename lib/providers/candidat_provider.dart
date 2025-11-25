// lib/providers/candidat_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/candidat.dart';
import '../models/payment_details.dart';
import '../services/candidat_service.dart';

class CandidatState {
  final List<Candidat> candidats;
  final List<Candidat> filteredCandidats;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String selectedCategory;

  const CandidatState({
    this.candidats = const [],
    this.filteredCandidats = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.selectedCategory = 'Tous',
  });

  List<String> get categories {
    final categories = candidats
        .map((c) => c.categorie)
        .where((category) => category != null && category.isNotEmpty)
        .toSet()
        .toList();
    return ['Tous', ...categories.cast<String>()];
  }

  CandidatState copyWith({
    List<Candidat>? candidats,
    List<Candidat>? filteredCandidats,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return CandidatState(
      candidats: candidats ?? this.candidats,
      filteredCandidats: filteredCandidats ?? this.filteredCandidats,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class CandidatNotifier extends StateNotifier<CandidatState> {
  final CandidatService _candidatService;

  CandidatNotifier(this._candidatService) : super(const CandidatState());

  Future<void> loadCandidats() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final candidats = await _candidatService.fetchCandidats();
      state = state.copyWith(
        candidats: candidats,
        filteredCandidats: _applyFilters(candidats, state.searchQuery, state.selectedCategory),
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

  Future<Map<String, dynamic>> voteForCandidat(PaymentDetails paymentDetails) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _candidatService.voteForCandidat(paymentDetails);
      state = state.copyWith(isLoading: false);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  void searchCandidats(String query) {
    final filtered = _applyFilters(state.candidats, query, state.selectedCategory);
    state = state.copyWith(
      searchQuery: query,
      filteredCandidats: filtered,
    );
  }

  void filterByCategory(String category) {
    final filtered = _applyFilters(state.candidats, state.searchQuery, category);
    state = state.copyWith(
      selectedCategory: category,
      filteredCandidats: filtered,
    );
  }

  void clearFilters() {
    state = state.copyWith(
      searchQuery: '',
      selectedCategory: 'Tous',
      filteredCandidats: state.candidats,
    );
  }

  List<Candidat> _applyFilters(List<Candidat> candidats, String query, String category) {
    List<Candidat> filtered = candidats;

    // Filtre par recherche
    if (query.isNotEmpty) {
      filtered = filtered.where((candidat) =>
        candidat.firstname.toLowerCase().contains(query.toLowerCase()) ||
        candidat.matricule.toLowerCase().contains(query.toLowerCase()) == true
      ).toList();
    }

    // Filtre par catégorie
    if (category != 'Tous') {
      filtered = filtered.where((candidat) =>
        candidat.categorie.toLowerCase() == category.toLowerCase()
      ).toList();
    }

    return filtered;
  }
}

// Providers
final candidatServiceProvider = Provider<CandidatService>((ref) => CandidatService());

final candidatNotifierProvider = StateNotifierProvider<CandidatNotifier, CandidatState>(
  (ref) => CandidatNotifier(ref.read(candidatServiceProvider)),
);