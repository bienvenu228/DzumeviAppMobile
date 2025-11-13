import 'package:flutter/material.dart';
import '../../../models/concours.dart';
import '../../../services/concours_service.dart';

class GestionConcoursScreen extends StatefulWidget {
  const GestionConcoursScreen({super.key});

  @override
  State<GestionConcoursScreen> createState() => _GestionConcoursScreenState();
}

class _GestionConcoursScreenState extends State<GestionConcoursScreen> {
  late Future<List<Concours>> _futureConcours;

  @override
  void initState() {
    super.initState();
    _chargerConcours();
  }

  void _chargerConcours() {
    setState(() {
      _futureConcours = ConcoursService.getAll();
    });
  }

  void _supprimerConcours(int id) async {
    try {
      await ConcoursService.delete(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Concours supprimé")),
      );
      _chargerConcours();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }
  }

  void _ouvrirFormulaire({Concours? concours}) {
    showDialog(
      context: context,
      builder: (context) => _DialogConcours(
        concours: concours,
        onSaved: () {
          Navigator.pop(context);
          _chargerConcours();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des concours"),
        backgroundColor: Colors.indigo,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () => _ouvrirFormulaire(),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Concours>>(
        future: _futureConcours,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun concours trouvé"));
          }

          final concoursList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: concoursList.length,
            itemBuilder: (context, index) {
              final c = concoursList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(c.name),
                  subtitle: Text("Statut : ${c.statut}\nÉchéance : ${c.echeance}"),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'modifier') _ouvrirFormulaire(concours: c);
                      if (value == 'supprimer') _supprimerConcours(c.id);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'modifier', child: Text("Modifier")),
                      const PopupMenuItem(value: 'supprimer', child: Text("Supprimer")),
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

// ---------------- Formulaire ajout/modification concours ----------------
class _DialogConcours extends StatefulWidget {
  final Concours? concours;
  final VoidCallback onSaved;

  const _DialogConcours({this.concours, required this.onSaved});

  @override
  State<_DialogConcours> createState() => _DialogConcoursState();
}

class _DialogConcoursState extends State<_DialogConcours> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomCtrl;
  late TextEditingController _dateCtrl;
  late TextEditingController _echeanceCtrl;
  late TextEditingController _statutCtrl;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nomCtrl = TextEditingController(text: widget.concours?.name ?? '');
    _dateCtrl = TextEditingController(text: widget.concours?.date ?? '');
    _echeanceCtrl = TextEditingController(text: widget.concours?.echeance ?? '');
    _statutCtrl = TextEditingController(text: widget.concours?.statut ?? '');
  }

  void _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final concours = Concours(
        id: widget.concours?.id ?? 0,
        name: _nomCtrl.text,
        date: _dateCtrl.text,
        echeance: _echeanceCtrl.text,
        statut: _statutCtrl.text,
      );

      if (widget.concours == null) {
        await ConcoursService.add(concours);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Concours ajouté avec succès")),
        );
      } else {
        await ConcoursService.update(concours);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Concours modifié avec succès")),
        );
      }

      widget.onSaved();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.concours == null ? "Ajouter un concours" : "Modifier le concours"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nomCtrl,
                decoration: const InputDecoration(labelText: "Nom"),
                validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: _dateCtrl,
                decoration: const InputDecoration(labelText: "Date (YYYY-MM-DD)"),
                validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: _echeanceCtrl,
                decoration: const InputDecoration(labelText: "Échéance (YYYY-MM-DD)"),
                validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
              ),
              TextFormField(
                controller: _statutCtrl,
                decoration: const InputDecoration(labelText: "Statut"),
                validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: const Text("Annuler"),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _enregistrer,
          child: _loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.concours == null ? "Enregistrer" : "Modifier"),
        ),
      ],
    );
  }
}
