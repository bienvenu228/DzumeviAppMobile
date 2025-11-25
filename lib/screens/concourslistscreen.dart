import 'package:dzumevimobile/core/services/api_service.dart';
import 'package:dzumevimobile/screens/concours_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:dzumevimobile/models/concours.dart';

class ConcoursListScreen extends StatefulWidget {
  const ConcoursListScreen({Key? key}) : super(key: key);

  @override
  _ConcoursListScreenState createState() => _ConcoursListScreenState();
}

class _ConcoursListScreenState extends State<ConcoursListScreen> {
  late Future<List<Concours>> _concoursFuture;

  @override
  void initState() {
    super.initState();
    _concoursFuture = ApiService.getConcours();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Concours disponibles")),
      body: FutureBuilder<List<Concours>>(
        future: _concoursFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erreur: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun concours disponible"));
          } else {
            final concoursList = snapshot.data!;
            return ListView.builder(
              itemCount: concoursList.length,
              itemBuilder: (context, index) {
                final concours = concoursList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image du concours
                      if (concours.image.isNotEmpty)
                        Image.network(
                          concours.image,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey[300],
                                height: 180,
                                child: const Center(child: Icon(Icons.image)),
                              ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              concours.titre,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              concours.description,
                              style: const TextStyle(fontSize: 14),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Du ${concours.dateDebut.toLocal().toString().split(' ')[0]} au ${concours.dateFin.toLocal().toString().split(' ')[0]}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  concours.estEnCours ? "En cours" : "Terminé",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: concours.estEnCours ? Colors.green : Colors.red,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: concours.estEnCours
                                      ? () {
                                          // Naviguer vers les détails du concours
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ConcoursDetailScreen(concours: concours),
                                            ),
                                          );
                                        }
                                      : null,
                                  child: const Text("Voir les candidats"),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
