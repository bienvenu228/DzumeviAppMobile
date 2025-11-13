import 'package:flutter/material.dart';
import '../../models/candidat.dart';
import '../../services/candidat_service.dart';

class GestionCandidatsScreen extends StatefulWidget {
  const GestionCandidatsScreen({super.key});

  @override
  State<GestionCandidatsScreen> createState() => _GestionCandidatsScreenState();
}

class _GestionCandidatsScreenState extends State<GestionCandidatsScreen> {
  late Future<List<Candidat>> _futureCandidats;

  @override
  void initState() {
    super.initState();
    _chargerCandidats();
  }

  void _chargerCandidats() {
    setState(() {
      _futureCandidats = CandidatService.getAll();
    });
  }

  void _supprimerCandidat(int id) async {
    try {
      await CandidatService.delete(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Candidat supprimé")),
      );
      _chargerCandidats();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }
  }

  void _openForm({Candidat? candidat}) {
    final _formKey = GlobalKey<FormState>();
    final firstnameCtrl = TextEditingController(text: candidat?.firstname ?? '');
    final lastnameCtrl = TextEditingController(text: candidat?.lastname ?? '');
    final categorieCtrl = TextEditingController(text: candidat?.categorie ?? '');
    final photoCtrl = TextEditingController(text: candidat?.photo ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(candidat == null ? "Ajouter Candidat" : "Modifier Candidat"),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: firstnameCtrl,
                  decoration: const InputDecoration(labelText: "Prénom"),
                  validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
                ),
                TextFormField(
                  controller: lastnameCtrl,
                  decoration: const InputDecoration(labelText: "Nom"),
                  validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
                ),
                TextFormField(
                  controller: categorieCtrl,
                  decoration: const InputDecoration(labelText: "Catégorie"),
                  validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
                ),
                TextFormField(
                  controller: photoCtrl,
                  decoration: const InputDecoration(labelText: "URL Photo"),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;

              final newCandidat = Candidat(
                id: candidat?.id ?? 0,
                firstname: firstnameCtrl.text,
                lastname: lastnameCtrl.text,
                categorie: categorieCtrl.text,
                photo: photoCtrl.text,
              );

              try {
                if (candidat == null) {
                  await CandidatService.add(newCandidat);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("✅ Candidat ajouté")),
                  );
                } else {
                  await CandidatService.update(candidat.id, newCandidat);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("✅ Candidat modifié")),
                  );
                }
                Navigator.pop(context);
                _chargerCandidats();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Erreur : $e")),
                );
              }
            },
            child: Text(candidat == null ? "Ajouter" : "Modifier"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des candidats"),
        backgroundColor: Colors.indigo,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Candidat>>(
        future: _futureCandidats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun candidat trouvé"));
          }

          final candidats = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: candidats.length,
            itemBuilder: (context, index) {
              final c = candidats[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(c.photo),
                  ),
                  title: Text("${c.firstname} ${c.lastname}"),
                  subtitle: Text("Catégorie : ${c.categorie}"),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'modifier') _openForm(candidat: c);
                      if (value == 'supprimer') _supprimerCandidat(c.id);
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'modifier', child: Text("Modifier")),
                      PopupMenuItem(value: 'supprimer', child: Text("Supprimer")),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
