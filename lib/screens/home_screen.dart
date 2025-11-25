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
          setState(() => futureConcours = ApiService.getConcours());
        },
        child: FutureBuilder<List<Concours>>(
          future: futureConcours,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final concoursList = snapshot.data!;
              final actifs = concoursList.where((c) => c.estEnCours).toList();

              if (actifs.isEmpty) {
                return _buildEmptyState("Aucun concours en cours pour le moment");
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: actifs.length,
                itemBuilder: (context, index) {
                  final concours = actifs[index];
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
            // Image de fond
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: concours.image.isNotEmpty
                  ? Image.network(concours.image, height: 220, width: double.infinity, fit: BoxFit.cover)
                  : Container(height: 220, color: AppConstants.primary.withOpacity(0.8)),
            ),
            // Dégradé + texte
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    concours.titre,
                    style: TextStyle( fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Clôture le ${concours.dateFin.day}/${concours.dateFin.month}/${concours.dateFin.year}",
                    style: TextStyle(color: AppConstants.secondary, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.how_to_vote, color: Colors.white70),
                      SizedBox(width: 6),
                      Text("${concours.totalVotes} votes • ${concours.totalRecettes} FCFA collectés",
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Chip(
                backgroundColor: AppConstants.secondary,
                label: Text("EN COURS", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
}