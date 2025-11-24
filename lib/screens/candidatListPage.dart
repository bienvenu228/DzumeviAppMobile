// lib/pages/candidat_list_page.dart
import 'package:dzumevimobile/layout/CandidatCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/candidat_provider.dart';

// Constantes de paiement
const List<String> availablePaymentModes = ['mtn_open', 'moov', 'airtel', 't_money'];
const double defaultVoteAmount = 100.0;
const String defaultCurrency = 'XOF';
const String defaultCountry = 'BJ';

class CandidatListPage extends ConsumerStatefulWidget {
  const CandidatListPage({super.key});

  @override
  ConsumerState<CandidatListPage> createState() => _CandidatListPageState();
}

class _CandidatListPageState extends ConsumerState<CandidatListPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Charger les candidats au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(candidatNotifierProvider.notifier).loadCandidats();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _refreshCandidats() async {
    await ref.read(candidatNotifierProvider.notifier).loadCandidats();
  }

  @override
  Widget build(BuildContext context) {
    final candidatState = ref.watch(candidatNotifierProvider);
    final candidatNotifier = ref.read(candidatNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Rechercher un candidat...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
                autofocus: true,
                onChanged: (value) {
                  candidatNotifier.searchCandidats(value);
                },
              )
            : const Text('Toutes les candidates'),
        elevation: 0,
        actions: [
          // Bouton recherche
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  candidatNotifier.searchCandidats('');
                }
              });
            },
          ),
          // Bouton rafraîchir
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCandidats,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres par catégorie (scroll horizontal pour mobile)
          _buildCategoryFilter(candidatState, candidatNotifier),
          
          // Liste des candidats
          Expanded(
            child: _buildCandidatList(candidatState),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(CandidatState state, CandidatNotifier notifier) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.categories.length,
        itemBuilder: (context, index) {
          final category = state.categories[index];
          final isSelected = state.selectedCategory == category;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                notifier.filterByCategory(category);
              },
              backgroundColor: isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCandidatList(CandidatState state) {
    if (state.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Erreur de chargement',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                state.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _refreshCandidats,
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    final candidatsToShow = state.searchQuery.isNotEmpty || state.selectedCategory != 'Tous'
        ? state.filteredCandidats
        : state.candidats;

    if (candidatsToShow.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              state.searchQuery.isNotEmpty ? 'Aucun résultat' : 'Aucun candidat',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.searchQuery.isNotEmpty
                  ? 'Aucun candidat ne correspond à votre recherche'
                  : 'Aucun candidat n\'a été créé dans le backend',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _refreshCandidats(),
      child: GridView.builder(
        padding: const EdgeInsets.all(12.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getCrossAxisCount(context),
          childAspectRatio: _getChildAspectRatio(context),
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
        ),
        itemCount: candidatsToShow.length,
        itemBuilder: (context, index) {
          final candidat = candidatsToShow[index];
          return CandidatCard(candidat: candidat);
        },
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 2; // Mobile
    if (width < 900) return 3; // Tablet
    return 4; // Desktop
  }

  double _getChildAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 0.65; // Mobile - plus étroit
    return 0.55; // Tablet/Desktop
  }
}