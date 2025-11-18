// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/widgets.dart' as pw;
// import '../../services/candidat_service.dart';
// import '../../models/candidat.dart';

// class ContestDetailPage extends StatefulWidget {
//   final String voteId;
//   final String voteName;

//   const ContestDetailPage({super.key, required this.voteId, required this.voteName});

//   @override
//   State<ContestDetailPage> createState() => _ContestDetailPageState();
// }

// class _ContestDetailPageState extends State<ContestDetailPage> {
//   final CandidatService _service = CandidatService();
//   List<Candidat> _candidats = [];
//   bool _isLoading = true;
//   Timer? _poller;
//   final Map<String, int> _lastVotes = {};

//   @override
//   void initState() {
//     super.initState();
//     _load();
//     // Poll every 5 seconds to simulate real-time updates
//     _poller = Timer.periodic(const Duration(seconds: 5), (_) => _load());
//   }

//   @override
//   void dispose() {
//     _poller?.cancel();
//     super.dispose();
//   }

//   Future<void> _load() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       _candidats = await _service.getCandidatsByVote(widget.voteId as int);
//         for (final c in _candidats) {
//           _lastVotes.putIfAbsent(c.id.toString(), () => c.votes ?? 0);
//         }
//     } catch (e) {
//       // ignore for now
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _createCandidate() async {
//     final firstnameCtrl = TextEditingController();
//     final matriculeCtrl = TextEditingController();
//     final descriptionCtrl = TextEditingController();
//     final categorieCtrl = TextEditingController();

//     final formKey = GlobalKey<FormState>();

//     final result = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Ajouter un candidat'),
//         content: Form(
//           key: formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextFormField(controller: firstnameCtrl, decoration: const InputDecoration(labelText: 'Prénom'), validator: (v) => v == null || v.isEmpty ? 'Requis' : null),
//                 TextFormField(controller: matriculeCtrl, decoration: const InputDecoration(labelText: 'Matricule'), validator: (v) => v == null || v.isEmpty ? 'Requis' : null),
//                 TextFormField(controller: categorieCtrl, decoration: const InputDecoration(labelText: 'Catégorie'), validator: (v) => v == null || v.isEmpty ? 'Requis' : null),
//                 TextFormField(controller: descriptionCtrl, decoration: const InputDecoration(labelText: 'Description')),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
//           ElevatedButton(
//             onPressed: () async {
//               if (formKey.currentState!.validate()) {
//                 Navigator.pop(context, true);
//               }
//             },
//             child: const Text('Créer'),
//           ),
//         ],
//       ),
//     );

//     if (result == true) {
//       try {
//         final body = {
//           'firstname': firstnameCtrl.text.trim(),
//           'matricule': matriculeCtrl.text.trim(),
//           'description': descriptionCtrl.text.trim(),
//           'categorie': categorieCtrl.text.trim(),
//           'vote_id': widget.voteId,
//         };
//         await _service.createCandidat(body);
//         await _load();
//         if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Candidat créé')));
//       } catch (e) {
//         if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
//       }
//     }
//   }

//   Future<void> _deleteCandidate(String id) async {
//     final ok = await showDialog<bool>(
//       context: context,
//       builder: (c) => AlertDialog(
//         title: const Text('Supprimer'),
//         content: const Text('Confirmer la suppression du candidat ?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Annuler')),
//           TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Supprimer', style: TextStyle(color: Colors.red))),
//         ],
//       ),
//     );
//     if (ok == true) {
//       try {
//         await _service.deleteCandidat(id as int);
//         await _load();
//         if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Candidat supprimé')));
//       } catch (e) {
//         if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
//       }
//     }
//   }

//   Future<void> _editCandidate(Candidat candidate) async {
//     final firstnameCtrl = TextEditingController(text: candidate.firstname ?? '');
//     final matriculeCtrl = TextEditingController(text: candidate.matricule ?? '');
//     final descriptionCtrl = TextEditingController(text: candidate.description ?? '');
//     final categorieCtrl = TextEditingController(text: candidate.categorie ?? '');

//     final formKey = GlobalKey<FormState>();

//     final result = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Modifier le candidat'),
//         content: Form(
//           key: formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextFormField(controller: firstnameCtrl, decoration: const InputDecoration(labelText: 'Prénom'), validator: (v) => v == null || v.isEmpty ? 'Requis' : null),
//                 TextFormField(controller: matriculeCtrl, decoration: const InputDecoration(labelText: 'Matricule'), validator: (v) => v == null || v.isEmpty ? 'Requis' : null),
//                 TextFormField(controller: categorieCtrl, decoration: const InputDecoration(labelText: 'Catégorie'), validator: (v) => v == null || v.isEmpty ? 'Requis' : null),
//                 TextFormField(controller: descriptionCtrl, decoration: const InputDecoration(labelText: 'Description')),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
//           ElevatedButton(
//             onPressed: () async {
//               if (formKey.currentState!.validate()) Navigator.pop(context, true);
//             },
//             child: const Text('Enregistrer'),
//           ),
//         ],
//       ),
//     );

//     if (result == true) {
//       try {
//         final body = {
//           'firstname': firstnameCtrl.text.trim(),
//           'matricule': matriculeCtrl.text.trim(),
//           'description': descriptionCtrl.text.trim(),
//           'categorie': categorieCtrl.text.trim(),
//         };
//         await _service.updateCandidat(candidate.id.toString() as int, body);
//         await _load();
//         if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Candidat mis à jour')));
//       } catch (e) {
//         if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
//       }
//     }
//   }

//   Future<void> _exportCsv() async {
//     if (_candidats.isEmpty) return;
//     final sb = StringBuffer();
//     sb.writeln('id,firstname,matricule,categorie,description,votes');
//     for (final c in _candidats) {
//   sb.writeln('${c.id},"${c.firstname ?? c.nom ?? ''}",${c.matricule ?? ''},"${c.categorie ?? ''}","${(c.description ?? '').toString().replaceAll('"', '""')}",${c.votes ?? 0}');
//     }

//     try {
//       final dir = await getApplicationDocumentsDirectory();
//       final file = File('${dir.path}/contest_${widget.voteId}_export.csv');
//       await file.writeAsString(sb.toString());
//       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exporté: ${file.path}')));
//     } catch (e) {
//       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur export: $e')));
//     }
//   }

//   Future<void> _exportPdf() async {
//     if (_candidats.isEmpty) return;
//     final pdf = pw.Document();

//     pdf.addPage(pw.Page(build: (pw.Context ctx) {
//       return pw.Column(children: [
//         pw.Text('Résultats - ${widget.voteName}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//         pw.SizedBox(height: 10),
//         pw.Table.fromTextArray(
//           headers: ['ID', 'Nom', 'Matricule', 'Catégorie', 'Votes'],
//           data: _candidats.map((c) => [c.id.toString(), c.firstname ?? c.nom ?? '', c.matricule ?? '', c.categorie ?? '', (c.votes ?? 0).toString()]).toList(),
//         )
//       ]);
//     }));

//     try {
//       final bytes = await pdf.save();
//       final dir = await getApplicationDocumentsDirectory();
//       final file = File('${dir.path}/contest_${widget.voteId}_results.pdf');
//       await file.writeAsBytes(bytes);
//       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF exporté: ${file.path}')));
//     } catch (e) {
//       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur export PDF: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Concours: ${widget.voteName}'),
//         actions: [
//           IconButton(onPressed: _exportCsv, icon: const Icon(Icons.file_download), tooltip: 'Exporter CSV'),
//           IconButton(onPressed: _exportPdf, icon: const Icon(Icons.picture_as_pdf), tooltip: 'Exporter PDF'),
//           IconButton(onPressed: _createCandidate, icon: const Icon(Icons.add), tooltip: 'Ajouter candidat'),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : RefreshIndicator(
//               onRefresh: _load,
//               child: ListView.builder(
//                 itemCount: _candidats.length,
//                 itemBuilder: (context, i) {
//                   final c = _candidats[i];
//                   final prev = _lastVotes[c.id.toString()] ?? 0;
//                   final changed = (c.votes ?? 0) > prev;
//                   // update lastVotes for next render
//                   _lastVotes[c.id.toString()] = c.votes ?? 0;
//                   return ListTile(
//                     title: Text(c.firstname ?? c.nom ?? '—'),
//                     subtitle: Text('Matricule: ${c.matricule ?? '-'} • Votes: ${c.votes ?? 0}'),
//                     leading: changed ? const Icon(Icons.trending_up, color: Colors.green) : null,
//                     onTap: () => _editCandidate(c),
//                     trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteCandidate(c.id.toString())),
//                   );
//                 },
//               ),
//             ),
//     );
//   }
// }
