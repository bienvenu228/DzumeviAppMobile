// lib/screens/home_screen.dart
import 'package:dzumevimobile/core/constants.dart';
import 'package:dzumevimobile/core/provider/concours.dart';
import 'package:dzumevimobile/models/concours.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/concours_card.dart';
import 'candidats_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConcoursProvider>().loadAllConcours();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onConcoursTap(Concours concours) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CandidatsScreen(concours: concours),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.background, // Utilisation de votre thème
      appBar: AppBar(
        title: const Text(
          'Concours Disponibles',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<ConcoursProvider>(
        builder: (context, provider, child) {
          final filteredConcours = _searchQuery.isEmpty
              ? provider.concoursList
              : provider.searchConcours(_searchQuery);

          if (provider.isLoading && provider.concoursList.isEmpty) {
            return _buildLoadingState();
          }

          if (provider.error.isNotEmpty && provider.concoursList.isEmpty) {
            return _buildErrorState(provider.error, () {
              provider.loadAllConcours();
            });
          }

          if (filteredConcours.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              // Barre de recherche
              _buildSearchBar(context),

              // Statistiques
              _buildStats(provider, context),

              // Liste des concours
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => provider.loadAllConcours(),
                  backgroundColor: AppConstants.background,
                  color: AppConstants.primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: filteredConcours.length,
                    itemBuilder: (context, index) {
                      final concours = filteredConcours[index];
                      return ConcoursCard(
                        concours: concours,
                        onTap: () => _onConcoursTap(concours),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Rechercher un concours...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface, // Utilisation du thème
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildStats(ConcoursProvider provider, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildStatCard(
            'En Cours',
            provider.concoursEnCours.length.toString(),
            Colors.green,
            context,
          ),
          const SizedBox(width: 8),
          _buildStatCard(
            'À Venir',
            provider.concoursAVenir.length.toString(),
            Colors.orange,
            context,
          ),
          const SizedBox(width: 8),
          _buildStatCard(
            'Terminés',
            provider.concoursPasses.length.toString(),
            Colors.red,
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600, // Utilisation de votre typographie
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppConstants.primary), // Votre couleur primaire
          const SizedBox(height: 16),
          Text(
            'Chargement des concours...',
            style: TextStyle(
              fontSize: 16, 
              color: Colors.grey,
              fontWeight: FontWeight.w500, // Votre typographie
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppConstants.error, // Votre couleur d'erreur
            ),
            const SizedBox(height: 16),
            Text(
              'Oups !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600, // Votre typographie
                color: AppConstants.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primary, // Votre couleur primaire
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Votre border radius
                ),
              ),
              child: const Text(
                'Réessayer',
                style: TextStyle(fontWeight: FontWeight.w600), // Votre typographie
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        _buildSearchBar(context),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_busy,
                  size: 80,
                  color: AppConstants.primary, // Votre couleur primaire
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucun concours trouvé',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600, // Votre typographie
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _searchQuery.isEmpty
                      ? 'Aucun concours n\'est disponible pour le moment.'
                      : 'Aucun concours ne correspond à votre recherche.',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}