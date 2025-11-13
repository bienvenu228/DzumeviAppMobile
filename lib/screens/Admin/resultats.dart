import 'package:flutter/material.dart';
import '../../../services/resultats_service.dart';

class ResultatsScreen extends StatefulWidget {
  const ResultatsScreen({super.key});

  @override
  State<ResultatsScreen> createState() => _ResultatsScreenState();
}

class _ResultatsScreenState extends State<ResultatsScreen> {
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = ResultatsService.getResultats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Résultats des votes')),
      body: FutureBuilder<List<dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun résultat'));
          }

          final resultats = snapshot.data!;
          return ListView.builder(
            itemCount: resultats.length,
            itemBuilder: (context, i) {
              final r = resultats[i];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(r['candidat']),
                  subtitle: Text('Total de votes : ${r['votes']}'),
                  trailing: Text(r['categorie']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
