import 'package:dzumevimobile/core/provider/concours.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants.dart';
import '../models/concours.dart';
import 'candidats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les concours au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConcoursProvider>().loadAllConcours();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.background,
      appBar: AppBar(
        title: Text(
          AppConstants.appName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppConstants.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showAppInfo(context),
          ),
        ],
      ),
      body: Consumer<ConcoursProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await provider.loadAllConcours();
            },
            backgroundColor: AppConstants.background,
            color: AppConstants.primary,
            child: _buildContent(provider),
          );
        },
      ),
    );
  }

  Widget _buildContent(ConcoursProvider provider) {
    if (provider.isLoading && provider.concoursList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error.isNotEmpty && provider.concoursList.isEmpty) {
      return _buildEmptyState(
        "Erreur de chargement",
        provider.error,
        () => provider.loadAllConcours(),
      );
    }

    final concoursActifs = provider.concoursList.where((c) => c.isActive).toList();

    if (concoursActifs.isEmpty) {
      return _buildEmptyState(
        "Aucun concours en cours",
        "Revenez plus tard pour découvrir les nouveaux concours",
        () => provider.loadAllConcours(),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: concoursActifs.length,
      itemBuilder: (context, index) {
        final concours = concoursActifs[index];
        return _buildConcoursCard(concours);
      },
    );
  }

  Widget _buildConcoursCard(Concours concours) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CandidatsScreen(concours: concours)),
      ),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.only(bottom: 20),
        child: Stack(
          children: [
            // Fond par défaut
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: _buildDefaultBackground(),
            ),

            // Dégradé overlay
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
            ),

            // Contenu texte
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    concours.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Clôture le ${_formatDate(concours.echeance)}",
                    style: TextStyle(
                      color: AppConstants.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.people, color: Colors.white70, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        "${concours.nombreCandidats} candidats",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.how_to_vote, color: Colors.white70, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        "${concours.nombreVotes} votes",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Badge statut
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppConstants.secondary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  "EN COURS",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultBackground() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.primary.withOpacity(0.8),
            AppConstants.secondary.withOpacity(0.6),
          ],
        ),
      ),
      child: Icon(
        Icons.emoji_events,
        size: 60,
        color: Colors.white.withOpacity(0.7),
      ),
    );
  }

  Widget _buildEmptyState(String title, String message, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 80,
              color: AppConstants.primary.withOpacity(0.7),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Réessayer",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void _showAppInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "À propos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Plateforme de vote et de concours",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              "Participez à vos concours préférés et votez pour vos candidats favoris en utilisant Mobile Money.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fermer"),
          ),
        ],
      ),
    );
  }
}
