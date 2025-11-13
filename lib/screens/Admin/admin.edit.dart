import 'package:flutter/material.dart';
import '../../../services/admin_service.dart';
import '../../../models/admin.dart';

class AdminEditScreen extends StatefulWidget {
  const AdminEditScreen({super.key});

  @override
  State<AdminEditScreen> createState() => _AdminEditScreenState();
}

class _AdminEditScreenState extends State<AdminEditScreen> {
  late Future<Admin> _future;
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _future = AdminService.getProfile();
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final ok = await AdminService.updateProfile(nameCtrl.text, emailCtrl.text);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(ok ? "Profil mis à jour" : "Erreur de mise à jour"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modifier le profil")),
      body: FutureBuilder<Admin>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }

          final admin = snapshot.data!;
          nameCtrl.text = admin.name;
          emailCtrl.text = admin.email;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: "Nom"),
                    validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(labelText: "Email"),
                    validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text("Sauvegarder"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
