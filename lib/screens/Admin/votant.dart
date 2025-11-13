import 'package:flutter/material.dart';
import '../../../services/votant_service.dart';

class VotantScreen extends StatefulWidget {
  const VotantScreen({super.key});

  @override
  State<VotantScreen> createState() => _VotantScreenState();
}

class _VotantScreenState extends State<VotantScreen> {
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = VotantService.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des votants')),
      body: FutureBuilder<List<dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun votant trouvé'));
          }

          final votants = snapshot.data!;
          return ListView.builder(
            itemCount: votants.length,
            itemBuilder: (context, i) {
              final v = votants[i];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(v['nom'][0].toUpperCase()),
                ),
                title: Text(v['nom']),
                subtitle: Text(v['email'] ?? 'Aucun email'),
              );
            },
          );
        },
      ),
    );
  }
}
