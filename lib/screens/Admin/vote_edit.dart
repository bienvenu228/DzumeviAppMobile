// import 'package:flutter/material.dart';
// import '../../services/vote_service.dart';

// class VoteEditPage extends StatefulWidget {
//   final String? voteId; // null = create
//   final String? initialName;
//   final String? initialDate;
//   final String? initialEcheance;
//   final String? initialStatut;

//   const VoteEditPage({super.key, this.voteId, this.initialName, this.initialDate, this.initialEcheance, this.initialStatut});

//   @override
//   State<VoteEditPage> createState() => _VoteEditPageState();
// }

// class _VoteEditPageState extends State<VoteEditPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameCtrl = TextEditingController();
//   final _dateCtrl = TextEditingController();
//   final _echeanceCtrl = TextEditingController();
//   final _statutCtrl = TextEditingController();
//   final VoteService _service = VoteService();
//   bool _loading = false;

//   @override
//   void initState() {
//     super.initState();
//     _nameCtrl.text = widget.initialName ?? '';
//     _dateCtrl.text = widget.initialDate ?? '';
//     _echeanceCtrl.text = widget.initialEcheance ?? '';
//     _statutCtrl.text = widget.initialStatut ?? '';
//   }

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _dateCtrl.dispose();
//     _echeanceCtrl.dispose();
//     _statutCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _loading = true);
//     final body = {
//       'name': _nameCtrl.text.trim(),
//       'date': _dateCtrl.text.trim(),
//       'echeance': _echeanceCtrl.text.trim(),
//       'statuts': _statutCtrl.text.trim(),
//     };
//     try {
//       if (widget.voteId == null) {
//         await _service.createVote(body);
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Concours créé')));
//       } else {
//         await _service.updateVote(widget.voteId! as int, body);
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Concours mis à jour')));
//       }
//       if (mounted) Navigator.pop(context, true);
//     } catch (e) {
//       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isEdit = widget.voteId != null;
//     return Scaffold(
//       appBar: AppBar(title: Text(isEdit ? 'Éditer Concours' : 'Créer Concours')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Nom'), validator: (v) => v == null || v.isEmpty ? 'Requis' : null),
//               TextFormField(controller: _dateCtrl, decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)'), validator: (v) => v == null || v.isEmpty ? 'Requis' : null),
//               TextFormField(controller: _echeanceCtrl, decoration: const InputDecoration(labelText: 'Échéance (YYYY-MM-DD)'), validator: (v) => v == null || v.isEmpty ? 'Requis' : null),
//               TextFormField(controller: _statutCtrl, decoration: const InputDecoration(labelText: 'Statut'), validator: (v) => v == null || v.isEmpty ? 'Requis' : null),
//               const SizedBox(height: 20),
//               _loading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _submit, child: Text(isEdit ? 'Mettre à jour' : 'Créer')),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
