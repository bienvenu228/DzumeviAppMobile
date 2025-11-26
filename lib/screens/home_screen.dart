import 'package:dzumevimobile/core/services/api_service.dart';
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/concours.dart';
import 'concours_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Concours>> futureConcours;

  @override
  void initState() {
    super.initState();
    futureConcours = ApiService.getConcours();
  }

  // J'ai inclus le widget _buildEmptyState pour que le code soit complet
  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  // J'ai inclus le widget _buildConcoursCard pour que le code soit complet
  Widget _buildConcoursCard(Concours concours) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ConcoursDetailScreen(concours: concours)),
      ),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.only(bottom: 20),
        child: Stack(
          children: [
            // ... (le contenu de votre _buildConcoursCard est inchangé)
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName, style: TextStyle( fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.info_outline), onPressed: () {}),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Recharger les données et mettre à jour l'état
          setState(() => futureConcours = ApiService.getConcours());
        },
        child: FutureBuilder<List<Concours>>(
          future: futureConcours,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final concoursList = snapshot.data!;
              
              // 1. TRI : Trier la liste complète EN PLACE (méthode sort retourne void)
              concoursList.sort((a, b) => a.titre.compareTo(b.titre));

              // 2. UTILISATION : On utilise la liste triée (concoursList)
              final itemsAffichees = concoursList; // Renommer pour clarté si besoin, ou utiliser directement concoursList

              if (itemsAffichees.isEmpty) {
                return _buildEmptyState("Aucun concours trouvé.");
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: itemsAffichees.length,
                itemBuilder: (context, index) {
                  final concours = itemsAffichees[index];
                  return _buildConcoursCard(concours);
                },
              );
            } else if (snapshot.hasError) {
              return _buildEmptyState("Erreur de connexion\nVérifiez votre réseau");
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}